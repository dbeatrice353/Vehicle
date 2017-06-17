`timescale 1ns/1ps

module ping_tb();

  localparam WIDTH = 16;

  reg clk;                    // 50 MHz clock input
  reg reset;                  // reset
  reg signal;
  wire sensor;                 // ultrasonic sensor interface
  wire [WIDTH-1:0] distance;  // the distance of the nearest object, measured in mm (if applicable)
  wire [2:0] state;

  ping DUT (
      .clk(clk),
      .reset(reset),
      .sensor(sensor),
      .distance(distance),
      .listening(driver_listening), // for test purposes
      .state(state)
  );

  assign sensor = driver_listening ? signal : 1'bZ;

  initial begin
    clk = 1'b0;
    reset = 1'b1;
    #100
    reset = 1'b0;
    // sample 1
    signal = 1'b0;
    #3000000
    signal = 1'b1;
    #500000
    signal = 1'b0;
    #16500000
    // sample 2
    #5000000
    signal = 1'b1;
    #1000000
    signal = 1'b0;
    #14000000
    #100000
    $stop;
  end

  always
    #10 clk = !clk; // 20 ns period / 50 MHz clock

endmodule
