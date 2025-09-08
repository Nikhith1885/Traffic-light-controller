`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.09.2025 19:13:23
// Design Name: 
// Module Name: traffic_controller
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


// traffic_controller.v
// 4-state traffic light controller with two time intervals (GREEN and YELLOW).
// Outputs: hw_green, hw_yellow, hw_red, farm_green, farm_yellow, farm_red

module traffic_controller #(
    parameter integer GREEN_CYCLES  = 50,   // number of clock cycles for each GREEN interval
    parameter integer YELLOW_CYCLES = 10,   // number of clock cycles for each YELLOW interval
    parameter integer CNT_WIDTH     = 16    // width of the cycle counter (must hold GREEN_CYCLES)
)(
    input  wire clk,
    input  wire rst_n,   // active-low reset
    // Light outputs
    output reg hw_green,
    output reg hw_yellow,
    output reg hw_red,
    output reg farm_green,
    output reg farm_yellow,
    output reg farm_red
);

    // State encoding
    localparam [1:0]
        S_HW_GREEN   = 2'b00,
        S_HW_YELLOW  = 2'b01,
        S_FARM_GREEN = 2'b10,
        S_FARM_YELLOW= 2'b11;

    reg [1:0] state, next_state;
    reg [CNT_WIDTH-1:0] counter;
    wire [CNT_WIDTH-1:0] green_cycles  = GREEN_CYCLES;
    wire [CNT_WIDTH-1:0] yellow_cycles = YELLOW_CYCLES;

    // State register + counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state   <= S_HW_GREEN;
            counter <= green_cycles - 1;
        end else begin
            state <= next_state;
            // update counter
            if (counter == 0) begin
                // reload depending on next_state
                case (next_state)
                    S_HW_GREEN, S_FARM_GREEN: counter <= green_cycles - 1;
                    S_HW_YELLOW, S_FARM_YELLOW: counter <= yellow_cycles - 1;
                    default: counter <= green_cycles - 1;
                endcase
            end else begin
                counter <= counter - 1;
            end
        end
    end

    // Next-state logic: advance when counter hits 0
    always @(*) begin
        case (state)
            S_HW_GREEN: begin
                if (counter == 0) next_state = S_HW_YELLOW; else next_state = S_HW_GREEN;
            end
            S_HW_YELLOW: begin
                if (counter == 0) next_state = S_FARM_GREEN; else next_state = S_HW_YELLOW;
            end
            S_FARM_GREEN: begin
                if (counter == 0) next_state = S_FARM_YELLOW; else next_state = S_FARM_GREEN;
            end
            S_FARM_YELLOW: begin
                if (counter == 0) next_state = S_HW_GREEN; else next_state = S_FARM_YELLOW;
            end
            default: next_state = S_HW_GREEN;
        endcase
    end

    // Output logic (one-hot style for readability)
    always @(*) begin
        // default all off
        hw_green  = 1'b0;
        hw_yellow = 1'b0;
        hw_red    = 1'b0;
        farm_green  = 1'b0;
        farm_yellow = 1'b0;
        farm_red    = 1'b0;

        case (state)
            S_HW_GREEN: begin
                hw_green = 1'b1;
                farm_red = 1'b1;
            end
            S_HW_YELLOW: begin
                hw_yellow = 1'b1;
                farm_red   = 1'b1;
            end
            S_FARM_GREEN: begin
                farm_green = 1'b1;
                hw_red     = 1'b1;
            end
            S_FARM_YELLOW: begin
                farm_yellow = 1'b1;
                hw_red     = 1'b1;
            end
            default: begin
                hw_red = 1'b1;
                farm_red = 1'b1;
            end
        endcase
    end

endmodule

