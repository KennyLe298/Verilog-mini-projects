`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2025 10:47:52 AM
// Design Name: 
// Module Name: exercise3_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module exercise3_top(
    input CLK100MHZ,
    input [3:0] BTN,
    output [3:0] LED,
    output UART_TX
);
   wire tick;
    // Instantiate with the 1-second DIV value
    clock_divider #(.DIV(100_000_000)) div(
        .clk(CLK100MHZ), 
        .reset(BTN[0]), 
        .tick(tick)
    );

    wire [1:0] mode;
    mode_fsm fsm(
        .clk(CLK100MHZ), 
        .reset(BTN[0]),
        .btn_reset(BTN[0]), 
        .btn_left(BTN[1]), 
        .btn_right(BTN[2]), 
        .btn_pause(BTN[3]), 
        .mode(mode)
    );

    wire [3:0] led_pattern;
    led_shift shifter(
        .clk(CLK100MHZ), 
        .reset(BTN[0]), 
        .tick(tick), 
        .mode(mode), 
        .led_pattern(led_pattern)
    );

    assign LED = led_pattern;

    // UART transmission controller
    reg start_uart;
    reg [7:0] uart_data;
    wire uart_busy;
    
    always @(posedge CLK100MHZ or posedge BTN[0]) begin
        if (BTN[0]) begin 
            start_uart <= 0; 
            uart_data <= 8'b00110011; // Default pattern
        end else if (tick && !uart_busy) begin
            uart_data <= {4'b0011, led_pattern};
            start_uart <= 1;
        end else begin
            start_uart <= 0;
        end
    end

    uart_tx #(.CLK_FREQ(100_000_000), .BAUD(115200)) uart(
        .clk(CLK100MHZ), 
        .reset(BTN[0]), 
        .start(start_uart), 
        .data_in(uart_data), 
        .tx(UART_TX), 
        .busy(uart_busy)
    );
endmodule
