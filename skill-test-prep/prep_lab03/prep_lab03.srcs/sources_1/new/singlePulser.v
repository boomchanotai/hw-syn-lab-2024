`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2024 01:26:46 PM
// Design Name: 
// Module Name: singlePulser
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


module singlePulser(
    output reg d,
    input pushed,
    input clk
    );

    reg state; // 1=pushed, 0=not pushed

    initial state = 0;

    always @(posedge clk) begin
        d = 0; // Default output is 0

        // first push state to hold state
        if (state == 0 && pushed) begin
            state = 1;  // Transition to the "pressed" state
            d = 1;      // Generate single pulse
        end

        // hold state to initial state
        else if (state == 1 && !pushed) begin
            state = 0;  // Return to the "waiting" state
        end
    end
endmodule
