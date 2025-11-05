module clock_divider(
    input wire clk, // 100 MHz
    input wire reset,
    output reg tick_100hz // 1 cycle pulse at 100 Hz
);

    reg [19:0] count;
    localparam DIV_100HZ = 20'd1_000_000;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 20'd0;
            tick_100hz <= 1'b0;
        end else begin
            if (count == DIV_100HZ - 1) begin
                count <= 20'd0;
                tick_100hz <= 1'b1;
            end else begin
                count <= count + 1;
                tick_100hz <= 1'b0;
            end
        end
    end
endmodule