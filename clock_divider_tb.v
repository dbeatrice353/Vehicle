module clock_divider_tb();

  reg clk;
  reg reset;
  wire clk_out;

  clock_divider DUT (
    .clk(clk),
    .reset(reset),
    .clk_out(clk_out)
  );

  initial begin
    clk = 1;
    reset = 1'b1;
    #20
    reset = 1'b0;
    #1000
    reset = 1'b1;
    #500
    $finish;
  end

  always
    #5 clk = !clk;

  always
    #5 $display("clk: %b, rst: %b, clk_out: %b",clk,reset,clk_out);

endmodule
