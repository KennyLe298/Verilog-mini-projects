module SystemDemo(
   input wire [3:0] btn,  
   output wire [5:0] led 
);
   
   wire [31:0] sum;

   cla cla_inst(
      .a(32'd26), 
      .b({28'b0, btn[3:0]}), 
      .cin(1'b0), 
      .sum(sum)
   );
   assign led[5:0] = sum[5:0];
   
endmodule
