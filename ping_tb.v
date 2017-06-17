module ping_tb();

  localparam WIDTH = 16;

  reg clk;                    // 50 MHz clock input
  reg reset;                  // reset
  reg signal;
  wire sensor;                 // ultrasonic sensor interface
  wire [WIDTH-1:0] distance;  // the distance of the nearest object, measured in mm (if applicable)

  integer counter = 0;

  ping DUT (
      .clk(clk),
      .reset(reset),
      .sensor(sensor),
      .distance(distance),
      .listening(driver_listening) // for test purposes
  );

  assign sensor = driver_listening ? signal : 1'bZ;

  initial begin
    clk = 1'b0;
    reset = 1'b1;
    signal = 1'b0;
    #200
    reset = 1'b0;
    #10000
    signal = 1'b1;
    #500
    signal = 1'b0;
    #189500
    #9000
    signal = 1'b1;
    #500
    signal = 1'b0;
    $stop;
  end

  always
    #1 clk = !clk;

  always
    #2 counter = counter + 1;

  //always
  //  #1 $display("clk: %b, rst: %b, sensor: %b, distance: %b, cylces: %d",clk,reset,sensor,distance,counter);

endmodule
