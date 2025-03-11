`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME:  
//
//////////////////////////////////////////////////////////////////////////////////

module clock_6_25MHZ (
    input CLK, 
    output reg SLOWCLK
    );
     
    reg [3:0] count = 4'b0000;
    initial begin
        SLOWCLK <= 0;
    end
    always @ (posedge CLK) begin
    count <= (count == 4'b0111) ? 4'b0000 : count + 1;
    SLOWCLK <= (count == 4'b0000) ? ~SLOWCLK : SLOWCLK; 
    end
endmodule

module clock_1kHZ ( //incremenets every 1ms
    input CLK, 
    output reg SLOWCLK
    );
    
    reg [15:0] count = 16'h0000;
    initial begin
        SLOWCLK <= 0;
    end
    always @ (posedge CLK) begin
    count <= (count == 16'hC34F) ? 16'h0000 : count + 1;
    SLOWCLK <= (count == 16'h0000) ? ~SLOWCLK : SLOWCLK; 
    end
endmodule

module increaseCOUNT (
    input button,
    input CLK,
    input SW,
    output reg [2:0] count
    );
    
    wire SLOWCLK; 
    reg [7:0] count200;
    reg pressed;
    
    clock_1kHZ clovk (CLK, SLOWCLK);
    
    initial begin
    count = 3'b000;
    count200 = 8'b0000_0000;
    pressed = 1'b0;
    end
    
    always @(posedge SLOWCLK) begin
    if (SW) begin
    
    if (button | pressed) begin
        if (count200 == 0) begin
            //200ms ignore time is passed
            if (button) begin
                if (~pressed) begin
                count = count + 1;
                count = (count == 3'b110) ? 0 : count;
                count200 = count200 + 1;
                pressed = 1;
                end
                end
            else begin
                pressed = 0;
                end
        end
        else begin
            //in 200ms ignore mode
            count200 = (count200 == 200) ? 0 : count200 + 1;
        end
    end
    end
    end
endmodule

module firstSQ (
    input SLOWCLK,
    input [9:0] x,
    input [6:0] y,
    input [2:0] countONE,
    input [2:0] countTWO,
    input [2:0] countTHREE,
    input SW,
    output reg [15:0] LEDdata
    );
    
    always @ (posedge SLOWCLK) begin
        if (x >= 42 & x <= 55 & y <= 16 & y >= 3) begin
            if (countONE == 0) begin
                LEDdata = 16'hFFFF; //white
            end 
            else if (countONE == 1) begin
                LEDdata = 16'hF800; //red
            end
            else if (countONE == 2) begin
                LEDdata = 16'h07E0; //green
            end
            else if (countONE == 3) begin //blue
                LEDdata = 16'h001F;
            end
            else if (countONE == 4) begin  //orange
                LEDdata = 16'hFD20;
            end
            else if (countONE == 5) begin  //black
                LEDdata = 16'h0000;
            end
        end
        else 
        if (x >= 42 & x <= 55 & y <= 32 & y >= 19) 
            begin
                if (countTWO == 0) begin
                    LEDdata = 16'hFFFF; //white
                end 
                else if (countTWO == 1) begin
                    LEDdata = 16'hF800; //red
                end
                else if (countTWO == 2) begin
                    LEDdata = 16'h07E0; //green
                end
                else if (countTWO == 3) begin //blue
                    LEDdata = 16'h001F;
                end
                else if (countTWO == 4) begin  //orange
                    LEDdata = 16'hFD20;
                end
                else if (countTWO == 5) begin  //black
                       LEDdata = 16'h0000;
                end
        end 
        else if (x >= 42 & x <= 55 & y <= 48 & y >= 35) 
            begin
            if (countTHREE == 0) begin
                LEDdata = 16'hFFFF; //white
            end 
            else if (countTHREE == 1) begin
                LEDdata = 16'hF800; //red
            end
            else if (countTHREE == 2) begin
                LEDdata = 16'h07E0; //green
            end
            else if (countTHREE == 3) begin //blue
                LEDdata = 16'h001F;
            end
            else if (countTHREE == 4) begin  //orange
                LEDdata = 16'hFD20;
            end
            else if (countTHREE == 5) begin  //black
                LEDdata = 16'h0000;
            end
            end 
       else if ( ((x - 48)*(x - 48) + (y - 56)*(y - 56)) <= 42 )
            begin
            if (countTHREE == 1 & countTWO == 1 & countONE == 1) begin
                LEDdata = 16'hF800; //red
                end
            else if (countTHREE == 4 & countTWO == 4 & countONE == 4) begin  //orange
                LEDdata = 16'hFD20;
                end
            end 
       else begin
       LEDdata = 16'h0000;
       end
   end
endmodule

module task_B (
    input CLK,
    input [4:0] pb, 
    input x,
    input y,
    input SW,
    output [7:0] Jx
    );
    wire SLOWCLK;
    clock_6_25MHZ clovvk (CLK, SLOWCLK);
    
    wire [15:0] oled_data;
    wire [2:0] countONE; wire [2:0] countTWO; wire [2:0] countTHREE;
    
    increaseCOUNT upSQUARE (pb[0], CLK, SW, countONE);
    increaseCOUNT centralSQUARE (pb[4], CLK, SW, countTWO);
    increaseCOUNT downSQUARE (pb[1], CLK, SW, countTHREE);
    firstSQ ledi (SLOWCLK, x, y, countONE, countTWO, countTHREE, SW, oled_data);

endmodule
