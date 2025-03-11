`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/11/2025 07:58:15 PM
// Design Name: 
// Module Name: flexible_clock_divider
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


module flexible_clock_divider(
    input basys_clock,
    input [31:0]m,
    output reg my_slow_clock
    );
    
    reg [31:0] COUNT;
    
    initial begin
        COUNT = 0;
        my_slow_clock = 1;
    end
    
    always @ (posedge basys_clock) begin
        COUNT <= ( COUNT == m ) ? 0 : COUNT + 1;
        my_slow_clock <= ( COUNT == m ) ? ~my_slow_clock : my_slow_clock;
    end
    
endmodule
