`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2025 10:47:52 AM
// Design Name: 
// Module Name: clock_divider
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


module clock_divider #(parameter DIV = 100_000_000)( // Default changed to 1s
    input clk, reset,
    output reg tick
);
    // Needs 27 bits to hold 99,999,999
    reg [26:0] count; 

    always @(posedge clk or posedge reset) begin
        if (reset) begin 
            count <= 0; 
            tick <= 0; 
        end
        else if (count == DIV - 1) begin 
            count <= 0; 
            tick <= 1; 
        end
        else begin 
            count <= count + 1; 
            tick <= 0; 
        end
    end
endmodule

