`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.03.2025 20:39:44
// Design Name: 
// Module Name: display_groupID
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


module display_groupID(
    input clock,
    input x,
    input y,
    output reg [15:0]data
);
        
    always @ (posedge clock) begin
        if ((x >= 12 && x <= 40 && y >= 10 && y <= 18)
            || (x >= 12 && x <= 40 && y >= 40 && y <= 48)
            || (x >= 12 && x <= 20 && y >= 18 && y <= 40)
            || (x >= 32 && x <= 40 && y >= 18 && y <= 40)
            || (x >= 55 && x <= 78 && y >= 10 && y <= 18)
            || (x >= 70 && x <= 78 && y >= 18 && y <= 48)) begin
            data = 16'b11111_000000_00000; //red
        end else begin
            data = 16'b00000_000000_00000; //black
        end
    end
    
endmodule