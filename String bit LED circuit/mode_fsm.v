module mode_fsm(
    input clk, reset,
    input btn_reset, btn_left, btn_right, btn_pause,
    output reg [1:0] mode // 00=reset, 01=left, 10=right, 11=pause
);
    reg btn_reset_prev, btn_left_prev, btn_right_prev, btn_pause_prev;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mode <= 2'b00;
            btn_reset_prev <= 0;
            btn_left_prev <= 0;
            btn_right_prev <= 0;
            btn_pause_prev <= 0;
        end else begin
            // Edge detection
            btn_reset_prev <= btn_reset;
            btn_left_prev <= btn_left;
            btn_right_prev <= btn_right;
            btn_pause_prev <= btn_pause;
            
            // Mode changes on rising edge only
            if (btn_reset && !btn_reset_prev) mode <= 2'b00;
            else if (btn_left && !btn_left_prev)  mode <= 2'b01;
            else if (btn_right && !btn_right_prev) mode <= 2'b10;
            else if (btn_pause && !btn_pause_prev) mode <= 2'b11;
        end
    end
endmodule