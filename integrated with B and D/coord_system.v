`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/11/2025 07:50:46 PM
// Design Name: 
// Module Name: coord_system
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


module coord_system(
    input [12:0] pixel_index,
    output [6:0] x,
    output [5:0] y
    );
    
    assign x = pixel_index % 96;
    assign y = pixel_index / 96;
    
endmodule
