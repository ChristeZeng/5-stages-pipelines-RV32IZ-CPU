`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/29 09:25:08
// Design Name: 
// Module Name: ALUControl
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


module ALUControl(
    input [1:0] ALUOp,
    input Funct7,         //actually only onr bit of Funct7 makes sense
    input [2:0] Funct3,
    output reg [3:0] ctrl 
    );
    
    always @(*) begin
    case(ALUOp)
        2'b00: ctrl <= 4'b0000;  //lw or sw : add
        2'b01: ctrl <= 4'b0001;  //branch : sub
        2'b10:                  //R-type
        begin
            if(Funct7 == 1)  begin
                if(Funct3 == 3'b101) ctrl <= 4'b0111;    //sra
                else ctrl <= 4'b0001;                    //sub
            end
            else if(Funct3 == 3'b000) ctrl <= 4'b0000;  //add
            else if(Funct3 == 3'b111) ctrl <= 4'b1001;  //and
            else if(Funct3 == 3'b110) ctrl <= 4'b1000;  //or
            else if(Funct3 == 3'b010) ctrl <= 4'b0011;  //slt 
            else if(Funct3 == 3'b001) ctrl <= 4'b0010;  //sll
            else if(Funct3 == 3'b011) ctrl <= 4'b0100;  //sltu
            else if(Funct3 == 3'b100) ctrl <= 4'b0101;  //xor
            else /*if(Funct3 == 3'b101)*/ ctrl <= 4'b0110;  //srl
        end
        2'b11:
        begin
            if(Funct3 == 3'b101) begin
                if(Funct7 == 1)  ctrl <= 4'b0111;    //srai
                else             ctrl <= 4'b0110;    //srli
            end
            else if(Funct3 == 3'b000) ctrl <= 4'b0000;  //addi
            else if(Funct3 == 3'b111) ctrl <= 4'b1001;  //andi
            else if(Funct3 == 3'b110) ctrl <= 4'b1000;  //ori
            else if(Funct3 == 3'b010) ctrl <= 4'b0011;  //slti 
            else if(Funct3 == 3'b001) ctrl <= 4'b0010;  //slli
            else if(Funct3 == 3'b011) ctrl <= 4'b0100;  //sltiu
            else /*if(Funct3 == 3'b100)*/ ctrl <= 4'b0101;  //xori
        end
    endcase    
    end
endmodule
