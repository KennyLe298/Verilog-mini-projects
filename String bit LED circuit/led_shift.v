module led_shift(
    input clk, reset, tick,
    input [1:0] mode,
    output reg [3:0] led_pattern
);
    localparam [3:0] DEFAULT_PATTERN = 4'b0011;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            led_pattern <= DEFAULT_PATTERN;
        end else if (mode == 2'b00) begin
            led_pattern <= DEFAULT_PATTERN;
        end else if (tick) begin
            case (mode)
                2'b01: led_pattern <= {led_pattern[2:0], led_pattern[3]}; // Shift Left
                2'b10: led_pattern <= {led_pattern[0], led_pattern[3:1]}; // Shift Right
                2'b11: led_pattern <= led_pattern; // Pause
                default: led_pattern <= led_pattern;
            endcase
        end
    end
endmodule