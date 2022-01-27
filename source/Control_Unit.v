`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/28 17:15:36
// Design Name: 
// Module Name: Control_Unit
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


module Control_Unit(
    input [6:0] OpCode,
    output reg RegWrite,
    output reg ALUSrc,
    output reg Branch,
    output reg [1:0] Jump,
    output reg MemRead,
    output reg MemWrite,
    output reg [1:0] MemtoReg,
    output reg [1:0] ALUOp,
    output reg lui,
    output reg [1:0] rsuse
    );
    initial rsuse = 2'b00;
    
     always @ (*) begin
        if(OpCode == 7'b0110011) begin // Type R - AND, OR, SUB, ADD
            ALUSrc <= 0;
            MemtoReg <= 2'b00;
            RegWrite <= 1;
            MemRead <= 0;
            MemWrite <= 0;
            Branch <= 0;
            Jump <= 2'b00;
            ALUOp <= 2'b10;
            lui <= 0;
            rsuse <= 2'b11;
        end
        else if(OpCode == 7'b0000011) begin // Type Load - LW
            ALUSrc <= 1;
            MemtoReg <= 2'b01;
            RegWrite <= 1;
            MemRead <= 1;
            MemWrite <= 0;
            Branch <= 0;
            Jump <= 2'b00;
            ALUOp <= 2'b00;
            lui <= 0;
            rsuse <= 2'b10;
        end
        else if(OpCode == 7'b0100011) begin // Type Store - SW
            ALUSrc <= 1;
            MemtoReg <= 2'b00;                  // don't care
            RegWrite <= 0;
            MemRead <= 0;
            MemWrite <= 1;
            Branch <= 0;
            Jump <= 2'b00;
            ALUOp <= 2'b00;
            lui <= 0;
        end
        else if(OpCode == 7'b1100011) begin // Type Branch
            ALUSrc <= 0;
            MemtoReg <= 2'b00;                  // don't care
            RegWrite <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            Branch <= 1;
            Jump <= 2'b00;
            ALUOp <= 2'b01;
            lui <= 0;
        end
        else if(OpCode == 7'b0010011) begin //andi ori ...
            ALUSrc <= 1;               //ï¿½ï¿½Òªï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
            MemtoReg <= 2'b00;
            RegWrite <= 1;
            MemRead <= 0;
            MemWrite <= 0; //ÐÞ¸Ä
            Branch <= 0;
            Jump <= 2'b00;
            ALUOp <= 2'b11;    
            lui <= 0;    
            rsuse = 2'b01; 
        end
        else if(OpCode == 7'b1101111) begin  //Jump jal
            ALUSrc <= 0;                  //don't care
            MemtoReg <= 2'b10;
            RegWrite <= 1;
            MemRead <= 0;
            MemWrite <= 0;
            Branch <= 0;
            Jump <= 2'b01;
            ALUOp <= 2'b00;             //ï¿½ï¿½È·ï¿½ï¿½ 
            lui <= 0;
        end
        else if(OpCode == 7'b1100111) begin //jalr
            ALUSrc <= 1;
            MemtoReg <= 2'b10;
            RegWrite <= 1;
            MemRead <= 0;
            MemWrite <= 0;
            Branch <= 0;
            Jump <= 2'b10;
            ALUOp <= 2'b00;
            lui <= 0;
        end
        else if(OpCode == 7'b0010111) begin //auipc
            ALUSrc <= 1;                      //ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
            MemtoReg <= 2'b11; 
            RegWrite <= 1;
            MemRead <= 0;
            MemWrite <= 0;
            Branch <= 0;
            Jump <= 2'b00;
            ALUOp <= 2'b00;
            lui <= 0;
        end
        else if(OpCode == 7'b0110111) begin //lui
            ALUSrc <= 1;
            MemtoReg <= 2'b00; //
            RegWrite <= 1;
            MemRead <= 0;
            MemWrite <= 0;
            Branch <= 0;
            Jump <= 0;
            ALUOp <= 2'b00; // 
            lui <= 1;
        end
    end
endmodule
