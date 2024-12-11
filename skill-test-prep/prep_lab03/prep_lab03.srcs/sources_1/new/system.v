`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2024 12:52:37 PM
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
    generate for(c=0; c<18; c=c+1)
    begin
        clockDiv fDiv(tclk[c+1], tclk[c]); // output: [c+1], input: [c]
    end endgenerate;
    clockDiv fDivTarget(targetClk, tclk[18]); // output: targetClk, input: last clk
    
    wire [3:0] num1, notnum1;
    wire [3:0] num2, notnum2;
    dFlipflop dFF0(num1[0], notnum1[0], sw[0], targetClk);
    dFlipflop dFF1(num1[1], notnum1[1], sw[1], targetClk);
    dFlipflop dFF2(num1[2], notnum1[2], sw[2], targetClk);
    dFlipflop dFF3(num1[3], notnum1[3], sw[3], targetClk);
    
    dFlipflop dFF4(num2[0], notnum2[0], sw[4], targetClk);
    dFlipflop dFF5(num2[1], notnum2[1], sw[5], targetClk);
    dFlipflop dFF6(num2[2], notnum2[2], sw[6], targetClk);
    dFlipflop dFF7(num2[3], notnum2[3], sw[7], targetClk);
    
    wire btn1, nbtn1; // u
    wire btn2, nbtn2; // c
    dFlipflop dFFBtn1(btn1, nbtn1, btnU, targetClk);
    dFlipflop dFFBtn2(btn2, nbtn2, btnC, targetClk);
    
    wire [6:0] segments;
    assign seg=segments;
    
    reg [3:0] hexIn;
    hexTo7Segment segDecode(segments,hexIn);
    
    reg [1:0] btnState = 2'b00;

    always @(btn1)
    begin
        if (btn1 == 1) begin
            btnState = 2'b01;
        end
    end
    
    always @(btn2)
    begin
        if (btn2 == 1) begin
            btnState = 2'b10;
        end
    end
    
    reg [3:0] inputControl;   
    assign an = inputControl;
    always @(btnState)
    begin
        case(btnState)
            2'b00:
            begin
                inputControl = 4'b1111;
            end
            2'b01:
            begin
                inputControl = 4'b1110;
                hexIn = num1;
            end
            2'b10:
            begin
                inputControl = 4'b1101;
                hexIn = num2;
            end
        endcase
    end
    
//    reg [3:0] inputControl;   
//    assign an = inputControl;
//    always @(num1)
//    begin
//        case(num1)
//            4'b0000: inputControl = 4'b1111; // No state
//            4'b0001: inputControl = 4'b0111;
//            4'b0010: inputControl = 4'b1011;
//            4'b0100: inputControl = 4'b1101;
//            4'b1000: inputControl = 4'b1110;
//        endcase
//    end
    
//    reg [7:0] segments;
//    assign seg = segments;
//    always @(num1)
//        case(num1)
//            4'b0000: segments = 7'b1111111; // No state
//            4'b0001: segments = 7'b1111001;
//            4'b0010: segments = 7'b0100100;
//            4'b0100: segments = 7'b0110000;
//            4'b1000: segments = 7'b0011001;
//        endcase
    
    assign dp = 1'b1;
    
    
endmodule
