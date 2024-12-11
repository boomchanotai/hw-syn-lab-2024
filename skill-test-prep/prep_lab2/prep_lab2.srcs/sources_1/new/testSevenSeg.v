`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2024 12:08:41 AM
// Design Name: 
// Module Name: testSevenSeg
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


module testSevenSeg(
    output [6:0] seg,
    output [3:0] an,
    output dp,
    input clk
    );
    
    reg [1:0] ns;
    reg [1:0] ps;
    
    always @(posedge clk)
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
    
    
    reg [7:0] segments;
    assign seg = segments;
    always @(ps)
        case(ps)
            2'b00: segments = 7'b1111001;
            2'b01: segments = 7'b0100100;
            2'b10: segments = 7'b0110000;
            2'b11: segments = 7'b0011001;
        endcase
    
    assign dp = 1'b1;
endmodule
