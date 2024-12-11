`timescale 1ns / 1ps
// Reference book: "FPGA Prototyping by Verilog Examples"
//                    "Xilinx Spartan-3 Version"
// Authored by: Pong P. Chu
// Published by: Wiley, 2008
// Adapted for use on Basys 3 FPGA with Xilinx Artix-7
// by: David J. Marion aka FPGA Dude

module ascii_test(
    input clk,
    input [3839:0] ascii_grid_flat,
    input video_on,
    input [9:0] x, y,
    output reg [11:0] rgb
    );
    
    // signal declarations
    wire [19:0] rom_addr;           // 20-bit text ROM address
    wire [15:0] ascii_char;          // 16-bit ASCII character code
    wire [11:0] ascii_index;        // 12-Bit index
    wire [3:0] char_row;            // 4-bit row of ASCII character
    wire [2:0] bit_addr;            // column number of ROM data
    wire [7:0] rom_data;            // 8-bit row data from text ROM
    wire ascii_bit, ascii_bit_on;     // ROM bit and status signal
    
    // instantiate ASCII ROM
    ascii_rom rom(.clk(clk), .addr(rom_addr[15:0]), .data(rom_data));

    assign ascii_index = ((x >= 16 && x < 336) && (y >= 208 && y < 304)) 
                     ? compute_ascii_index(x, y) 
                     : 12'd3840; // Default to an out-of-bound index when not in range.
    assign ascii_char = (ascii_index < 3840) 
                    ? ascii_grid_flat[ascii_index -: 16] 
                    : 16'h00; // Default value if out of range.
    function [11:0] compute_ascii_index(input [9:0] x, input [9:0] y);
    begin
        compute_ascii_index = 3839-((y-208)/16)*(16*40)-((x-16)/8)*16;
    end
    endfunction    
                 
    // ASCII ROM interface
    assign rom_addr = {ascii_char, char_row};   // ROM address is ascii code + row
    assign ascii_bit = rom_data[~bit_addr];     // reverse bit order

    //    assign ascii_char = ((x >= 16 && x < 96) && (y >= 208 && y < 272)) ? ascii_grid_flat[(y-208)/16][(x-16)/8] : 7'h00 ;              // 7-bit ascii code
    //    assign ascii_char = ((x >= 16 && x < 96) && (y >= 208 && y < 272)) ? ascii_grid_flat[279-((y-208)/16)*(7*10)-((x-16)/8)*7:(279-((y-208)/16)*(7*10)-((x-16)/8)*7)-6] : 7'h00;
    assign char_row = y[3:0];               // row number of ascii character rom
    assign bit_addr = x[2:0];               // column number of ascii character rom
    // "on" region in center of screen
    assign ascii_bit_on = ((x >= 16 && x < 336) && (y >= 208 && y < 304)) ? ascii_bit : 1'b0;
    
    // rgb multiplexing circuit
    always @*
        if(~video_on)
            rgb = 12'h000;      // blank
        else
            if (ascii_bit_on)
                rgb = 12'hFFF;  // white letters
            else if ((y >= 210 && y < 290 && x >= 512 && x < 514) ||
                (y >= 210 && y < 290 && x >= 582 && x < 584) ||
                (y >= 210 && y < 234 && x >= 512 && x < 584) ||
                (y >= 266 && y < 290 && x >= 512 && x < 584)) begin
                rgb = 12'hF00;
            end else if ((y >= 193 && y < 194 && x >= 360 && x < 616) ||
                  (y >= 304 && y < 305 && x >= 360 && x < 616) ||
                  (y >= 193 && y < 305 && x >= 360 && x < 361) ||
                  (y >= 193 && y < 305 && x >= 615 && x < 616) ||
                  (y >= 240 && y < 246 && x >= 520 && x < 536) ||
                  (y >= 246 && y < 262 && x >= 526 && x < 530) ||
                  (y >= 240 && y < 262 && x >= 540 && x < 544) ||
                  (y >= 244 && y < 252 && x >= 544 && x < 548) ||
                  (y >= 252 && y < 258 && x >= 548 && x < 552) ||
                  (y >= 240 && y < 262 && x >= 552 && x < 556) ||
                  (y >= 240 && y < 246 && x >= 560 && x < 576) ||
                  (y >= 246 && y < 262 && x >= 566 && x < 570)) begin 
                rgb = 12'h000;
            end else if ((y >= 210 && y < 234 && x >= 376 && x < 400) ||
                (y >= 210 && y < 234 && x >= 424 && x < 448) ||
                (y >= 242 && y < 250 && x >= 400 && x < 424) ||
                (y >= 250 && y < 274 && x >= 388 && x < 436) ||
                (y >= 250 && y < 286 && x >= 388 && x < 400) ||
                (y >= 250 && y < 286 && x >= 424 && x < 436)) begin
                rgb = 12'h0F0;
            end else if ((y >= 176 && y < 192 && x >= 8 && x < 632) ||
                (y >= 176 && y < 320 && x >= 8 && x < 10) ||
                (y >= 176 && y < 320 && x >= 630 && x < 632) ||
                (y >= 318 && y < 320 && x >= 8 && x < 632) ||
                (y >= 176 && y < 320 && x >= 344 && x < 632)) begin
                rgb = 12'hFFF;
            end else begin
                rgb = 12'h00F;  // blue background
            end
endmodule