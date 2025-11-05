`timescale 1ns/1ps

module deco_tb;

    reg clk = 0;
    reg [1:0] sw = 2'b00;
    reg [3:0] btn = 4'b0000;

    wire [3:0] led;
    wire [3:0] digit0;
    wire [3:0] digit1;
    wire [3:0] digit2;
    wire [3:0] digit3;

    deco_top dut (
        .CLK100MHZ(clk),
        .SW(sw),
        .BTN(btn),
        .LED(led),
        .DIGIT0(digit0),
        .DIGIT1(digit1),
        .DIGIT2(digit2),
        .DIGIT3(digit3)
    );

    always #5 clk = ~clk;

    initial begin

        // reset the system 
        sw = 2'b0010; 
        #200;         
        sw = 2'b0000; 
        #100;

        // wrap after at 2s
        #2_000_000_000;

        btn[1] = 1'b1; #100; btn[1] = 1'b0; // decrease : press BTN[1]
        #1_000_000_000;

        sw[0] = 1'b1; // bounce:  use SW[0]
        
        #2_000_000_000;

        $finish; // total time is ~5 seconds
    end

endmodule