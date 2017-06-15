module clock_divider(clk,reset,clk_out);
  //
  //  50 MHz clock --> 1 MHz clock
  //
  input clk;
  input reset;
  output clk_out;

  reg [8:0] counter;
  reg clk_out;

  always @(posedge clk or posedge reset)
  begin
    if(reset)begin
      counter = 8'h0;
      clk_out = 0;
    end
    else
    if(counter == 8'h32)begin
      counter = 8'h0;
      clk_out = !clk_out;
    end
    else
      counter = counter + 1;
  end

endmodule
