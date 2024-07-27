`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/12 15:30:43
// Design Name: 
// Module Name: my_mp3
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


module mp3(
input clk,
input rst,
input DREQ,

output reg xRSET,
output reg XCS,
output reg XDCS,
output reg SI,
output reg SCLK
    );
    
parameter PRE = 0;
parameter CMD_START = 1;
parameter CMD_WRITE = 2;
parameter DATA_START = 3;
parameter DATA_WRITE = 4;
reg [2:0] state;

parameter PRE_TIME = 0;

parameter CMD_NUM = 2;
reg [2:0] cmd_cnt = 0;

wire mp3_clk;
Divider #(100) mp3clk(.I_CLK(clk),.rst(0), .O_CLK(mp3_clk));

parameter WIDTH = 32;
parameter DEPTH = 3340;
wire [WIDTH - 1:0] Data;
reg [WIDTH - 1:0] IData;
reg [13:0] addr;
blk_mem_gen_1 music(.clka(mp3_clk), .ena(1), .addra(addr), .douta(Data));

reg [32:0] cmd_mode = 32'h02000804;
reg [32:0] cmd_vol = 32'h020B0000;

integer cnt = 0;
integer pre_cnt = 0;

//FSM
always @(posedge mp3_clk)
begin
    if(!rst)
    begin
        xRSET <= 0;
        XCS <= 1;
        XDCS <= 1;
        SCLK <= 0;
        pre_cnt <= 0;
        cmd_cnt <= 0;
        cnt <= 0;
        addr <= 0;
        state <= PRE;
    end
    else
    begin
        case(state)
        //pre
            PRE:
            begin
                if(pre_cnt == PRE_TIME)
                begin
                    pre_cnt <= 0;
                    xRSET <= 1;
                    state <= CMD_START;
                end
                else
                    pre_cnt <= pre_cnt + 1;
            end
            //cmd_start
            CMD_START:
            begin
                SCLK <= 0;
                if(cmd_cnt == CMD_NUM)
                begin
                    cmd_cnt <= 0;
                    state <= DATA_START;
                end
                else if(DREQ)
                begin
                    cnt <= 0;
                    state <= CMD_WRITE;
                end
            end
            //cmd_write
            CMD_WRITE:
            begin
                if(DREQ)
                begin
                    if(mp3_clk)
                    begin
                        if(cnt == 32)
                        begin
                            cmd_cnt <= cmd_cnt + 1;
                            XCS <= 1;
                            cnt <= 0;
                            state <= CMD_START;
                        end
                        else
                        begin
                            XCS <= 0;
                            if(cmd_cnt == 0)
                            begin
                                SI <= cmd_mode[31];
                                cmd_mode <= {cmd_mode[30:0], cmd_mode[31]};
                            end
                            else if(cmd_cnt == 1)
                            begin
                                SI <= cmd_vol[31];
                                cmd_vol <= {cmd_vol[30:0], cmd_vol[31]};
                            end
                            cnt <= cnt + 1;
                        end
                    end
                    SCLK <= ~SCLK;
                end
            end
            //data_start
            DATA_START:
            begin
                if(DREQ)
                begin
                    SCLK <= 0;
                    IData <= Data;
                    cnt <= 0;
                    state <= DATA_WRITE;
                end
            end
            //data_write
            DATA_WRITE:
            begin
                if(SCLK)
                begin
                    if(cnt == WIDTH)
                    begin
                        XDCS <= 1;
                        addr <= addr + 1;
                        cnt <= 0;
                        state <= DATA_START;
                    end
                    else
                    begin
                        XDCS <= 0;
                        SI <= IData[WIDTH - 1];
                        IData <= {IData[WIDTH - 2:0], IData[WIDTH - 1]};
                        cnt <= cnt + 1;
                    end
                end
                SCLK <= ~SCLK;
            end

            default: ;
        endcase
    end
end
endmodule
