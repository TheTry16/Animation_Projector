`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/14 19:47:43
// Design Name: 
// Module Name: top
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


module top(
input clk,
input rst,

//mp3
input DREQ,
output xRSET,
output XCS,
output XDCS,
output SI,
output SCLK

//vga
output hsync,
output vsync,
output [11:0] pic_data,

//display7
output [7:0] enable,
output [6:0] oData
    );

//vga
wire [9:0] pix_x;
wire [9:0] pix_y;
wire vga_clk;

Divider #(4) (
.I_CLK(clk), 
.rst(0), 
.O_CLK(vga_clk)
);

//mp3
mp3 my_mp3(
    .clk(clk),
    .rst(rst),
    .DREQ(DREQ),
    .xRSET(xRSET),
    .XCS(XCS),
    .XDCS(XDCS),
    .SI(SI),
    .SCLK(SCLK)
);

//vga_ctrl
vga_ctrl my_ctrl(
    .vga_clk(vga_clk),
    .rst(rst),
    .pix_x(pix_x), 
    .pix_y(pix_y),
    .hsync(hsync),
    .vsync(vsync)
);
    
//vga_display
vga_display my_display(
    .vga_clk(vga_clk),
    .rst(rst),
    .pix_x(pix_x), 
    .pix_y(pix_y), 
    .data_out(pic_data) 
);

//display7
display7 my_7(
    .clk(clk),
    .enable(enable),
    .oData(oData)
);
endmodule
