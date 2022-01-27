`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/30 15:09:03
// Design Name: 
// Module Name: PC
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
module PC(
    input [31:0] PC, PCD, PCE,
    input rst,
    input [1:0] JumpE,
    //input [1:0] JumpD,
    input Branch,
    input [31:0] ImmE,
    //input [31:0] ImmD,
    input Zero,               
    input [31:0] ALU_result,
    input [31:0] JalTarge, JalrTarge,
    output reg [31:0] nextpc
    );
    wire [31:0] PCplus4, BranchTarge;
    wire BrandAND;
    //assign JalTarge    = PCE + ALU_result;            //jal  address
    //assign JalrTarge   = ALU_result;   //jalr address 
    assign BranchTarge = PCE + ImmE;
    assign PCplus4     = PC  + 32'd4;         //PCF + 4         
    
    assign BranchAND = Branch & Zero;  
    
    always @(*) begin
        if(rst == 1) nextpc <= 0;
        else begin
            if(BranchAND)            nextpc <= BranchTarge;  //branch   
            else if(JumpE == 2'b01) nextpc <= JalTarge;     //jal 
            else if(JumpE == 2'b10) nextpc <= JalrTarge;    //auipc and jalr
            else                     nextpc <= PCplus4;      //PC+4
        end
    end
endmodule