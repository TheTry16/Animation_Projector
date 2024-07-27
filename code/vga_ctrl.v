`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/14 19:19:41
// Design Name: 
// Module Name: vga_ctrl
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


module vga_ctrl(
input wire vga_clk ,
input wire rst ,

output wire [9:0] pix_x ,
output wire [9:0] pix_y ,
output wire hsync ,
output wire vsync
    );
parameter H_SYNC = 10'd96 ,
     H_BACK_PORCH=10'd48,  
     H_VALID = 10'd640 , 
     H_FRONT_PORCH = 10'd16 , 
     H_TOTAL = 10'd800 ;
     parameter V_SYNC = 10'd2,
     V_BACK_PORCH =10'd33,
     V_VALID = 10'd480 ,
     V_FRONT_PORCH =10'd10,
     V_TOTAL = 10'd525 ;
    
     wire pix_data_req ;
    
     reg [9:0] cnt_h ; 
     reg [9:0] cnt_v ; 

     always@(posedge vga_clk or negedge rst)
     if(!rst)
     cnt_h <= 10'd0 ;
     else if(cnt_h == H_TOTAL - 1'd1)
     cnt_h <= 10'd0 ;
     else
     cnt_h <= cnt_h + 1'd1 ;
    
     //hsync
     assign hsync = (cnt_h <= H_SYNC - 1'd1) ? 1'b1 : 1'b0 ;
    
     always@(posedge vga_clk or negedge rst)
     if(!rst)
     cnt_v <= 10'd0 ;
     else if((cnt_v == V_TOTAL - 1'd1) && (cnt_h == H_TOTAL-1'd1))
     cnt_v <= 10'd0 ;
     else if(cnt_h == H_TOTAL - 1'd1)
     cnt_v <= cnt_v + 1'd1 ;
     else
     cnt_v <= cnt_v ;
    
     //vsync
     assign vsync = (cnt_v <= V_SYNC - 1'd1) ? 1'b1 : 1'b0 ;

    
     assign pix_data_req = (((cnt_h >= H_SYNC + H_BACK_PORCH - 1'b1)
     && (cnt_h<H_SYNC + H_BACK_PORCH + H_VALID - 1'b1))
     &&((cnt_v >= V_SYNC +  V_BACK_PORCH)
     && (cnt_v < V_SYNC +  V_BACK_PORCH + V_VALID)))
     ? 1'b1 : 1'b0;
     
     //pix_x,pix_y
     assign pix_x = (pix_data_req == 1'b1)
     ? (cnt_h - (H_SYNC + H_BACK_PORCH - 1'b1)) : 10'h3ff;
     assign pix_y = (pix_data_req == 1'b1)
     ? (cnt_v - (V_SYNC +  V_BACK_PORCH)) : 10'h3ff;
      
endmodule

