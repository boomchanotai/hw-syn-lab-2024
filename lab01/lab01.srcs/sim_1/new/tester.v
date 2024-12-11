`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/20/2024 01:22:02 PM
// Design Name: 
// Module Name: tester
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


module tester(

    );
    
    reg a1, b1, cin1, a2, b2, cin2;
    wire cout1, s1, cout2, s2;
    
    fullAdder test1(cout1,s1,a1,b1,cin1);
    fullAdder2 test2(cout2,s2,a2,b2,cin2);
    
    initial
    begin
        $monitor("time %t: {%b: %b} <- {%d %d %d}", $time,cout1, s1, a1, b1, cin1);
        #0;
        a1=0;
        b1=0;
        cin1=0;
        a2=0;
        b2=0;
        cin2=0;
        #10;
        a1=1;
        a2=1;
        #5;
        b1=1;
        b2=1;
        #5;
        cin1=1;
        cin2=1;
        #20;
        $finish;
    end
endmodule
