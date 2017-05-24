module ping_driver_tb();

  localparam WIDTH = 16;

  reg clk;                    // 1 MHz clock input
  reg reset;                  // reset
  reg signal;
  wire sensor;                 // ultrasonic sensor interface
  wire [WIDTH-1:0] distance;  // the distance of the nearest object, measured in mm (if applicable)
  wire driver_listening;
  wire [2:0] state;

  ping_driver #(.WIDTH(16)) DUT (
      .clk(clk),
      .reset(reset),
      .sensor(sensor),
      .distance(distance),
      .listening(driver_listening),
      .state(state)
  );

  assign sensor = driver_listening ? signal : 1'bZ;

  initial begin
    clk = 1'b0;
    reset = 1'b1;
    signal = 1'b0;
    #10
    reset = 1'b0;
    #170
    signal = 1'b1;
    #100
    signal = 1'b0;
    #100
    $finish;
  end

  always
    #5 clk = !clk;

  always
    #5 $display("clk: %b, rst: %b, sensor: %b, distance: %b, state: %b",clk,reset,sensor,distance,state);

endmodule
