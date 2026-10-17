`include "dyfsm.v"

`timescale 1ns/1ps
module tb_dynamicfsm;
reg clk = 0, rst = 1, d_in = 0;
reg [3:0] pattern_to_detect;
wire p_d;

dynamicfsm dut (.clk(clk), .rst(rst), .d_in(d_in),
                .pattern_to_detect(pattern_to_detect), .p_d(p_d));

always #5 clk = ~clk;

initial begin
  $monitor("t=%0t pat=%b d_in=%b state=%b p_d=%b", $time, pattern_to_detect, d_in, dut.state, p_d);

  // ---- Pattern 1: 0010 ----
  pattern_to_detect = 4'b0010;
  #22 rst = 0;
  @(negedge clk) d_in = 0;
  @(negedge clk) d_in = 0;
  @(negedge clk) d_in = 1;
  @(negedge clk) d_in = 0;
  @(negedge clk) d_in = 0;
  @(negedge clk) d_in = 0;

  // ---- Pattern 2: 1011 (change only during reset) ----
  @(negedge clk) rst = 1; pattern_to_detect = 4'b1011;
  @(negedge clk) rst = 0;
  @(negedge clk) d_in = 1;
  @(negedge clk) d_in = 0;
  @(negedge clk) d_in = 1;
  @(negedge clk) d_in = 1;
  @(negedge clk) d_in = 0;
  @(negedge clk) d_in = 0;

  #20 $finish;
end
endmodule



