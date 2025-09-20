module top(
    input logic clk,
    output logic RGB_R,
    output logic RGB_G,
    output logic RGB_B
);

    // CLK frequency = 12MHz, so 2000000 cycles = 1/6s. Cycling through 6 colors in 1s
    parameter BLINK_INTERVAL = 2000000;

    // Defining 6 color states
    parameter RED = 3'b011;      // R on
    parameter YELLOW = 3'b001;   // R and G on
    parameter GREEN = 3'b101;    // G on
    parameter CYAN = 3'b100;     // G and B on
    parameter BLUE = 3'b110;     // B on
    parameter MAGENTA = 3'b010;  // R and B on


    logic [20:0] count = 0; // BLINK_INTERVAL counter
    logic [2:0] current_state = RED; // defining the current state

    always_ff @(posedge clk) begin
        if (count == BLINK_INTERVAL - 1) begin
            case (current_state)
                RED: begin 
                    current_state <= YELLOW;
                    end
                YELLOW: begin 
                    current_state <= GREEN;
                    end
                GREEN: begin
                    current_state <= CYAN;
                    end
                CYAN: begin 
                    current_state <= BLUE;
                    end
                BLUE: begin
                    current_state <= MAGENTA;
                    end
                MAGENTA: begin
                    current_state <= RED;
                    end
                default: begin
                    current_state <= RED;
                    end
            endcase
            count <= 0;
        end
        else begin
            count <= count + 1;
        end
    end

    assign {RGB_R, RGB_G, RGB_B} = current_state;

endmodule
