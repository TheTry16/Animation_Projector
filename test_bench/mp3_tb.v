`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/12 22:21:24
// Design Name: 
// Module Name: mp3_tb
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


module mp3_tb();
reg clk;
reg rst;
reg DREQ;

wire xRSET;
wire XCS;
wire XDCS;
wire SI;
wire SCLK;

my_mp3 mp3(.clk(clk), .rst(rst), .DREQ(DREQ), .xRSET(xRSET), .XCS(XCS), .XDCS(XDCS), .SI(SI), .SCLK(SCLK));

initial
begin
    clk = 0; rst = 0; DREQ = 0;
    #25 rst = 1;
    DREQ = 1;
end
always #2 clk = ~clk;
endmodule
