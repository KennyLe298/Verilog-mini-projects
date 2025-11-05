module deco_top(
    input wire CLK100MHZ,
    input wire [1:0] SW,
    input wire [3:0] BTN,
    output wire [3:0] LED,

    output wire [3:0] DIGIT0,
    output wire [3:0] DIGIT1,
    output wire [3:0] DIGIT2,
    output wire [3:0] DIGIT3
);

    wire reset = SW[1];
    wire mode_sw = SW[0];
    wire inc_speed_btn = BTN[0];
    wire dec_speed_btn = BTN[1];
    
    wire tick_100hz;
    wire inc_pulse, dec_pulse;

    clock_divider u_clkdiv(
        .clk(CLK100MHZ),
        .reset(reset),
        .tick_100hz(tick_100hz)
    );

    scroller_fsm u_fsm(
        .clk(CLK100MHZ),
        .reset(reset),
        .tick_100hz(tick_100hz),
        .mode_sw(mode_sw),
        .inc_speed_btn(inc_speed_btn),
        .dec_speed_btn(dec_speed_btn),
        .inc_pulse_out(inc_pulse),
        .dec_pulse_out(dec_pulse),
        
        .digit_data_out_0(DIGIT0),
        .digit_data_out_1(DIGIT1),
        .digit_data_out_2(DIGIT2),
        .digit_data_out_3(DIGIT3)
    );

    assign LED[0] = ~mode_sw; // LED 0 on for Effect 1
    assign LED[1] = mode_sw;  // LED 1 on for Effect 2
    assign LED[2] = inc_pulse;
    assign LED[3] = dec_pulse;
    
endmodule