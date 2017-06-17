module ping(clk,reset,sensor,distance,listening);

  localparam WIDTH = 16;

  input clk;                    // 50 MHz clock
  input reset;                  // active-high reset
  inout sensor;                 // sensor interface
  output [WIDTH-1:0] distance;  // last distance measurment in mm
  output listening;             // tell the testbench when to drive the bidir channel

  wire clk_1MHz;
  wire data_valid;
  wire listening;

  reg [WIDTH-1:0] distance_reg;


  clock_divider DIVIDER (
    .clk(clk),
    .reset(reset),
    .clk_out(clk_1MHz)
  );

  ping_driver DRIVER (
      .clk(clk_1MHz),
      .reset(reset),
      .sensor(sensor),
      .distance(distance),
      .data_valid(data_valid),
      .listening(listening),
      .state()
  );

  always @(posedge data_valid or posedge reset)
  begin
    if(reset)begin
      distance_reg <= 1;
    end else begin
      distance_reg <= distance;
    end
  end

endmodule
