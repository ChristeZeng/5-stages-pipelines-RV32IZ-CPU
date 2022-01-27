`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/05 16:20:49
// Design Name: 
// Module Name: IFID
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


module IF(
    input clk,
    input en,
    input clc,
    input [31:0] PC_In,
    output reg [31:0] PCF
    );
    initial PCF = 0;
    
    always@(posedge clk) begin
        if(en) begin
            if(clc) PCF <= 0;
            else    PCF <= PC_In;
        end
    end
endmodule
