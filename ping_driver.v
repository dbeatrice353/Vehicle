module ping_driver(clk, reset, sensor, distance);
  // ultrasonic sensor driver

  // 1 MHz clock input
  input clk;
  input reset;
  inout sensor;
  output [15:0] distance;

  // FSM states
  localparam LOW_SIGNAL_1               = 3'b000;
  localparam HIGH_SIGNAL                = 3'b001;
  localparam LOW_SIGNAL_2               = 3'b010;
  localparam LISTENING_FOR_RISING_EDGE  = 3'b011;
  localparam LISTENING_FOR_FALLING_EDGE = 3'b100;
  localparam CYCLE_REMAINDER            = 3'b101;

  // FSM state durations
  localparam LOW_SIGNAL_1_DURATION    = 16'h0005; // 5 microseconds
  localparam HIGH_SIGNAL_DURATION     = 16'h0005; // 5 microseconds
  localparam LOW_SIGNAL_2_DURATION    = 16'h0005; // 5 microseconds
  localparam CYCLE_REMAINDER_DURATION = 16'h1761; // 5985 microseconds  (roughly the round-trip time to a point 1 meter away)

  localparam SPEED_OF_SOUND = 16'h0154; // 340 micrometers/microsecond (speed of sound is about 340.29 m/s)

  reg [15:0] counter;      // a timer for the FSM states
  reg [15:0] sonar_timer;
  reg [15:0] roundtrip_time; // microseconds
  reg [2:0] state;
  reg waiting_for_echo;

  wire signal_driver;

  //assign sensor_driver = state == PULSE ? 1 : 0;
  //assign sensor = state == LISTEN ? Z : sensor_driver;

  //assign distance = SPEED_OF_SOUND * (roundtrip_time >> 1);  // distance in millimeters

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
            state = LISTEN_FOR_RISING_EDGE;
            counter = 0;
          end
        end
        LISTENING_FOR_RISING_EDGE: begin
          if(counter == CYCLE_REMAINDER_DURATION)begin
            state = LOW_SIGNAL_1;
            counter = 0;
          end
          else if(sensor == 1)begin
            state = LISTENING_FOR_FALLING_EDGE;
          end
        end
        LISTENING_FOR_FALLING_EDGE: begin
          if(counter == CYCLE_REMAINDER_DURATION)begin
            state = LOW_SIGNAL_1;
            counter = 0;
          end
        end
        CYCLE_REMAINDER: begin
          if (counter == CYCLE_REMAINDER_DURATION)begin
            state = LOW_SIGNAL_1;
            counter = 0;
          end
        end
        default: state = LOW_SIGNAL_1;
      endcase
      counter = counter + 1;
    end
  end

  // outging pulse control
  always @(state or reset) begin
    if(reset)begin
      signal_driver = 0;
    end else begin
      case(state)
        SIGNAL_HIGH: signal_driver = 1;
        default: signal_driver = 0;
      endcase
    end
  end

  always @(posedge sensor or reset)begin
    if(reset)
  end

endmodule
