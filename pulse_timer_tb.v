module pulse_timer_tb();

  reg clk;
  reg reset;
  reg signal;

  wire data_valid;
  wire [15:0] duration;

  pulse_timer #(.WIDTH(16)) DUT (
      .clk(clk),
      .reset(reset),
      .signal(signal),
      .duration(duration),
      .data_valid(data_valid)
  );

  initial begin
    clk = 1'b0;
    reset = 1'b1;
    signal = 1'b0;
    #10
    reset = 1'b0;
    #10
    signal = 1'b1;
    #50
    signal = 1'b0;
    #30
    reset = 1'b1;
    #10
    reset = 1'b0;
    #10
    signal = 1'b1;
    #70
    signal = 1'b0;
    #30
    $finish;
  end

  always
    #5 clk = !clk;

  always
    #5 $display("clk: %b, rst: %b, signal: %b, duration: %b, data_valid: %b",clk,reset,signal,duration,data_valid);

endmodule
