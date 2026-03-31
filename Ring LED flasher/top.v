`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2026 13:50:13
// Design Name: 
// Module Name: top
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


module top(
    input  wire clk,
    input  wire rst_n,       
    input  wire repeat_sig,   
    output reg [15:0] led
);
    parameter IDLE = 2'd0;
    parameter CW = 2'd1;  
    parameter ACW = 2'd2;   

    reg [1:0] state;
    reg [3:0] step_count;    
    reg [3:0] start_pos;    
    reg [2:0] cycle_count;   
    reg [3:0] toggle_idx;

    always @(*) begin
        case (state)
            CW: toggle_idx = start_pos + step_count;            
            ACW: toggle_idx = start_pos + 4'd7 - step_count;      
            default: toggle_idx = 4'd0;
        endcase
    end
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            led <= 16'b0;
            step_count <= 4'd0;
            start_pos <= 4'd0;
            cycle_count <= 3'd0;
        end
        else begin
            case (state)
                IDLE: begin
                    if (repeat_sig) begin
                        state <= CW;
                        led <= 16'b0;
                        step_count <= 4'd0;
                        start_pos <= 4'd0;
                        cycle_count <= 3'd0;
                    end
                end
                CW: begin
                    led[toggle_idx] <= ~led[toggle_idx];
                    if (step_count == 4'd7) begin
                        step_count <= 4'd0;
                        state <= ACW;
                    end
                    else begin
                        step_count <= step_count + 4'd1;
                    end
                end
                ACW: begin
                    led[toggle_idx] <= ~led[toggle_idx];

                    if (step_count == 4'd3) begin
                        step_count <= 4'd0;
                        if (cycle_count == 3'd7) begin
                            cycle_count <= 3'd0;
                            start_pos   <= 4'd0;
                            if (repeat_sig)
                                state <= CW;       
                            else
                                state <= IDLE;   
                        end
                        else begin
                            cycle_count <= cycle_count + 3'd1;
                            start_pos   <= start_pos + 4'd4;
                            state       <= CW;
                        end
                    end
                    else begin
                        step_count <= step_count + 4'd1;
                    end
                end

                default: state <= IDLE;

            endcase
        end
    end

endmodule
