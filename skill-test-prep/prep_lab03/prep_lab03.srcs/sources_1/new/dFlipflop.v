`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2024 01:35:46 PM
// Design Name: 
// Module Name: dFlipflop
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


module dFlipflop(
    output reg q,
    output reg notq,
    input d,
    input clk
    );
    
    reg state;
    initial
    begin
        state = 0;
    end
        
    always @(posedge clk)
    begin
        state = d;
    end
    
    always @(state)
    begin
        q = state;
        notq = ~state;
    end
    
endmodule
