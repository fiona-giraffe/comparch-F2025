`timescale 1ns/1ns
`include "top.sv"

module test_bench;
    logic clk = 0;
    logic RGB_R, RGB_G, RGB_B;
    
    top dut (
        .clk(clk),
        .RGB_R(RGB_R),
        .RGB_G(RGB_G),
        .RGB_B(RGB_B)
    );

    initial begin
        $dumpfile("cycle.vcd");
        $dumpvars(0, test_bench);
        #2000000000;  // Simulate for 2 seconds
        $finish;
    end

    // 12MHz clock (83.33ns period)
    always #41.666667 clk = ~clk;
endmodule