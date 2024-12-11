`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2024 12:04:19 PM
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
    input btnU, // set
    input btnC, // check
    input btnR, // reset
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
    
    reg [6:0] check;
    reg [3:0] store;
    
    wire btnUPress;
    singlePulser sp1(btnUPress, btnU, targetClk);
    
    wire btnCPress;
    singlePulser sp3(btnCPress, btnC, targetClk);
    
    wire btnRPress;
    singlePulser sp2(btnRPress, btnR, targetClk);
    
    reg [1:0] ns;
    reg [1:0] ps;
    
    reg [6:0] segments;
    assign seg=segments;
    initial
    begin
        segments = 7'b0111111;
    end
    
    always @(posedge targetClk)
    begin
        ps = ns;
        case({btnUPress, btnCPress, btnRPress})
            3'b000: ;
            3'b100: 
            begin
                store[0] = sw[0];
                store[1] = sw[1];
                store[2] = sw[2];
                store[3] = sw[3];
            end
            3'b010: 
            begin
                check[0] = sw[0];
                check[1] = sw[1];
                check[2] = sw[2];
                check[3] = sw[3];
                
                if (check == store) begin
                    segments = 7'b1000110;
                end else begin
                    segments = 7'b0001110;
                end
            end
            3'b001: 
            begin
                segments = 7'b0111111;
            end
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
    
    assign dp = 1'b1;
    
endmodule
