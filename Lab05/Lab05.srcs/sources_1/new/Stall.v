`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/06 17:08:59
// Design Name: 
// Module Name: Stall
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


module Stall(
    input rst,
    input BranchE,
    input [31:0] PCE, ImmE,
    input [1:0] JumpD,
    input [1:0] JumpE,
    input [4:0] rs1D, rs2D, rs1E, rs2E, rdE, rdM, rdW,
    input [31:0] ResultM, DataWB, rs1_valE, rs2_valE,
    input [1:0] MemtoRegE,
    input ALUSrcE, rs1_used, rs2_used,
    input RegWriteM, RegWriteW,
    output reg [31:0] mem_w_data,
    output reg StallF, FlushF, StallD, FlushD, StallE, FlushE, StallM, FlushM, StallW, FlushW,
    output reg [31:0] op1, op2 //rs2_final
    );
    
    always @(*) begin
        if(rst) begin
            FlushF <= 1;
            FlushD <= 1;
            FlushE <= 1;
            FlushM <= 1;
            FlushW <= 1;
            
            StallF <= 0;
            StallD <= 0;
            StallE <= 0;
            StallM <= 0;
            StallW <= 0;
            
            op1 <= rs1_valE;
            op2 <= rs2_valE;
            mem_w_data <= rs2_valE;
        end
        else begin
            if(MemtoRegE == 2'b01 &&  (RegWriteW && rdE != 0 && ((rdE == rs1D) || (rdE == rs2D))) ) begin //RAW
                FlushF <= 0;
                FlushD <= 0;
                FlushE <= 1;
                FlushM <= 0;
                FlushW <= 0;
                
                StallF <= 1;
                StallD <= 1;
                StallE <= 0;
                StallM <= 0;
                StallW <= 0;                
            end
            else if(JumpE == 2'b01 || JumpE == 2'b10 || BranchE == 1) begin                      //jalr in EX
                FlushF <= 0;
                FlushD <= 1;
                FlushE <= 1;
                FlushM <= 0;
                FlushW <= 0;
                
                StallF <= 0;
                StallD <= 0;
                StallE <= 0;
                StallM <= 0;
                StallW <= 0;                
            end
            /*else if(JumpD == 2'b01) begin                                   //jal
                FlushF <= 0;
                FlushD <= 1;
                FlushE <= 0;
                FlushM <= 0;
                FlushW <= 0;
                
                StallF <= 0;
                StallD <= 0;
                StallE <= 0;
                StallM <= 0;
                StallW <= 0;
            end*/
            else begin
                FlushF <= 0;
                FlushD <= 0;
                FlushE <= 0;
                FlushM <= 0;
                FlushW <= 0;
                
                StallF <= 0;
                StallD <= 0;
                StallE <= 0;
                StallM <= 0;
                StallW <= 0;       
            end  
            //ALU的一号操作数
            if      (rdM && rdM == rs1E && RegWriteM /*&& rs1_used*/) op1 <= ResultM;
            else if (rdW && rdW == rs1E && RegWriteW /*&& rs1_used*/) op1 <= DataWB;
            else                                                      op1 <= rs1_valE;  
            
            //else op1 <= PCE - 4; //ALU 1号操作数来自PC, auipc指令
            
            //ALU的二号操作数    来自rs2/立即数
            if      (ALUSrcE)                                         op2 <= ImmE;       
            else if (rdM && rdM == rs2E && RegWriteM /*&& rs2_used*/) op2 <= ResultM;
            else if (rdW && rs2E == rdW && RegWriteW /*&& rs2_used*/) op2 <= DataWB;
            else                                                      op2 <= rs2_valE;  
            
            if (rdM && rdM == rs2E && RegWriteM /*&& rs2_used*/)       mem_w_data <= ResultM;
            else if (rdW && rs2E == rdW && RegWriteW /*&& rs2_used*/) mem_w_data <= DataWB;
            else                                                      mem_w_data <= rs2_valE;                   
        end
    end
endmodule
