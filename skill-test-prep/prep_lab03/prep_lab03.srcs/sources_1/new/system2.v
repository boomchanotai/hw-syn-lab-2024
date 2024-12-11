`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2024 02:15:33 PM
// Design Name: 
// Module Name: system2
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


module system2(
    output [6:0] seg,
    output dp,
    output [3:0] an,
    input [7:0] sw,
    input btnU,
    input btnC,
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
    
    wire btn1, nbtn1; // u
    wire btn2, nbtn2; // c
    dFlipflop dFFBtn1(btn1, nbtn1, btnU, targetClk);
    dFlipflop dFFBtn2(btn2, nbtn2, btnC, targetClk);
    
    wire [6:0] segments;
    assign seg=segments;
    
    reg [3:0] num = 4;
    hexTo7Segment segDecode(segments, num);
    
    assign an = 4'b1110;
    assign dp = 1'b1;
    
    always @(btn1)
    begin
        num = num + 1;
    end
    
//    always @(sp1State)
//    begin
//        num = num + 1;
//    end
    
endmodule
