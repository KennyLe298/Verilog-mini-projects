`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2025 07:56:16 AM
// Design Name: 
// Module Name: gp4_tb
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

//`include "cla.v"

module gp4_tb;

    reg [3:0] gin_tb;
    reg [3:0] pin_tb;
    reg       cin_tb;

    wire      gout_tb;
    wire      pout_tb;
    wire [2:0] cout_tb;

    integer i;

    gp4 uut (
        .gin(gin_tb), 
        .pin(pin_tb), 
        .cin(cin_tb), 
        .gout(gout_tb), 
        .pout(pout_tb), 
        .cout(cout_tb)
    );

    initial begin
        gin_tb = 4'b0;
        pin_tb = 4'b0;
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
