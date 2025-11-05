`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2025 11:27:27 AM
// Design Name: 
// Module Name: display_driver
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


module display_driver(
    input wire clk, // 100 MHz
    input wire reset,
    input wire [15:0] digit_data_in, // {D0, D1, D2, D3}
    output reg [6:0] SEG,            // 7-seg segments (active-low)
    output reg [3:0] AN              // 4 Anodes (active-low)
);

    // --- Anode Scanning ---
    // Create a ~1.5kHz refresh clock (100MHz / 65536)
    reg [15:0] refresh_counter;
    always @(posedge clk or posedge reset) begin
        if (reset)
            refresh_counter <= 16'd0;
        else
            refresh_counter <= refresh_counter + 1;
    end
    
    // Use top 2 bits to select anode (00, 01, 10, 11)
    wire [1:0] anode_sel = refresh_counter[15:14];

    // --- Digit Mux ---
    // Selects the 4-bit data for the currently active anode
    wire [3:0] current_digit_data;
    assign current_digit_data = (anode_sel == 2'b00) ? digit_data_in[15:12] :
                                (anode_sel == 2'b01) ? digit_data_in[11:8]  :
                                (anode_sel == 2'b10) ? digit_data_in[7:4]   :
                                                      digit_data_in[3:0];
                                                      
    // --- Anode Output Driver (Active-low) ---
    always @(*) begin
        case (anode_sel)
            2'b00: AN = 4'b1110; // Enable Digit 0
            2'b01: AN = 4'b1101; // Enable Digit 1
            2'b10: AN = 4'b1011; // Enable Digit 2
            2'b11: AN = 4'b0111; // Enable Digit 3
            default: AN = 4'b1111;
        endcase
    end

    // --- 7-Segment Decoder (Active-low) ---
    // This is the same decoder from Exercise 1
    always @(*) begin
        case (current_digit_data)
            // {g,f,e,d,c,b,a}
            4'd2:  seg = 7'b0100100; // 2
            4'd5:  seg = 7'b0010010; // 5
            default: seg = 7'b1111111; // Blank
        endcase
    end

endmodule