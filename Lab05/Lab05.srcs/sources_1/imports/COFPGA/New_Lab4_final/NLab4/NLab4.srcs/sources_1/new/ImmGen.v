`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/30 15:09:44
// Design Name: 
// Module Name: ImmGen
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
module ImmGen(
    input wire [31:0] Ins,
    output reg [31:0] Imm
    );
    
    always @(*) begin
	   case (Ins[6:0])
		  7'b0010011: Imm = { {21{Ins[31]}}, Ins[30:25], Ins[24:21], Ins[20] };   //arith_I type: addi, slti, sltiu, xori, ori, andi
		  7'b0100011: Imm = { {21{Ins[31]}}, Ins[30:25], Ins[11:8], Ins[7] };     //store
		  7'b0110111: Imm = { Ins[31], Ins[30:20], Ins[19:12], 12'b0 };           //lui
		  7'b0010111: Imm = { Ins[31], Ins[30:20], Ins[19:12], 12'b0 };           //auipc
		  7'b1101111: Imm = { {12{Ins[31]}}, Ins[19:12], Ins[20], Ins[30:25], Ins[24:21], 1'b0 }; //jal
		  7'b1100111: Imm = { {21{Ins[31]}}, Ins[30:25], Ins[24:21], Ins[20] };   //jalr
		  7'b1100011: Imm = { {20{Ins[31]}}, Ins[7], Ins[30:25], Ins[11:8], 1'b0}; //branch
		  default: 	  Imm = { {21{Ins[31]}}, Ins[30:25], Ins[24:21], Ins[20] }; // IMM_I
	   endcase 
    end
endmodule
