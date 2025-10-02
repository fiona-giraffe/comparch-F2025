module cycle #(
    parameter PWM_INTERVAL = 1200,        
    parameter INC_DEC_INTERVAL = 5000,    
    parameter HOLD_OFF_INC = 800,       
    parameter RAMP_INC = 400,       
    parameter HOLD_ON_INC = 800,        
    parameter INIT_PHASE_OFFSET = 0       
)(
    input clk,
    output reg [10:0] pwm_value           // 11 bits for 1200 steps
);

    // Defining the states binary representation
    localparam HOLD_OFF = 2'b00;
    localparam RAMP_UP = 2'b01;
    localparam HOLD_ON = 2'b10;
    localparam RAMP_DOWN = 2'b11;

    reg [1:0] state = HOLD_OFF;         // Current state
    reg [31:0] counter = 0;             // Step counter
    reg [31:0] phase_counter;           // Phase counter
    reg [10:0] step_value = 3;          // PWM step value (1200 / 400 = 3)

    // Initialization
    initial begin
        pwm_value = 0;
        state = HOLD_OFF;
        phase_counter = INIT_PHASE_OFFSET;  
    end

    always @(posedge clk) begin
        if (counter >= INC_DEC_INTERVAL - 1) begin
            counter <= 0;

            // Update phase counter
            if (phase_counter >= (HOLD_OFF_INC + RAMP_INC + HOLD_ON_INC + RAMP_INC) - 1) begin
                phase_counter <= 0;
            end 
            else begin
                phase_counter <= phase_counter + 1;
            end

            // State machine
            case (state)
                HOLD_OFF: begin
                    if (phase_counter >= HOLD_OFF_INC) begin
                        state <= RAMP_UP;
                    end
                end
                RAMP_UP: begin
                    if (pwm_value < PWM_INTERVAL - step_value) begin
                        pwm_value <= pwm_value + step_value;
                    end 
                    else begin
                        pwm_value <= PWM_INTERVAL;  // Latch to max
                        state <= HOLD_ON;
                    end
                end
                HOLD_ON: begin
                    if (phase_counter >= HOLD_OFF_INC + RAMP_INC + HOLD_ON_INC) begin
                        state <= RAMP_DOWN;
                    end
                end
                RAMP_DOWN: begin
                    if (pwm_value > step_value) begin
                        pwm_value <= pwm_value - step_value;
                    end 
                    else begin
                        pwm_value <= 0; 
                        state <= HOLD_OFF;
                    end
                end
            endcase
        end 
        else begin
            counter <= counter + 1;
        end
    end
endmodule