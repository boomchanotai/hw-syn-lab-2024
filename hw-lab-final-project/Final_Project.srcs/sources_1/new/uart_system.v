`timescale 1ns / 1ps

module uart_system(
    input clk,
    input rx,
    input [7:0] sw_in,
    input btnSent,
    output tx,
    output wire [7:0] data_received,
    output reg data_valid,
    output reg [7:0] data_transmitted
    );
    
    reg en, last_rec;
    reg [7:0] data_in;
    wire received, baud, sent;
  
    baud_gen baudrate_gen(clk, baud);
    uart_rx RX(baud, rx, received, data_received);
    uart_tx TX(baud, data_in, en, sent, tx);
    
    always @(posedge baud) begin
        if (en) en <= 0;

        // Trigger on new data reception or button press
        if ((~last_rec & received) || btnSent) begin
            en <= 1;
            data_in = (btnSent ? sw_in : data_received); // Use `sw_in` if button is pressed, else `data_received`
            data_transmitted = data_in; // Update transmitted data
            data_valid = 1;  // Assert valid signal for one clock
        end else begin
            data_valid = 0;  // Clear valid signal immediately in the next cycle
        end
        
        last_rec <= received; // Store the received signal for edge detection
    end
    
endmodule
