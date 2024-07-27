`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/26 22:31:26
// Design Name: 
// Module Name: display7
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



module display7(
    input clk,
    output reg [7:0] enable,
    output reg [6:0] oData
);
    
    reg [17:0]  cnt = 0;
    reg [3:0]   num_current;
    
    always @(posedge clk)
    begin
        cnt = cnt + 1;
        case(cnt[17:15])
            3'b000:
            begin
                enable     <= 8'b1111_1111;
                num_current <= 4'd0;
            end
            3'b001:
            begin
               enable    <= 8'b1011_1111;
                num_current <= 4'd4;
            end
            3'b010:
            begin
              enable    <= 8'b1101_1111;
                num_current <=4'd3;
            end
            3'b011:
            begin
               enable     <= 8'b1110_1111;
                num_current <= 4'd6;
            end
            3'b100:
            begin
                enable   <= 8'b1111_0111;
                num_current <= 4'd6;
            end
            3'b101:
            begin
                enable     <= 8'b1111_1011;
                num_current <= 4'd7;
            end
            3'b110:
            begin
                enable     <= 8'b1111_1101;
                num_current <= 4'd7;
            end
            3'b111:
            begin
                enable     <= 8'b1111_1110;
                num_current <= 4'd6;
            end
        endcase
    end
    
    always @(*)
    begin
        case(num_current)
            4'd0    : oData <= 7'b1000000;
            4'd1    : oData <= 7'b1111001;
            4'd2    : oData <= 7'b0100100;
            4'd3    : oData <= 7'b0110000;
            4'd4    : oData <= 7'b0011001;
            4'd5    : oData <= 7'b0010010;
            4'd6    : oData <= 7'b0000010;
            4'd7    : oData <= 7'b1111000;
            4'd8    : oData <= 7'b0000000;
            4'd9    : oData <= 7'b0010000;
            default : oData <= 7'b1111111;
        endcase
    end
    
endmodule