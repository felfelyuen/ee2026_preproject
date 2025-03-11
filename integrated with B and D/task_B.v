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
    
    reg [7:0] count200;
    reg pressed;
    
    initial begin
    count = 3'b000;
    count200 = 8'b0000_0000;
    pressed = 1'b0;
    end
    
    always @(posedge CLK) begin
    if (~SW) begin
        count = 0;
    end
    else if (button | pressed) begin
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
   // end
    end
endmodule

module firstSQ (
    input SLOWCLK,
    input [6:0] x,
    input [5:0] y,
    input [2:0] countONE,
    input [2:0] countTWO,
    input [2:0] countTHREE,
    //input SW,
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
    input clock_1kHZ,
    input clock_6_25MHZ,
    input [4:0] pb, 
    input [6:0] x, 
    input [5:0] y,
    input SW,
    output reg [15:0] oledd
    
    );
    wire SLOWCLK;
    
    wire [2:0] countONE; wire [2:0] countTWO; wire [2:0] countTHREE; wire [15:0] oled_data;
      
    increaseCOUNT upSQUARE (pb[0], clock_1kHZ, SW, countONE);
    increaseCOUNT centralSQUARE (pb[4], clock_1kHZ, SW, countTWO);
    increaseCOUNT downSQUARE (pb[1], clock_1kHZ, SW, countTHREE);
      firstSQ ledi (clock_6_25MHZ, x, y, countONE, countTWO, countTHREE, oled_data);
      
      always @(*) begin
      oledd[0] = oled_data[0];
      oledd[1] = oled_data[1];
      oledd[2] = oled_data[2];
      oledd[3] = oled_data[3];
      oledd[4] = oled_data[4];
      oledd[5] = oled_data[5];
      oledd[6] = oled_data[6];
      oledd[7] = oled_data[7];
      oledd[8] = oled_data[8];
      oledd[9] = oled_data[9];
      oledd[10] = oled_data[10];
      oledd[11] = oled_data[11];
      oledd[12] = oled_data[12];
      oledd[13] = oled_data[13];
      oledd[14] = oled_data[14];
      oledd[15] = oled_data[15];
      end

endmodule

