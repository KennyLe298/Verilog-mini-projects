module scroller_fsm(
    input wire clk,
    input wire reset,
    input wire tick_100hz,      // 10ms tick
    input wire mode_sw,         // 0=Wrap, 1=Bounce
    input wire inc_speed_btn,
    input wire dec_speed_btn,
    output reg inc_pulse_out,
    output reg dec_pulse_out,
    
    output reg [3:0] digit_data_out_0,
    output reg [3:0] digit_data_out_1,
    output reg [3:0] digit_data_out_2,
    output reg [3:0] digit_data_out_3
);
    localparam CODE_2     = 4'd2;
    localparam CODE_5     = 4'd5;
    localparam CODE_BLANK = 4'd15; // 1111 - blank

    reg [7:0] speed_reg;
    reg [7:0] speed_counter;
    reg scroll_enable;
    reg inc_prev, dec_prev;

    // Wrap effect
    reg [2:0] state_e1;

    // Bounce effect
    reg [1:0] state_e2;
    reg dir_e2;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            speed_reg <= 8'd20; 
            speed_counter <= 8'd0;
            scroll_enable <= 1'b0;
            inc_prev <= 1'b0;
            dec_prev <= 1'b0;
            // reset the effects
            state_e1 <= 3'd0;
            state_e2 <= 2'd0;
            dir_e2 <= 1'b0;
            // reset the pulses
            inc_pulse_out <= 1'b0;
            dec_pulse_out <= 1'b0;
        end else begin
            inc_prev <= inc_speed_btn;
            dec_prev <= dec_speed_btn;
            inc_pulse_out <= (inc_speed_btn && !inc_prev);
            dec_pulse_out <= (dec_speed_btn && !dec_prev);

            if (inc_speed_btn && !inc_prev && speed_reg > 5)
                speed_reg <= speed_reg - 5;
            if (dec_speed_btn && !dec_prev && speed_reg < 100)
                speed_reg <= speed_reg + 5;
                
            if (tick_100hz) begin
                if (speed_counter == speed_reg) begin
                    speed_counter <= 8'd0;
                    scroll_enable <= 1'b1;
                end else begin
                    speed_counter <= speed_counter + 1;
                    scroll_enable <= 1'b0;
                end
            end else begin
                scroll_enable <= 1'b0;
            end
            
            // FSM 
            if (scroll_enable) begin
                // wrap
                state_e1 <= (state_e1 == 5) ? 0 : state_e1 + 1;

                // bounce
                if (dir_e2 == 0) begin // shift right
                    if (state_e2 == 2) begin dir_e2 <= 1'b1; state_e2 <= state_e2 - 1; end
                    else state_e2 <= state_e2 + 1;
                end else begin // shift left
                    if (state_e2 == 0) begin dir_e2 <= 1'b0; state_e2 <= state_e2 + 1; end
                    else state_e2 <= state_e2 - 1;
                end
            end
        end
    end
    
    always @(*) begin
        if (mode_sw == 0) begin //wrap
            case (state_e1)
                //               {D0_Left}   {D1}        {D2}        {D3_Right}
                0: begin digit_data_out_0=CODE_2;     digit_data_out_1=CODE_BLANK; digit_data_out_2=CODE_BLANK; digit_data_out_3=CODE_BLANK; end // 2___
                1: begin digit_data_out_0=CODE_2;     digit_data_out_1=CODE_5;     digit_data_out_2=CODE_BLANK; digit_data_out_3=CODE_BLANK; end // 25__
                2: begin digit_data_out_0=CODE_BLANK; digit_data_out_1=CODE_2;     digit_data_out_2=CODE_5;     digit_data_out_3=CODE_BLANK; end // _25_
                3: begin digit_data_out_0=CODE_BLANK; digit_data_out_1=CODE_BLANK; digit_data_out_2=CODE_2;     digit_data_out_3=CODE_5;     end // __25
                4: begin digit_data_out_0=CODE_BLANK; digit_data_out_1=CODE_BLANK; digit_data_out_2=CODE_BLANK; digit_data_out_3=CODE_5;     end // ___5
                5: begin digit_data_out_0=CODE_BLANK; digit_data_out_1=CODE_BLANK; digit_data_out_2=CODE_BLANK; digit_data_out_3=CODE_BLANK; end // ____
                default: begin digit_data_out_0=CODE_BLANK; digit_data_out_1=CODE_BLANK; digit_data_out_2=CODE_BLANK; digit_data_out_3=CODE_BLANK; end
            endcase
        end else begin // bounce
            case (state_e2)
                0: begin digit_data_out_0=CODE_2;     digit_data_out_1=CODE_5;     digit_data_out_2=CODE_BLANK; digit_data_out_3=CODE_BLANK; end // 25__
                1: begin digit_data_out_0=CODE_BLANK; digit_data_out_1=CODE_2;     digit_data_out_2=CODE_5;     digit_data_out_3=CODE_BLANK; end // _25_
                2: begin digit_data_out_0=CODE_BLANK; digit_data_out_1=CODE_BLANK; digit_data_out_2=CODE_2;     digit_data_out_3=CODE_5;     end // __25
                default: begin digit_data_out_0=CODE_BLANK; digit_data_out_1=CODE_BLANK; digit_data_out_2=CODE_BLANK; digit_data_out_3=CODE_BLANK; end
            endcase
        end
    end
endmodule