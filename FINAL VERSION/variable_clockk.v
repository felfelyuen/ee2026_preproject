`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.03.2025 13:42:40
// Design Name: 
// Module Name: variable_clock
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


module variable_clock(
    input [4:0] state,
    input fourtyfiveHz_clock,
    output reg variable_clock = 0
    );
    
    reg [1:0] clk_div_counter = 2'd1;
    
    always @ (posedge fourtyfiveHz_clock) begin
        if (state == 5'd3 || state == 5'd4 || state == 5'd6 || state == 5'd7 || state == 5'd9 || state == 5'd10 || state == 5'd12 || state == 5'd15) begin
            if (clk_div_counter == 2'd3) begin 
                variable_clock <= ~variable_clock;
                clk_div_counter <= 2'd1;
            end else begin
                clk_div_counter <= clk_div_counter + 1;
            end
        end
        else begin
            if (clk_div_counter == 2'd3) begin
                clk_div_counter <= 2'd1;
            end else begin
                clk_div_counter <= clk_div_counter + 1;
            end
        variable_clock <= ~variable_clock;
        end
    end
    
endmodule