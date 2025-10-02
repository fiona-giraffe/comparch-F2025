`include "pwm.sv"
`include "cycle.sv"

module top (
    input clk,
    output RGB_R,
    output RGB_G,
    output RGB_B
);

    // Defining the incrementing parameters for each state
    localparam PWM_INTERVAL = 1200;
    localparam HOLD_OFF_INC = 800;      
    localparam RAMP_INC = 400;          
    localparam HOLD_ON_INC = 800;       
    localparam PHASE_SHIFT = 800;     
    localparam PHASE_SHIFT_2 = 2*PHASE_SHIFT;    

    wire [10:0] red_val, g_val, b_val;
    wire r_pwm, g_pwm, b_pwm;

    // The phases are reversed because of active low outputs
    // Red (0° phase)
    cycle #(
        .PWM_INTERVAL(PWM_INTERVAL),
        .INC_DEC_INTERVAL(5000),  
        .HOLD_OFF_INC(HOLD_OFF_INC),
        .RAMP_INC(RAMP_INC),
        .HOLD_ON_INC(HOLD_ON_INC),
        .INIT_PHASE_OFFSET(PHASE_SHIFT_2)
    ) red (
        .clk(clk),
        .pwm_value(red_val)
    );

    // Green (120° phase shift)
    cycle #(
        .PWM_INTERVAL(PWM_INTERVAL),
        .INC_DEC_INTERVAL(5000),  
        .HOLD_OFF_INC(HOLD_OFF_INC),
        .RAMP_INC(RAMP_INC),
        .HOLD_ON_INC(HOLD_ON_INC),
        .INIT_PHASE_OFFSET(PHASE_SHIFT)
    ) green (
        .clk(clk),
        .pwm_value(g_val)
    );

    // Blue (240° phase shift)
    cycle #(
        .PWM_INTERVAL(PWM_INTERVAL),
        .INC_DEC_INTERVAL(5000),  
        .HOLD_OFF_INC(HOLD_OFF_INC),
        .RAMP_INC(RAMP_INC),
        .HOLD_ON_INC(HOLD_ON_INC),
        .INIT_PHASE_OFFSET(0)
    ) blue (
        .clk(clk),
        .pwm_value(b_val)
    );

    // PWM Modules
    pwm red_pwm (.clk(clk), .pwm_value(red_val), .pwm_out(r_pwm));
    pwm green_pwm (.clk(clk), .pwm_value(g_val), .pwm_out(g_pwm));
    pwm blue_pwm (.clk(clk), .pwm_value(b_val), .pwm_out(b_pwm));

    // Active-low outputs
    assign RGB_R = ~r_pwm;
    assign RGB_G = ~g_pwm;
    assign RGB_B = ~b_pwm;
endmodule