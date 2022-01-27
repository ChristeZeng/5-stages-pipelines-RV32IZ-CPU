`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/06 15:00:34
// Design Name: 
// Module Name: EX
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


module EX(
     input clk,
     input en,
     input clc,
     input [31:0] PCD,
     input [31:0] InsD,
     input [31:0] ImmD,
     input [4:0] rdD,
     input [4:0] rs1D,
     input [4:0] rs2D,
     input [31:0] rs1_valD,
     input [31:0] rs2_valD,
     input RegWriteD,
     input ALUSrcD,
     input BranchD,
     input [1:0] JumpD,
     input MemReadD,
     input MemWriteD,
     input [1:0] MemtoRegD,
     input [3:0] CtrlD,
     input luiD,
     input LoadD,
     
     output reg [31:0] PCE,
     output reg [31:0] InsE,
     output reg [31:0] ImmE,
     output reg [4:0] rdE,
     output reg [4:0] rs1E,
     output reg [4:0] rs2E,
     output reg [31:0] rs1_valE,
     output reg [31:0] rs2_valE,
     output reg RegWriteE,
     output reg ALUSrcE,
     output reg BranchE,
     output reg [1:0] JumpE,
     output reg MemReadE,
     output reg MemWriteE,
     output reg [1:0] MemtoRegE,
     output reg [3:0] CtrlE,
     output reg luiE,
     output reg LoadE
    );
    
    initial begin
        PCE = 32'b0;
        ImmE = 32'b0;
        rdE = 5'b0;
        rs1E = 5'b0;
        rs2E = 5'b0;
        rs1_valE = 32'b0;
        rs2_valE = 32'b0;
        RegWriteE = 0;
        ALUSrcE = 0;
        BranchE = 0;
        JumpE = 2'b0;
        MemReadE = 0;
        MemWriteE = 0;
        MemtoRegE = 2'b0;
        CtrlE = 4'b0;
        luiE = 0;
        LoadE = 0;
        InsE = 32'b0;
    end
    
    always @(posedge clk) begin
        if(en) begin
            if(clc) begin
                PCE = 32'b0;
                ImmE = 32'b0;
                rdE = 5'b0;
                rs1E = 5'b0;
                rs2E = 5'b0;
                rs1_valE = 32'b0;
                rs2_valE = 32'b0;
                RegWriteE = 0;
                ALUSrcE = 0;
                BranchE = 0;
                JumpE = 2'b0;
                MemReadE = 0;
                MemWriteE = 0;
                MemtoRegE = 2'b0;
                CtrlE = 4'b0;
                luiE = 0; 
                LoadE = 0;    
                InsE = 32'b0;           
            end
            else begin
                PCE = PCD;
                ImmE = ImmD;
                rdE = rdD;
                rs1E = rs1D;
                rs2E = rs2D;
                rs1_valE = rs1_valD;
                rs2_valE = rs2_valD;
                RegWriteE = RegWriteD;
                ALUSrcE = ALUSrcD;
                BranchE = BranchD;
                JumpE = JumpD;
                MemReadE = MemReadD;
                MemWriteE = MemWriteD;
                MemtoRegE = MemtoRegD;
                CtrlE = CtrlD;
                luiE = luiD; 
                LoadE = LoadD;   
                InsE = InsD;           
            end
        end
            
    end
endmodule
