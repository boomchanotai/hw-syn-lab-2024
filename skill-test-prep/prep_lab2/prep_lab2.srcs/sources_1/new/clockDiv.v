`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2024 11:33:46 PM
// Design Name: 
// Module Name: clockDiv
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


module clockDiv(
    output clkDiv,
    input clk
    );
    
    reg clkDiv;
    
    initial
    begin
        clkDiv = 0;
    end;
    
    always @(posedge clk)
    begin
        clkDiv = ~clkDiv;
    end
endmodule
