`timescale 1ns / 1ps

module top(
    input clk,          // 100MHz on Basys 3
    input reset,        // btnC on Basys 3
    output hsync,       // to VGA connector
    output vsync,       // to VGA connector
    output [11:0] rgb   // to DAC, to VGA connector
    );
    
    // signals
    wire [9:0] w_x, w_y;
    wire w_video_on, w_p_tick;
    reg [11:0] rgb_reg;
    wire [11:0] rgb_next;
    
    // Flattened ascii_grid (40 characters x 7 bits)
    reg [1679:0] ascii_grid_flat; 
    initial begin
        ascii_grid_flat = {
            7'h42, 7'h4F, 7'h4F, 7'h4D, 7'h43, 7'h48, 7'h41, 7'h4E, 7'h4F, 7'h54, 7'h41, 7'h49, 7'h2E, 7'h43, 7'h4F, 7'h4D, 7'h51, 7'h52, 7'h53, 7'h54, 7'h41, 7'h42, 7'h43, 7'h44, 7'h45, 7'h46, 7'h47, 7'h48, 7'h49, 7'h4A, 7'h4B, 7'h4C, 7'h4D, 7'h4E, 7'h4F, 7'h50, 7'h51, 7'h52, 7'h53, 7'h54,  // Row 1
            7'h61, 7'h62, 7'h63, 7'h64, 7'h65, 7'h66, 7'h67, 7'h68, 7'h69, 7'h6A, 7'h6B, 7'h6C, 7'h6D, 7'h6E, 7'h6F, 7'h6D, 7'h6E, 7'h6F, 7'h70, 7'h71, 7'h72, 7'h73, 7'h74, 7'h75, 7'h76, 7'h77, 7'h78, 7'h79, 7'h7A, 7'h4A, 7'h4B, 7'h4C, 7'h4D, 7'h4E, 7'h4F, 7'h50, 7'h51, 7'h52, 7'h53, 7'h54,  // Row 2
            7'h42, 7'h4F, 7'h4F, 7'h4D, 7'h43, 7'h48, 7'h41, 7'h4E, 7'h4F, 7'h54, 7'h41, 7'h49, 7'h2E, 7'h43, 7'h4F, 7'h4D, 7'h51, 7'h52, 7'h53, 7'h54, 7'h41, 7'h42, 7'h43, 7'h44, 7'h45, 7'h46, 7'h47, 7'h48, 7'h49, 7'h4A, 7'h4B, 7'h4C, 7'h4D, 7'h4E, 7'h4F, 7'h50, 7'h51, 7'h52, 7'h53, 7'h54,  // Row 3
            7'h42, 7'h4F, 7'h4F, 7'h4D, 7'h43, 7'h48, 7'h41, 7'h4E, 7'h4F, 7'h54, 7'h41, 7'h49, 7'h2E, 7'h43, 7'h4F, 7'h4D, 7'h51, 7'h52, 7'h53, 7'h54, 7'h41, 7'h42, 7'h43, 7'h44, 7'h45, 7'h46, 7'h47, 7'h48, 7'h49, 7'h4A, 7'h4B, 7'h4C, 7'h4D, 7'h4E, 7'h4F, 7'h50, 7'h51, 7'h52, 7'h53, 7'h54,  // Row 4
            7'h42, 7'h4F, 7'h4F, 7'h4D, 7'h43, 7'h48, 7'h41, 7'h4E, 7'h4F, 7'h54, 7'h41, 7'h49, 7'h2E, 7'h43, 7'h4F, 7'h4D, 7'h51, 7'h52, 7'h53, 7'h54, 7'h41, 7'h42, 7'h43, 7'h44, 7'h45, 7'h46, 7'h47, 7'h48, 7'h49, 7'h4A, 7'h4B, 7'h4C, 7'h4D, 7'h4E, 7'h4F, 7'h50, 7'h51, 7'h52, 7'h53, 7'h54,  // Row 5
            7'h42, 7'h4F, 7'h4F, 7'h4D, 7'h43, 7'h48, 7'h41, 7'h4E, 7'h4F, 7'h54, 7'h41, 7'h49, 7'h2E, 7'h43, 7'h4F, 7'h4D, 7'h51, 7'h52, 7'h53, 7'h54, 7'h41, 7'h42, 7'h43, 7'h44, 7'h45, 7'h46, 7'h47, 7'h48, 7'h49, 7'h4A, 7'h4B, 7'h4C, 7'h4D, 7'h4E, 7'h4F, 7'h50, 7'h51, 7'h52, 7'h53, 7'h54  // Row 6
        };
    end
    
    // VGA Controller
    // RUN NUMBER
    vga_controller vga(.clk_100MHz(clk), .reset(reset), .hsync(hsync), .vsync(vsync),
                       .video_on(w_video_on), .p_tick(w_p_tick), .x(w_x), .y(w_y));
    // Text Generation Circuit
    // gen text
    ascii_test at(.clk(clk), .ascii_grid_flat(ascii_grid_flat), .video_on(w_video_on), .x(w_x), .y(w_y), .rgb(rgb_next));
    
    // rgb buffer
    always @(posedge clk)
        if(w_p_tick)
            rgb_reg <= rgb_next;
            
    // output
    assign rgb = rgb_reg;
      
endmodule