`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/06 16:42:54
// Design Name: 
// Module Name: WB
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


module WB(
    input clk, 
    input en,
    input clc,
    
    input [31:0] ResultM,
    input [4:0] rdM,
    input RegWriteM,
    input [1:0] MemtoRegM,
    input [31:0] PCM,
    input [31:0] InsM,
    
    output reg [31:0] ResultW,
    output reg [4:0] rdW,
    output reg RegWriteW,
    output reg [1:0] MemtoRegW,
    output reg [31:0] PCW,
    output reg [31:0] InsW
    );
    
    initial begin
        ResultW   = 0;
        rdW       = 0;
        MemtoRegW = 0;
        RegWriteW = 0;
        PCW       = 0;
        InsW      = 0;
    end
    
    always @(posedge clk) begin
        if(en) begin
            RegWriteW  <= clc ? 0 : RegWriteM;
            rdW        <= clc ? 0 : rdM;
            MemtoRegW  <= clc ? 0 : MemtoRegM;
            ResultW    <= clc ? 0 : ResultM; 
            PCW        <= clc ? 0 : PCM;
            InsW       <= clc ? 0 : InsM;
        end
    end
    /*
    reg stall = 0;
    reg clear = 0;
    reg ResultOldData = 32'b0;
    always @(posedge clk) begin
        stall <= ~en;
        clear <= clc;
        ResultOldData <= ResultM;
    end
    assign ResultW = stall ? ResultOldData : (clear ? 32'b0 : ResultM); //有点问题
    */
endmodule
