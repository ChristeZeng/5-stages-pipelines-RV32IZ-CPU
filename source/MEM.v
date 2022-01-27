`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/06 16:01:27
// Design Name: 
// Module Name: MEM
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


module MEM(
    input clk,
    input en,
    input clc,
    //load     
    input [31:0] PCE,
    input [31:0] ALUOutE,
    input [31:0] ImmE,
    input [4:0] rdE,
    input RegWriteE,
    input MemWriteE,
    input [1:0] MemtoRegE,
    input [31:0] InsE,
    input luiE,
    input [31:0] rs2_valE,
    input [31:0] mem_w_data,
    
    output reg [31:0] PCM,
    output reg [31:0] ALUOutM,
    output reg [31:0] ImmM,
    output reg [4:0] rdM,
    output reg RegWriteM,
    output reg MemWriteM,
    output reg [1:0] MemtoRegM,
    output reg [31:0] InsM,
    output reg luiM,
    output reg [31:0] rs2_valM,
    output reg [31:0] mem_w_dataM
    );
    
    initial begin
        PCM       = 0;
        ALUOutM   = 0;
        ImmM      = 0;
        rdM       = 0;
        RegWriteM = 0;
        MemWriteM = 0;
        MemtoRegM = 0;
        luiM      = 0;
        InsM      = 0;
        rs2_valM  = 0;
        mem_w_dataM = 0;
    end
    
    always @(posedge clk) begin
        if(en) begin
            PCM       <= clc ? 0 : PCE;
            ALUOutM   <= clc ? 0 : ALUOutE;
            ImmM      <= clc ? 0 : ImmE;
            rdM       <= clc ? 0 : rdE;
            RegWriteM <= clc ? 0 : RegWriteE;
            MemWriteM <= clc ? 0 : MemWriteE;
            MemtoRegM <= clc ? 0 : MemtoRegE;  
            luiM      <= clc ? 0 : luiE;  
            InsM      <= clc ? 0 : InsE;  
            rs2_valM  <= clc ? 0 : rs2_valE;   
            mem_w_dataM <= clc ? 0 : mem_w_data;
        end
    
    end
endmodule
