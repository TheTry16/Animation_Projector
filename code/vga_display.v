`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/14 19:20:30
// Design Name: 
// Module Name: vga_display
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


module vga_display(
input vga_clk,
input rst, 
input [9:0] pix_x, 
input [9:0] pix_y,
 
output [11:0] data_out
    );
parameter H_VALID = 10'd640; 
parameter V_VALID = 10'd480;  
     
parameter H_PIC = 10'd500;
parameter W_PIC = 10'd312; 
parameter PIC_SIZE = 18'd156000;
    
    parameter   RED     =   16'hF800    , 
                ORANGE  =   16'hFC00    ,   
                YELLOW  =   16'hFFE0    ,    
                GREEN   =   16'h07E0    ,    
                CYAN    =   16'h07FF    ,     
                BLUE    =   16'h001F    ,
                PURPPLE =   16'hF81F    ,  
                BLACK   =   16'h0000    ,   
                WHITE   =   16'hFFFF    ,
                GRAY    =   16'hD69A    ; 
    
    wire ena;  
    wire [15:0]  pic_data;   
    reg  [17:0] addr;
    
    reg             pic_valid   ; 
    reg     [15:0]  pix_data;

    assign  ena = (((pix_x >= (((H_VALID - H_PIC)/2) - 1'b1))  
                            && (pix_x < (((H_VALID - H_PIC)/2) + H_PIC - 1'b1)))  
                            &&((pix_y >= ((V_VALID - W_PIC)/2))  
                            && ((pix_y < (((V_VALID - W_PIC)/2) + W_PIC)))));
                            
    always@(posedge vga_clk or negedge rst)  
        if(rst == 1'b0)  
            addr    <=  17'd0;  
        else    if(addr == (PIC_SIZE - 1'b1))  
            addr    <=  17'd0;  
        else    if(ena == 1'b1)  
            addr    <=  addr + 1'b1;
            
    always@(posedge vga_clk or negedge rst)  
                if(rst == 1'b0)  
                    pic_valid   <=  1'b1;  
                else  
                    pic_valid   <=  ena;  
             
     assign  data_out = (pic_valid == 1'b1) ? {pic_data[15:12],pic_data[10:7],pic_data[4:1]}
                                            : {pix_data[15:12],pix_data[10:7],pix_data[4:1]};
    blk_mem_gen_0 tuanzi  
     (  
         .addra(addr),
         .clka(vga_clk),    
         .ena(ena),
         .douta (pic_data)
     );        
    
endmodule

