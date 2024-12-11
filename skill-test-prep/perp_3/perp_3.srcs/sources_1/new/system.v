`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2024 02:58:56 PM
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
    generate for(c=0;c<18;c=c+1) begin
        clockDiv fDiv(tclk[c+1],tclk[c]);
    end endgenerate
    
    clockDiv fdivTarget(targetClk,tclk[18]);
    
    
    wire [6:0] segments;
    assign seg=segments;
    
    reg [3:0] hexIn = 0;
    hexTo7Segment segDecode(segments,hexIn);
    
//    wire d,notd,d2,notd2;
//    dFlipflop dff1(d, notd, sw[1], targetClk);
//    dFlipflop dff2(d2, notd2, d, targetClk);
    
    wire btnUPress;
    singlePulser sp1(btnUPress, btnU, targetClk);
    
//    wire btnCPress;
//    singlePulser sp2(btnCPress, btnC, targetClk);
    
//    always @(btnCPress)
//    begin
//        if (btnCPress == 1) begin
//            hexIn = 0;
//        end
//    end
    
    always @(posedge targetClk)
    begin
        if (btnUPress == 1) begin
            hexIn = hexIn + 1;
        end
    end
    
    assign an = 4'b1110;
    assign dp = 1'b1;
    
endmodule
