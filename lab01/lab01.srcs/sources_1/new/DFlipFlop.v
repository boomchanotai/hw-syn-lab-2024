`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/20/2024 02:05:24 PM
// Design Name: 
// Module Name: DFlipFlop
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


module DFlipFlop(
    output q,
    input clock,
    input nreset,
    input d
    );

reg q;

always @(posedge clock, nreset)
begin
if (nreset==1)
    q=d;
else
    q=0;
end

endmodule
