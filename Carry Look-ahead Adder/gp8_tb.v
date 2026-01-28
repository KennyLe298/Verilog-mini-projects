`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2025 08:06:06 AM
// Design Name: 
// Module Name: gp8_tb
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


module gp8_tb;

    reg [7:0] gin_tb;
    reg [7:0] pin_tb;
    reg       cin_tb;

    wire      gout_tb;
    wire      pout_tb;
    wire [6:0] cout_tb;

    integer i;

    gp8 uut (
        .gin(gin_tb), 
        .pin(pin_tb), 
        .cin(cin_tb), 
        .gout(gout_tb), 
        .pout(pout_tb), 
        .cout(cout_tb)
    );

    initial begin
        gin_tb = 8'b0;
        pin_tb = 8'b0;
        cin_tb = 1'b0;

        for (i = 0; i < 100; i = i + 1) begin
            gin_tb = $random;
            pin_tb = $random;
            cin_tb = $random;
            
            #10;
        end
        $finish;
    end
      
endmodule
