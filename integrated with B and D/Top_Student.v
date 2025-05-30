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


module Top_Student (
    input basys_clock,
    input [4:0] pb,
    output [7:0] JB,
    input [3:0] SW
);
    //Clocks
    wire clk_6p25mhz, clk_25mhz, clk_30hz, clk_1khz;
    
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
    coord_system xy_coordinates (.pixel_index(pixel_index), .x(x), .y(y));
    
    //Task A
    task_A t1 (
        .clk(basys_clock),
        .btn(btn),
        .sclk_1khz(clk_1khz),
        .pixel_index(pixel_index),
        .oled_data(oled_data_A),
        .sclk_6p25mhz(clk_6p25mhz),
        .switch(SW[0])
    );
    
    //Task B
    task_B bb (clk_1khz, clk_6p25mhz , pb, x, y, SW[1], oled_data_B);
    
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
        .switch(SW[3])
    );
    
    assign oled_data = ( SW == 4'b0001 ) ? oled_data_A
                        : (SW == 4'b0010) ? oled_data_B
                        : ( SW == 4'b1000 ) ? oled_data_D
                        : 16'b11111_000000_11111;

endmodule
