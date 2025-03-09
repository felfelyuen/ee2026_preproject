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

module changeLED (
    input sw4,
    input SLOWCLK,
    input [9:0] x, 
    input [6:0] y, 
    output reg [15:0] LEDdata
    );
    
    always @ (posedge SLOWCLK) begin
    //oled_data = sw4 ? 16'hF800 : 16'h07E0;
    
       if ((x >= 5 & x <= 65 & y <= 20 & y >= 2) 
       | (x >= 40 & x <= 93 & y <= 40 & y >= 30)
       | (x >= 6 & x <= 20 & y <= 55 & y >= 50)) begin
       LEDdata = sw4 ? 16'h000F : 16'hF800;
       //oled_data = 16'h000F;
       end
       else begin
       LEDdata = sw4 ? 16'h8FA0 : 16'h07E0;
       //oled_data = 16'h8FA0;
       end
       
    end
endmodule

module increaseCOUNT (
    input button,
    input CLK,
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
endmodule

module firstSQ (
    input SLOWCLK,
    input [9:0] x,
    input [6:0] y,
    input [2:0] countONE,
    input [2:0] countTWO,
    input [2:0] countTHREE,
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

module taskTWO (
    input CLK,
    input CTRLbtn, 
    input UPbtn,
    input DOWNbtn,
    output [7:0] Jx
    
    );
    wire SLOWCLK;
    clock_6_25MHZ clovvk (CLK, SLOWCLK);
    
    reg [15:0] oled_data; wire [15:0] olede;
    wire [2:0] countONE; wire [2:0] countTWO; wire [2:0] countTHREE;
    
    wire sww;
    //assign sww = sw4;
    
    initial begin
    oled_data[0] <= olede[0];
    oled_data[1] <= olede[1];
    oled_data[2] <= olede[2];
    oled_data[3] <= olede[3];
    oled_data[4] <= olede[4];
    oled_data[5] <= olede[5];
    oled_data[6] <= olede[06];
    oled_data[7] <= olede[07];
    oled_data[8] <= olede[08];
    oled_data[9] <= olede[09];
    oled_data[10] <= olede[10];
    oled_data[11] <= olede[11];
    oled_data[12] <= olede[12];
    oled_data[13] <= olede[13];
    oled_data[14] <= olede[14];
    oled_data[15] <= olede[15];
    end    
    
    wire fb; wire [12:0] pi; wire sendp; wire samplep;
    Oled_Display oleddd (
    .clk(SLOWCLK), .reset(0), 
    .frame_begin(fb), .sending_pixels(sendp), .sample_pixel(samplep), 
    .pixel_index(pi), .pixel_data(olede), 
      .cs(Jx[0]), .sdin(Jx[1]), .sclk(Jx[3]), .d_cn(Jx[4]), .resn(Jx[5]), .vccen(Jx[6]),
      .pmoden(Jx[7]));
      
      //max x is 95, max y is 63
      wire [9:0] x; wire [6:0] y;
      assign x = pi % 96;
      assign y = pi / 96;
      
      increaseCOUNT upSQUARE (UPbtn, CLK, countONE);
      increaseCOUNT centralSQUARE (CTRLbtn, CLK, countTWO);
      increaseCOUNT downSQUARE (DOWNbtn, CLK, countTHREE);
      firstSQ ledi (SLOWCLK, x, y, countONE, countTWO, countTHREE, olede);

endmodule
