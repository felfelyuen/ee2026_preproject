`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2025 08:28:23 PM
// Design Name: 
// Module Name: clock_10HZ
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

module clock_10HZ(
    input CLK,
    output reg SLOWCLK
    );
        reg [22:0] count = 23'h00_0000;
    initial begin
        SLOWCLK <= 0;
    end
    always @ (posedge CLK) begin
    count <= (count == 23'h4C_4B3F) ? 23'h00_0000 : count + 1;
    SLOWCLK <= (count == 23'h00_0000) ? ~SLOWCLK : SLOWCLK; 
    end
endmodule

module clock_6HZ (
    input CLK,
    output reg SLOWCLK
);
    reg [23:0] count = 24'h00_0000;
    initial begin
        SLOWCLK <= 0;
    end
    always @ (posedge CLK) begin
        count <= (count == 24'hFE502A) ? 24'h00_0000 : count + 1;
        SLOWCLK <= (count == 24'h00_0000) ? ~SLOWCLK : SLOWCLK; 
    end
endmodule

module LED_flicker (
    input CLK, //set a slow clock here
    output reg LED
);
    initial begin
        LED <= 0;
    end
    
    always @ (CLK) begin
        LED = ~LED;
    end
endmodule
