`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2024 12:01:12 AM
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
    input btnL,
    input btnR,
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
    
    reg [3:0] num1;
    
    wire btnLPress;
    singlePulser sp1(btnLPress, btnL, targetClk);
    
    wire btnRPress;
    singlePulser sp2(btnRPress, btnR, targetClk);
    
    reg [3:0] n1, n2, n3, n4;
    initial
    begin
        n1 = 0;
        n2 = 0;
        n3 = 0;
        n4 = 0;
    end
    
    reg [1:0] ns;
    reg [1:0] ps;
    
    always @(posedge targetClk)
    begin
        ps = ns;
        num1[0] = sw[0];
        num1[1] = sw[1];
        num1[2] = sw[2];
        num1[3] = sw[3];
        
        case({btnLPress, btnRPress})
            2'b00: ;
            2'b10:
            begin
                n1 = n2;
                n2 = n3;
                n3 = n4;
                n4 = num1;
            end
            2'b01:
            begin
                n4 = n3;
                n3 = n2;
                n2 = n1;
                n1 = num1;
            end
            2'b11: ;
        endcase
    end
        
    always @(ps)
        ns = ps + 1;
    
    
    reg [3:0] inputControl;   
    assign an = inputControl; 
    always @(ps)
        case(ps)
            2'b00: inputControl = 4'b0111;
            2'b01: inputControl = 4'b1011;
            2'b10: inputControl = 4'b1101;
            2'b11: inputControl = 4'b1110;
        endcase
    
    
    wire [6:0] segments;
    assign seg=segments;
    
    reg [3:0] hexIn = 0;
    hexTo7Segment segDecode(segments,hexIn);
    
    always @(ps)
        case(ps)
            2'b00: hexIn = n1;
            2'b01: hexIn = n2;
            2'b10: hexIn = n3;
            2'b11: hexIn = n4;
        endcase
    
    assign dp = 1'b1;
endmodule
