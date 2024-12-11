`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2024 01:03:33 PM
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
    input [13:0] sw,
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
    
    reg [1:0] ns;
    reg [1:0] ps;
    
    always @(posedge targetClk)
        ps = ns;
    
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
    
    reg [13:0] num;
    
    reg [3:0] n2, n1, n3, n4, n5;
    always @(ps)
    begin
        num = sw[13:0];
        n1 = num % 10; // unit 1
        n2 = (num / 10) % 10; // unit 2
        n3 = (num / 100) % 10; // unit 3
        n4 = (num / 1000) % 10; // unit 4
        n5 = (num / 10000); // overflow
        if (n5 > 0) begin
            case(ps)
                2'b00: hexIn = 10;
                2'b01: hexIn = 10;
                2'b10: hexIn = 10;
                2'b11: hexIn = 10;
            endcase
        end else begin 
            case(ps)
                2'b00: hexIn = n4;
                2'b01: hexIn = n3;
                2'b10: hexIn = n2;
                2'b11: hexIn = n1;
            endcase
        end
    end
    
    assign dp = 1'b1;
endmodule
