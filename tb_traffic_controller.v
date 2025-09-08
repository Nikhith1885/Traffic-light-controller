`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.09.2025 19:16:02
// Design Name: 
// Module Name: tb_traffic_controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// tb_traffic_controller.v

module tb_traffic_controller;

    reg clk;
    reg rst_n;
    // outputs
    wire hw_green, hw_yellow, hw_red;
    wire farm_green, farm_yellow, farm_red;

    // Instantiate with short intervals for test
    traffic_controller #(
        .GREEN_CYCLES(8),   // 8 cycles green for quick sim
        .YELLOW_CYCLES(3),  // 3 cycles yellow
        .CNT_WIDTH(8)
    ) uut (
        .clk(clk),
        .rst_n(rst_n),
        .hw_green(hw_green),
        .hw_yellow(hw_yellow),
        .hw_red(hw_red),
        .farm_green(farm_green),
        .farm_yellow(farm_yellow),
        .farm_red(farm_red)
    );

    // clock
    initial clk = 0;
    always #5 clk = ~clk; // 100MHz -> period 10ns, but only relative matters

    initial begin
        // waveform dump (for iverilog + gtkwave). In Vivado you will use simulator UI instead.
        $dumpfile("tb_traffic.vcd");
        $dumpvars(0, tb_traffic_controller);

        // reset
        rst_n = 0;
        #20;
        rst_n = 1;

        // run enough time to cycle a few states
        #2000;

        $display("Simulation finished");
        $finish;
    end

endmodule
