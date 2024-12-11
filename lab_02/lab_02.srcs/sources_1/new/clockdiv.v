`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/02/2024 09:19:03 PM
// Design Name: 
// Module Name: clockdiv
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
end

always @(posedge clk)
begin
    clkDiv = ~clkDiv;
end
endmodule
