`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2024 09:00:22 PM
// Design Name: 
// Module Name: ascii_grid
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


module ascii_grid(
    input clk,
    input data_valid,
    input keyboard_valid,
    input reset,
    input [7:0] data_transmitted,
    input [7:0] keyboard_data,
    output reg [3839:0] ascii_grid_flat,
    output reg [7:0] iterator
    );
    
    initial iterator = 8'b0;
    
//    initial begin
//        ascii_grid_flat = {
//            7'h42, 7'h4F, 7'h4F, 7'h4D, 7'h43, 7'h48, 7'h41, 7'h4E, 7'h4F, 7'h54, 7'h41, 7'h49, 7'h2E, 7'h43, 7'h4F, 7'h4D, 7'h51, 7'h52, 7'h53, 7'h54, 7'h41, 7'h42, 7'h43, 7'h44, 7'h45, 7'h46, 7'h47, 7'h48, 7'h49, 7'h4A, 7'h4B, 7'h4C, 7'h4D, 7'h4E, 7'h4F, 7'h50, 7'h51, 7'h52, 7'h53, 7'h54,  // Row 1
//            7'h61, 7'h62, 7'h63, 7'h64, 7'h65, 7'h66, 7'h67, 7'h68, 7'h69, 7'h6A, 7'h6B, 7'h6C, 7'h6D, 7'h6E, 7'h6F, 7'h4D, 7'h51, 7'h52, 7'h53, 7'h54, 7'h41, 7'h42, 7'h43, 7'h44, 7'h45, 7'h46, 7'h47, 7'h48, 7'h49, 7'h4A, 7'h4B, 7'h4C, 7'h4D, 7'h4E, 7'h4F, 7'h50, 7'h51, 7'h52, 7'h53, 7'h54,  // Row 2
//            7'h42, 7'h4F, 7'h4F, 7'h4D, 7'h43, 7'h48, 7'h41, 7'h4E, 7'h4F, 7'h54, 7'h41, 7'h49, 7'h2E, 7'h43, 7'h4F, 7'h4D, 7'h51, 7'h52, 7'h53, 7'h54, 7'h41, 7'h42, 7'h43, 7'h44, 7'h45, 7'h46, 7'h47, 7'h48, 7'h49, 7'h4A, 7'h4B, 7'h4C, 7'h4D, 7'h4E, 7'h4F, 7'h50, 7'h51, 7'h52, 7'h53, 7'h54,  // Row 3
//            7'h42, 7'h4F, 7'h4F, 7'h4D, 7'h43, 7'h48, 7'h41, 7'h4E, 7'h4F, 7'h54, 7'h41, 7'h49, 7'h2E, 7'h43, 7'h4F, 7'h4D, 7'h51, 7'h52, 7'h53, 7'h54, 7'h41, 7'h42, 7'h43, 7'h44, 7'h45, 7'h46, 7'h47, 7'h48, 7'h49, 7'h4A, 7'h4B, 7'h4C, 7'h4D, 7'h4E, 7'h4F, 7'h50, 7'h51, 7'h52, 7'h53, 7'h54,  // Row 4
//            7'h42, 7'h4F, 7'h4F, 7'h4D, 7'h43, 7'h48, 7'h41, 7'h4E, 7'h4F, 7'h54, 7'h41, 7'h49, 7'h2E, 7'h43, 7'h4F, 7'h4D, 7'h51, 7'h52, 7'h53, 7'h54, 7'h41, 7'h42, 7'h43, 7'h44, 7'h45, 7'h46, 7'h47, 7'h48, 7'h49, 7'h4A, 7'h4B, 7'h4C, 7'h4D, 7'h4E, 7'h4F, 7'h50, 7'h51, 7'h52, 7'h53, 7'h54,  // Row 5
//            7'h42, 7'h4F, 7'h4F, 7'h4D, 7'h43, 7'h48, 7'h41, 7'h4E, 7'h4F, 7'h54, 7'h41, 7'h49, 7'h2E, 7'h43, 7'h4F, 7'h4D, 7'h51, 7'h52, 7'h53, 7'h54, 7'h41, 7'h42, 7'h43, 7'h44, 7'h45, 7'h46, 7'h47, 7'h48, 7'h49, 7'h4A, 7'h4B, 7'h4C, 7'h4D, 7'h4E, 7'h4F, 7'h50, 7'h51, 7'h52, 7'h53, 7'h54  // Row 6
//        };
//    end
    
    reg debounce;
	initial debounce = 0;
	
	// *** Generate 25MHz from 100MHz *********************************************************
	reg  [1:0] r_25MHz;
	wire w_25MHz;
	
	always @(posedge clk or posedge reset)
		if(reset)
		  r_25MHz <= 0;
		else
		  r_25MHz <= r_25MHz + 1;
	
	assign w_25MHz = (r_25MHz == 0) ? 1 : 0; // assert tick 1/4 of the time
    // ****************************************************************************************
	
	integer i;
	
	reg [23:0] thai_char;
	reg is_thai;
	reg [1:0] thai_char_count;
	
	
	reg dvalid;
	reg [7:0] inp;
	
	initial begin
        is_thai = 0;
        dvalid = 0;
        inp = 8'd0;
	end
    
    always @(posedge w_25MHz or posedge reset or posedge keyboard_valid) begin
        if (reset) begin
            iterator = 8'b0; // Reset iterator correctly
            is_thai = 0;
            thai_char_count = 0;
            thai_char = 24'b0; // Reset thai_char
            debounce = 0;
            ascii_grid_flat = 3840'b0;
        end else if (keyboard_valid || data_valid) begin
            if (keyboard_valid) begin
                dvalid = 1;
                inp = keyboard_data;
            end else if (data_valid) begin
                dvalid = 1;
                inp = data_transmitted;
            end
        
            if (debounce == 0) begin
                if (is_thai) begin
                    if(thai_char_count == 2) begin
                        ascii_grid_flat[(3839 - (iterator * 16)) -: 16] = {thai_char[15:8], inp};
                        iterator = (iterator + 1) % 240;
                        thai_char = 24'b0; // Clear the thai_char buffer
                        is_thai = 0;
                    end else begin
                        case (thai_char_count)
                            0: thai_char[23:16] = inp;
                            1: thai_char[15:8] = inp;
                            default: ; // Do nothing for unexpected values
                        endcase
                        thai_char_count = thai_char_count + 1;
                    end
                end else begin
                    if(inp == 8'h0D) begin
                        iterator = (((iterator / 40) + 1) % 6) * 40;
                    end else if (inp == 8'h7F) begin
                        if (iterator > 0) begin
                            iterator = iterator - 1;
                            ascii_grid_flat[(3839 - (iterator * 16)) -: 16] = 16'h0000;
                        end
                    end else if (inp == 8'hE0) begin 
                        is_thai = 1;
                        thai_char_count = 0;
                        thai_char[23:16] = inp;
                        thai_char_count = thai_char_count + 1;
                    end else begin
                        ascii_grid_flat[(3839 - (iterator * 16)) -: 16] = {8'b00000000, inp};
                        iterator = (iterator + 1) % 240;
                    end
                end
            end
            debounce = 1;
        end else if (!keyboard_valid && !data_valid) begin
            debounce = 0;
        end
    end
endmodule
