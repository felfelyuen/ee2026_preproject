`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2025 07:30:24 PM
// Design Name: 
// Module Name: four_e3
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

module slowCLOCK (
    input CLK,
    output reg SLOWCLK
    );
        
    reg [16:0] count = 17'h0000;
    initial begin
        SLOWCLK <= 0;
    end
    always @ (posedge CLK) begin
    count <= (count == 17'h1869F) ? 17'h00000 : count + 1;
    SLOWCLK <= (count == 17'h00000) ? ~SLOWCLK : SLOWCLK; 
    end
    
endmodule

module four_e3(
    input CLK,
    output reg [7:0] seg,
    output reg [3:0] an
);
    reg [2:0] count; 
    initial begin
    count = 3'b000;
    end
    
    wire SLOWCLK;
    slowCLOCK clovk (CLK, SLOWCLK);
    
    always @ (posedge SLOWCLK) begin
        count = (count == 4) ? 0 : count + 1;
        if (count == 0) begin
            seg = 8'b1001_0010;
            an = 4'b0111;
        end
        else if (count == 1) begin
            seg = 8'b0011_0000;
            an = 4'b1011;
        end
        else if (count == 2) begin
            seg = 8'b1100_0000;
            an = 4'b1101;
        end
        else if (count == 3) begin
            seg = 8'b1111_1000;
            an = 4'b1110;
        end
    end
endmodule
