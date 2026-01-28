`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2025 08:13:56 AM
// Design Name: 
// Module Name: cla_tb
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


module cla_tb;

    reg [31:0] a_tb;
    reg [31:0] b_tb;
    reg       cin_tb;

    wire [31:0] sum_tb; 


    cla uut (
        .a(a_tb), 
        .b(b_tb), 
        .cin(cin_tb), 
        .sum(sum_tb)
    );

    initial begin
        a_tb = 32'd0;
        b_tb = 32'd0;
        cin_tb = 1'b0;

        
        // --- Test Cases ---

        // Case 1: Zero test
        #10;
        a_tb = 32'd0;
        b_tb = 32'd0;
        cin_tb = 1'b0;

        // Case 2: Simple addition
        #10;
        a_tb = 32'd5;
        b_tb = 32'd10;
        cin_tb = 1'b0; // 5 + 10 + 0 = 15

        // Case 3: Simple addition with carry in
        #10;
        a_tb = 32'd20;
        b_tb = 32'd30;
        cin_tb = 1'b1; // 20 + 30 + 1 = 51

        // Case 4: Full carry propagation test
        #10;
        a_tb = 32'hFFFFFFFF; 
        b_tb = 32'd0;
        cin_tb = 1'b1;      

        // Case 5: Another full carry propagation
        #10;
        a_tb = 32'hFFFFFFFF;
        b_tb = 32'hFFFFFFFF;
        cin_tb = 1'b0;      


    end
      
endmodule
