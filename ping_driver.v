module ping_driver(clk, reset, sensor, distance, data_valid, listening, state);
  // ultrasonic sensor driver
  localparam WIDTH = 16;

  input clk;                    // 1 MHz clock input
  input reset;                  // reset
  inout sensor;                 // ultrasonic sensor interface
  output [WIDTH-1:0] distance;  // the distance of the nearest object, measured in mm (if applicable)
  output data_valid;            // 1 if a valid distance measurment is being sent
  output listening;             // tell the testbench when to drive the sensor channel
  output [2:0] state;           // for test

  // FSM states
  localparam LOW_SIGNAL_1     = 3'b000;
  localparam HIGH_SIGNAL      = 3'b001;
  localparam LOW_SIGNAL_2     = 3'b010;
  localparam MEASURE_RESPONSE = 3'b011;
  // FSM state durations
  localparam LOW_SIGNAL_1_DURATION     = 16'h0005; // 5 microseconds
  localparam HIGH_SIGNAL_DURATION      = 16'h0005; // 5 microseconds
  localparam LOW_SIGNAL_2_DURATION     = 16'h0005; // 5 microseconds
  localparam MEASURE_RESPONSE_DURATION = 16'h4E11; // 19985 microseconds
  // speed of sound
  localparam SPEED_OF_SOUND = 16'h0154; // 340 micrometers/microsecond (speed of sound is about 340.29 m/s)

  reg [15:0] counter;      // a timer for the FSM states
  reg [2:0] state;

  wire sensor_driver;
  wire pulse_timer_reset;
  wire data_valid;
  wire [WIDTH-1:0] pulse_duration;
  wire listening;

  // tri-state and pulse control
  assign listening = state == MEASURE_RESPONSE || reset;
  assign sensor = listening ? 1'bZ : sensor_driver;
  assign sensor_driver = state == HIGH_SIGNAL ? 1 : 0;

  // distance calculation
  assign distance = SPEED_OF_SOUND * (pulse_duration >> 1);  // distance in millimeters

  // pulse timer control
  assign pulse_timer_reset = state != MEASURE_RESPONSE;

  pulse_timer #(.WIDTH(WIDTH)) RESPONSE_TIMER (
      .clk(clk),
      .reset(reset | pulse_timer_reset),
      .signal(sensor),
      .duration(pulse_duration),
      .data_valid(data_valid)
  );

  // state machine
  always @(posedge clk or posedge reset) begin
    if(reset)begin
      state <= LOW_SIGNAL_1;
      counter = 0;
    end else begin
      case(state)
        LOW_SIGNAL_1: begin
          if(counter == LOW_SIGNAL_1_DURATION)begin
            state = HIGH_SIGNAL;
            counter = 0;
          end
        end
        HIGH_SIGNAL: begin
          if(counter == HIGH_SIGNAL_DURATION)begin
            state = LOW_SIGNAL_2;
            counter = 0;
          end
        end
        LOW_SIGNAL_2: begin
          if(counter == LOW_SIGNAL_2_DURATION)begin
            state = MEASURE_RESPONSE;
            counter = 0;
          end
        end
        MEASURE_RESPONSE: begin
          if(counter >= MEASURE_RESPONSE_DURATION)begin
            state = LOW_SIGNAL_1;
            counter = 0;
          end
        end
        default: state = LOW_SIGNAL_1;
      endcase
      counter = counter + 1;
    end
  end

endmodule
