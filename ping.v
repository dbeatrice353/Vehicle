module ping(clk,reset,sensor,distance,listening,state);

  localparam WIDTH = 16;

  input clk;                    // 50 MHz clock
  input reset;                  // active-high reset
  inout sensor;                 // sensor interface
  output [WIDTH-1:0] distance;  // last distance measurment in mm
  output listening;             // tell the testbench when to drive the bidir channel
  output [2:0] state;

  wire clk_1MHz;
  wire data_valid;
  wire listening;
  wire [WIDTH-1:0] distance_;

  reg [WIDTH-1:0] distance_reg;

  assign distance = distance_reg;

  clock_divider DIVIDER (
    .clk(clk),
    .reset(reset),
    .clk_out(clk_1MHz)
  );

  ping_driver DRIVER (
      .clk(clk_1MHz),
      .reset(reset),
      .sensor(sensor),
      .distance(distance_),
      .data_valid(data_valid),
      .listening(listening),
      .state(state)
  );

  always @(posedge data_valid or posedge reset)
  begin
    if(reset)begin
      distance_reg <= 16'hFFFF;
    end else begin
      distance_reg <= distance_;
    end
  end

endmodule
