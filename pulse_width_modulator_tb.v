module pulse_width_modulator_tb();

  reg clk;
  reg reset;
  reg [3:0] pulse_width_control;
  wire pulse;
  wire [3:0] counter;

  pulse_width_modulator #(.RESOLUTION(4)) DUT (
    .clk(clk),
    .reset(reset),
    .pulse_width_control(pulse_width_control),
    .pulse(pulse),
    .counter(counter)
  );

  initial begin
    clk = 1'b0;
    reset = 1'b1;
    pulse_width_control = 4'b0;
    #10
    reset = 1'b0;
    pulse_width_control = 4'b0011;
    #500
    $finish;
  end

  always
    #5 clk = !clk;

  always
    #5 $display("clk: %b, rst: %b, ctrl: %b, pls: %b, count: %b",clk,reset,pulse_width_control,pulse,counter);

endmodule
