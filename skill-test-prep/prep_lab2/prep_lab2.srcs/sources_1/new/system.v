`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2024 11:36:34 PM
// Design Name: 
// Module Name: system
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


module system(
    output [6:0] seg,
    output [3:0] an,
    output dp,
    input clk
    );
    
    // Clock
    wire targetClk;
    wire [18:0] tclk;
    assign tclk[0]=clk;
    genvar c;
    generate for(c=0; c<18; c=c+1)
    begin
        clockDiv fDiv(tclk[c+1], tclk[c]); // output: [c+1], input: [c]
    end endgenerate;
    clockDiv fDivTarget(targetClk, tclk[18]); // output: targetClk, input: last clk
    
    testSevenSeg (seg, an, dp, targetClk);
        
endmodule
