`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2025 17:32:41
// Design Name: 
// Module Name: move_green_square
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


module move_green_square(
    input clock_1khz,
    input clock_30hz,
    input clock_25Mhz,
    input x,
    input y,
    input [3:0]pb,
    output reg [6:0]current_x,
    output reg [5:0]current_y,
    input switch
);
    
    reg [3:0]state;

    initial begin
        state = 0;
        current_x = 0;
        current_y = 54;
    end
    
    always @ (posedge clock_1khz) begin
        if (switch) begin
            if (pb != 4'b0000) begin
                state <= pb;
            end else begin
                state <= state;
            end
        end else begin
            state <= 0;
        end
    end
        
    always @ (posedge clock_30hz) begin
        if (switch) begin
            case (state)
                4'b0001: begin //move up
                    if ((current_x + 9 <= 65 || current_y > 30) && (current_y > 0)) begin
                        current_y <= current_y - 1;
                    end
                end
                4'b0010: begin //move down
                    current_y <= ( current_y + 9 != 63 ) ? current_y + 1 : current_y;
                end
                4'b0100: begin //move left
                    current_x <= ( current_x != 0 ) ? current_x - 1 : current_x;
                end
                4'b1000: begin //move right
                    if ((current_x + 9 < 65 || current_y >= 30) && (current_x + 9 < 95)) begin
                        current_x <= current_x + 1;
                    end
                end
                default: begin
                    current_x <= current_x;
                    current_y <= current_y;
                end
            endcase
        end else begin
            current_x <= 0;
            current_y <= 54;
        end
    end
    
endmodule