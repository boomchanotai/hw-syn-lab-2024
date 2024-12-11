`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/20/2024 01:18:16 PM
// Design Name: 
// Module Name: fullAdder
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


module fullAdder(
    output cout,
    output s,
    input a,
    input b,
    input cin
    );

reg cout;
reg s;

always @(a or b or cin)
begin
    assign {cout,s}=a+b+cin;
end
endmodule
