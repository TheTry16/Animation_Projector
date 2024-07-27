`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/21 17:11:35
// Design Name: 
// Module Name: Divider
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


module Divider(
    input I_CLK,
    input rst,
    output O_CLK
    );
parameter N = 20;

reg [4:0] count = 0;
reg out = 0;
always @(posedge I_CLK)
if(rst)
    begin
        out <= 0;
        count <= 0;
    end
else
    if(count < N / 2 - 1)
        begin
            count <= count + 1;
            out <= out;
        end
    else
        begin
            count <= 0;
            out <= ~out;
         end     
assign O_CLK = out;
endmodule
