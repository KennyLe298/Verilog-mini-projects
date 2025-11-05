module uart_tx #(parameter CLK_FREQ=100_000_000, parameter BAUD=115200)(
    input clk, reset, start,
    input [7:0] data_in,
    output reg tx, busy
);
    localparam integer DIV = CLK_FREQ / BAUD;
    reg [15:0] counter;
    reg [3:0] bit_index;
    reg [9:0] frame;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx <= 1'b1; 
            busy <= 0; 
            counter <= 0; 
            bit_index <= 0; 
            frame <= 10'b1111111111;
        end else if (start && !busy) begin
            frame <= {1'b1, data_in, 1'b0}; // Stop bit, data[7:0], start bit
            busy <= 1; 
            bit_index <= 0; 
            counter <= 0;
            tx <= 1'b0; // Start bit begins immediately
        end else if (busy) begin
            if (counter == DIV - 1) begin
                counter <= 0;
                bit_index <= bit_index + 1;
                if (bit_index == 9) begin
                    busy <= 0;
                    tx <= 1'b1; // Return to idle
                end else begin
                    tx <= frame[bit_index + 1]; // Load next bit
                end
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule