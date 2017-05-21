

module pulse_width_modulator(clk, reset, pulse_width_control, pulse, counter);
  parameter RESOLUTION = 8;

  input clk;
  input reset;
  input [RESOLUTION-1:0] pulse_width_control;
  output pulse;
  output [RESOLUTION-1:0] counter;

  reg [RESOLUTION-1:0] counter = 0;
  reg pulse = 0;

  always @(posedge clk or posedge reset)
  begin
    if(reset)
      counter <= 0;
    else
      counter <= counter + 1;
  end

  always @(posedge clk or posedge reset)
  begin
    if(reset || pulse_width_control == 0)
      pulse <= 0;
    else
      pulse <= counter <= pulse_width_control;
  end
endmodule
