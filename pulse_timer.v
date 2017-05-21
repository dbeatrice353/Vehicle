module pulse_timer(clk, reset, signal, duration, data_valid);

  parameter WIDTH = 16;

  input clk;
  input reset;
  input signal;
  output [WIDTH-1:0] duration;
  output data_valid;

  reg [WIDTH-1:0] counter;
  reg current_value;
  reg previous_value;
  reg enable_counter;
  reg data_valid;

  assign duration = counter;

  // catch rising and folling edges of the pulse signal
  always @(clk or reset) begin
    if(reset)begin
      current_value = 0;
      previous_value = 0;
      enable_counter = 0;
      data_valid = 0;
    end
    else begin
      previous_value = current_value;
      current_value = signal;
      if(current_value == 1 && previous_value == 0)begin
        enable_counter = 1;
        data_valid = 0;
      end
      if(current_value == 0 && previous_value == 1)begin
        enable_counter = 0;
        data_valid = 1;
      end
    end
  end


  // capture the duration of the pulse signal
  // note: the counter is usually off by 1 or 2, due to the edge-capture method.
  always @(posedge clk or reset)begin
    if(reset)
      counter = 0;
    else begin
      if(enable_counter)
        counter = counter + 1;
    end
  end

endmodule
