`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: Li Minxi
//  STUDENT B NAME: Felix Yuen Pin Qi
//  STUDENT C NAME: Ling Yijie Ryan
//  STUDENT D NAME: Lim Kai Sheng Isaac
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    input basys_clock,
    input [4:0]pb,
    output [7:0]JB,
    input [15:0]sw,
    output [7:0]seg,
    output [3:0]an,
    output reg [15:0]led
);

    //Clocks
    wire clk_6p25mhz, clk_25mhz, clk_30hz, clk_1khz, clk_500hz, clk_6hz, clk_10hz, clk_45hz;
    
    //Pixel display
    reg reset;
    reg [15:0]pixel_data;
    wire [12:0]pixel_index;
    wire fb, sending_pixels, sample_pixel;
    
    //Task A-D oled_data
    wire [15:0]oled_data_A;
    wire [15:0]oled_data_B;
    wire [15:0]oled_data_C;
    reg [15:0]oled_data_D;
    
    //Passwords for Task A - D
    reg [15:0] password_A = 16'b0001001001111001;
    reg [15:0] password_B = 16'b0010001010100101;
    reg [15:0] password_C = 16'b0100001101000101;
    reg [15:0] password_D = 16'b1000001010101101;
    
    //Display group ID
    reg [15:0]oled_display_groupID;
    
    //Task D
    wire [6:0]x;
    wire [5:0]y;
    wire [6:0]current_x;
    wire [5:0]current_y;
    wire [15:0]oled_data;
    reg [3:0]state = 0;
    
    //Task A
    wire [2:0]btn = {pb[1], pb[0], pb[4]};

    flexible_clock_divider my_6p25mhz_clk (.basys_clock(basys_clock), .m(32'b0111), .my_slow_clock(clk_6p25mhz));
    flexible_clock_divider my_25mhz_clk (.basys_clock(basys_clock), .m(32'b1), .my_slow_clock(clk_25mhz));
    flexible_clock_divider my_30hz_clk (.basys_clock(basys_clock), .m(32'h196E69), .my_slow_clock(clk_30hz));
    flexible_clock_divider my_1khz_clk (.basys_clock(basys_clock), .m(32'hC34F), .my_slow_clock(clk_1khz));
    flexible_clock_divider my_500hz_clk (.basys_clock(basys_clock), .m(32'h1869F), .my_slow_clock(clk_500hz));
    flexible_clock_divider my_6hz_clk (.basys_clock(basys_clock), .m(32'h7F2814), .my_slow_clock(clk_6hz));
    flexible_clock_divider my_10hz_clk (.basys_clock(basys_clock), .m(32'h4C4B3F), .my_slow_clock(clk_10hz));
    flexible_clock_divider slow_45HZ_clk (.basys_clock(basys_clock), .m(555555), .my_slow_clock(clk_45hz));

    Oled_Display led_display (
        .clk(clk_6p25mhz),
        .reset(0),
        .frame_begin(fb),
        .sending_pixels(sending_pixels),
        .sample_pixel(sample_pixel),
        .pixel_index(pixel_index),
        .pixel_data(oled_data),
        .cs(JB[0]),
        .sdin(JB[1]),
        .sclk(JB[3]),
        .d_cn(JB[4]),
        .resn(JB[5]),
        .vccen(JB[6]),
        .pmoden(JB[7])
    );
    
    //Converts pixel_index to x and y coordinates
    convert_to_xy xy_coordinates (.pixel_index(pixel_index), .x(x), .y(y));
    
    //Display pixel group ID
    //display_groupID show_07 (.clock(clk_25mhz), .x(x), .y(y), .data(oled_display_groupID));
    always @ (posedge clk_25mhz) begin
        if ((x >= 12 && x <= 40 && y >= 10 && y <= 18)
            || (x >= 12 && x <= 40 && y >= 40 && y <= 48)
            || (x >= 12 && x <= 20 && y >= 18 && y <= 40)
            || (x >= 32 && x <= 40 && y >= 18 && y <= 40)
            || (x >= 55 && x <= 78 && y >= 10 && y <= 18)
            || (x >= 70 && x <= 78 && y >= 18 && y <= 48)) begin
            oled_display_groupID = 16'b11111_000000_00000; //red
        end else begin
            oled_display_groupID = 16'b00000_000000_00000; //black
        end
    end
    
    //Display 7 seg group ID
    four_e3 show_seg_groupID (.CLK(clk_500hz), .seg(seg), .an(an));
        
    //Task A
    task_A t1 (
        .btn(btn),
        .sclk_1khz(clk_1khz),
        .pixel_index(pixel_index),
        .oled_data(oled_data_A),
        .switch(sw)
    );
    
    //Task B
    task_B bb (.clock_1kHZ(clk_1khz), .clock_6_25MHZ(clk_6p25mhz), .pb(pb), .x(x), .y(y), .sw(sw), .oledd(oled_data_B));

    //Task C
     Task_C tc (
         .sixp25MHz_clock(clk_6p25mhz),
         .fourtyfiveHz_clock(clk_45hz),
         .pixel_index(pixel_index),
         .SW(sw),
         .pb(pb),
         .oled_data(oled_data_C)
     );
     
    //Task D
    always @ (posedge clk_25mhz) begin
        if (x >= 66 && y <= 29) begin
            oled_data_D = 16'b11111_000000_00000; //red
        end else if (x >= current_x && x <= current_x + 9 && y >= current_y && y <= current_y + 9) begin
            oled_data_D = 16'b00000_111111_00000; //green
        end else begin
            oled_data_D = 16'b00000_000000_00000; //black
        end
    end
    
    move_green_square task_D (
        .clock_1khz(clk_1khz),
        .clock_30hz(clk_30hz),
        .clock_25Mhz(clk_25mhz),
        .x(x),
        .y(y),
        .pb(pb[3:0]),
        .current_x(current_x),
        .current_y(current_y),
        .switch(sw)
    );
    
    assign oled_data = ( password_A == sw ) ? oled_data_A
                        : ( password_B == sw ) ? oled_data_B
                        : ( password_C == sw ) ? oled_data_C
                        : ( password_D == sw ) ? oled_data_D
                        : oled_display_groupID;
                        
    //Blink leds if password correct
    always @ (*) begin
        case (sw)
            password_A: begin //0,3,4,5,6,9
                led[0] <= clk_6hz;
                led[3] <= clk_6hz;
                led[4] <= clk_6hz;
                led[5] <= clk_6hz;
                led[6] <= clk_6hz;
                led[9] <= clk_6hz;
            end
            password_B: begin //0,2,5,7,9
                led[0] <= clk_10hz;
                led[2] <= clk_10hz;
                led[5] <= clk_10hz;
                led[7] <= clk_10hz;
                led[9] <= clk_10hz;
            end
            password_C: begin //0,2,6,8,9
                led[0] <= clk_10hz;
                led[2] <= clk_10hz;
                led[6] <= clk_10hz;
                led[8] <= clk_10hz;
                led[9] <= clk_10hz;
            end
            password_D: begin //0,2,3,5,7,9
                led[0] <= clk_6hz;
                led[2] <= clk_6hz;
                led[3] <= clk_6hz;
                led[5] <= clk_6hz;
                led[7] <= clk_6hz;
                led[9] <= clk_6hz;
            end
            default begin
                led <= sw;
            end
                
        endcase
    end

endmodule
