`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/20/2024 02:32:40 PM
// Design Name: 
// Module Name: tester4
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


module tester4(

    );
    
    reg clock, d;
    wire [1:0] q1, q2;
    
    shiftA sh1(q1, clock, d);
    shiftB sh2(q2, clock, d);
    
    always
        #5 clock=~clock;
    
    initial
    begin
        #0;
        clock=0;
        d=0;
        #10;
        d = 1;
        #10;
        d = 0;
        #20;
        d = 1;
        #10;
        d = 0;
        #20;
        $finish;
    end
endmodule
