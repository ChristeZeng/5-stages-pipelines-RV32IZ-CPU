`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/30 15:08:05
// Design Name: 
// Module Name: Core
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
`include "Defines.vh" 

module Core(
    `VGA_DBG_Core_Outputs
    input clk, rst,
    input [31:0] imem_o_data,
    input [31:0] dmem_o_data,
    output [31:0] imem_addr,
    output dmem_wen,
    output [31:0] dmem_addr,
    output [31:0] dmem_i_data
    );
    
    wire MemRead, MemReadE;                //û���õ�?
    wire [1:0] MemtoReg, MemtoRegE, MemtoRegM, MemtoRegW;      
    wire ZeroE;               
    wire [1:0] ALUOp;
    wire MemWrite, MemWriteE, MemWriteM, MemWriteW;
    wire [31:0] Op1, Op2;
    wire Branch, BranchE;
    wire [1:0] Jump, JumpE;

    wire [3:0] CtrlD, CtrlE;
    wire [31:0] imm, ImmE, ImmM, ImmW;
    wire Load, LoadE, LoadM, LoadW;
    wire rs1_used, rs2_used;
    wire [1:0] rsuse;
    wire [4:0] rs1D, rs2D, rd, rs1E, rs2E, rdE, rs1M, rs2M, rdM, rdW;
    wire [31:0] rs1_valD, rs2_valD, rs1_valE, rs2_valE, rs2_valM;
    wire [31:0] ALUOutE, ALUOutM;
    wire [31:0] PCF, PCE, PCD, PCM, PCW, PC_In;
    wire [31:0] Ins, InsE, InsM, InsW;
    wire StallF, FlushF, FlushD, StallD, FlushE, StallE, FlushM, StallM, FlushW, StallW;
    reg [31:0] ResultE, ResultM;
    wire lui, luiE, luiM;
    wire [31:0] ResultW; //DataMemд�������
    wire RegWrite, RegWriteE, RegWriteM, RegWriteW;
    wire ALUSrc, ALUSrcE;
    wire [31:0] mem_w_data, mem_w_dataM;
    wire [31:0] JalTarge, JalrTarge;
//*****************IF����************************    
    //������һ��ָ���PCֵ��ģ�飬��ͨ
    PC pc(
        .PC(PCF),                    //IF�׶ε�PCֵ   
        .PCD(PCD),
        .PCE(PCE),    
        .rst(rst),                   //����
        .JumpE(JumpE),               //jalrָ����ת��־ EX�׶�
        //.JumpD(JumpD),               //jalָ����ת��־  ID�׶�
        .Branch(BranchE),            //Branch��ת��־   EX�׶�
        .ImmE(ImmE),                 //Branch��ת��PCE + ImmE 
        //.ImmD(imm),                  //Jal��ת��   PCD + ImmD
        .Zero(ZeroE),                //Branch�Ƿ�Ҫ��ת�ı�Ҫ����֮һ
        .ALU_result(ALUOutE),        //Jalr��ת��  PCE + ALUOutE 
        .nextpc(PC_In),              //�����ڵ���һ��ָ���PC��ַ
        .JalTarge(JalTarge),
        .JalrTarge(JalrTarge)
        );   
        
     IF IF_ID1(
        .clk(clk),
        .en(~StallF),        
        .clc(FlushF),
        .PC_In(PC_In),               //��һ��Ԥ����д���PC��ַ
        .PCF(PCF)                    //�����ڵ�PC��ַ
        ); 
    
    assign imem_addr = PCF;         //��IMem��ȡ��ָ�� 
   
//*****************ID����************************    
    ID IF_ID2(
        .clk(clk),
        .clc(FlushD),
        .en(~StallD),
        .PCF(PCF),                  
        .IMem_o_data(imem_o_data), //IF�׶ζ�ȡ����ԭʼָ��
        .IMemData(Ins),            //����ѡ����ָ��
        .PCD(PCD)                  //��PCF���浽IDģ��
    );
    
    ImmGen(.Ins(Ins), .Imm(imm));  //�����immΪImmD(ID�׶ε�ָ�����ɵ�������)     
    
    //���ɵľ���ID�׶εĿ���ָ��
    Control_Unit con(
        .OpCode(Ins[6:0]), 
        .RegWrite(RegWrite), 
        .ALUSrc(ALUSrc), 
        .Branch(Branch),
        .Jump(Jump),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .ALUOp(ALUOp),
        .lui(lui),
        .rsuse(rsuse)
        );
    
    ALUControl ALUcon(
        .ALUOp(ALUOp),
        .Funct7(Ins[30]),
        .Funct3(Ins[14:12]),
        .ctrl(CtrlD)
    );
    
    assign rs1D = Ins[19:15];
    assign rs2D = Ins[24:20];
    assign rd   = Ins[11:7];
    
    RegFile regfile(
        `VGA_DBG_RegFile_Arguments
        .clk(~clk),                //�½���д��double bump
        .rst(rst),
        .wen(RegWriteW),           //WB�׶ε�����
        .rs1(Ins[19:15]),
        .rs2(Ins[24:20]),
        .rd(rdW),                 //WB�׶β��ܾ���������
        .i_data(ResultW),         //WB�׶εķ�������
        .rs1_val(rs1_valD),
        .rs2_val(rs2_valD)
    );
    
//*****************EX-ALU Moduel****************************      
    EX ex(
        .clk(clk),
        .en(~StallE),
        .clc(FlushE),
        .PCD(PCD),
        .InsD(Ins),
        .ImmD(imm),
        .rdD(rd),
        .rs1D(rs1D),
        .rs2D(rs2D),
        .rs1_valD(rs1_valD),
        .rs2_valD(rs2_valD),
        .RegWriteD(RegWrite),
        .ALUSrcD(ALUSrc),
        .BranchD(Branch),
        .JumpD(Jump),
        .MemReadD(MemRead),
        .MemWriteD(MemWrite),
        .MemtoRegD(MemtoReg),
        .CtrlD(CtrlD),
        .luiD(lui),
        .LoadD(Load),
        
        .PCE(PCE),
        .InsE(InsE),
        .ImmE(ImmE),
        .rdE(rdE),
        .rs1E(rs1E),
        .rs2E(rs2E),
        .rs1_valE(rs1_valE),
        .rs2_valE(rs2_valE),
        .RegWriteE(RegWriteE),
        .ALUSrcE(ALUSrcE),
        .BranchE(BranchE),
        .JumpE(JumpE),
        .MemReadE(MemReadE),
        .MemWriteE(MemWriteE),
        .MemtoRegE(MemtoRegE),
        .CtrlE(CtrlE),
        .luiE(luiE),
        .LoadE(LoadE)
    );
    Alu ALU1(
        .a_val(PCE),
        .b_val(ImmE),
        .ctrl(0),
        .result(JalTarge)
    );
    
    Alu ALU(
        .a_val(Op1),      //ALU��1�Ų�����: 1.ǰ�͵�MEM�׶�ALU������ 2.����Load�׶�ǰ�͵Ľ�ҪWB���ڴ�ֵ(�Ѽ�bubble) 3.����EX�׶ε�rs1_valD
        .b_val(Op2),      //ALU��2�Ų�����: 2.ǰ�͵�MEM�׶�ALU������ 2.����Load�׶�ǰ�͵Ľ�ҪWB���ڴ�ֵ(�Ѽ�bubble) 3.����EX�׶ε�rs2_valD 4.ImmE
        .ctrl(CtrlE),     //��������
        .result(ALUOutE)  //ALU������
    );
    assign JalrTarge = ImmE + rs1_valE;
    //�ж�Branch�Ƿ���������������ZeroE
    Comperator cmp(
        .a_val(Op1), 
        .b_val(Op2),
        .ctrl(InsE[14:12]),
        .result(ZeroE)
    );
    
//*************MEM STAGE**********************************   
    MEM Mem(
        .clk(clk),
        .en(~StallM),
        .clc(FlushM),
        .PCE(PCE),
        .ALUOutE(ALUOutE),
        .ImmE(ImmE),
        .rdE(rdE),
        .RegWriteE(RegWriteE),
        .MemWriteE(MemWriteE),
        .MemtoRegE(MemtoRegE),
        .luiE(luiE),
        .InsE(InsE),
        .rs2_valE(rs2_valE),
        .mem_w_data(mem_w_data),
        
        .PCM(PCM),
        .ALUOutM(ALUOutM),
        .ImmM(ImmM),
        .rdM(rdM),
        .RegWriteM(RegWriteM),
        .MemWriteM(MemWriteM),
        .MemtoRegM(MemtoRegM),
        .luiM(luiM),
        .InsM(InsM),
        .rs2_valM(rs2_valM),
        .mem_w_dataM(mem_w_dataM)
    );

    always @(*) begin
        if(luiM == 1)                ResultM <= ImmM;                  //lui
        else if(MemtoRegM == 2'b00) ResultM <= ALUOutM;               //ALU���
        else if(MemtoRegM == 2'b01) ResultM <= dmem_o_data;           //Load�е�����
        else if(MemtoRegM == 2'b10) ResultM <= PCM + 4;               //jal jalr
        else                         ResultM <= PCM;               //auipc 
    end 
    
    assign dmem_wen    = MemWriteM;    //д��ʹ��
    assign dmem_i_data = mem_w_dataM;     //Store Data
    assign dmem_addr   = ALUOutM;      //��ȡ��д���ַ����ALUOutM
//*************WB-DMem Module*****************************
    WB(
        .clk(clk),
        .en(~StallW),
        .clc(FlushW),
        .ResultM(ResultM),
        .rdM(rdM),
        .RegWriteM(RegWriteM),
        .MemtoRegM(MemtoRegM),
        .PCM(PCM),
        .InsM(InsM),
        
        .ResultW(ResultW),
        .rdW(rdW),
        .RegWriteW(RegWriteW),
        .MemtoRegW(MemtoRegW),
        .PCW(PCW),
        .InsW(InsW)
    );
    
    
//*************STALL Module********************************
    assign rs1_use = rsuse[0];
    assign rs2_use = rsuse[1];
    Stall stall(
        .rst(rst),
        .BranchE(BranchE & ZeroE),
        .JumpD(JumpD),
        .JumpE(JumpE),
        .rs1D(rs1D),
        .rs2D(rs2D),
        .rs1E(rs1E),
        .rs2E(rs2E),
        .rdE(rdE),
        .rdM(rdM),
        .rdW(rdW),
        .MemtoRegE(MemtoRegE),
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        .StallF(StallF),
        .StallD(StallD),
        .StallE(StallE),
        .StallM(StallM),
        .StallW(StallW),
        .FlushF(FlushF),
        .FlushD(FlushD),
        .FlushE(FlushE),
        .FlushM(FlushM),
        .FlushW(FlushW),
        
        .PCE(PCE),
        .ImmE(ImmE),
        .ResultM(ResultM),
        .rs1_valE(rs1_valE),
        .rs2_valE(rs2_valE),
        .DataWB(ResultW),
        .ALUSrcE(ALUSrcE),
        .rs1_used(rs1_used),
        .rs2_used(rs2_used),
        .op1(Op1),
        .op2(Op2),
        .mem_w_data(mem_w_data)
    );
    
//*************Assignment*********************************
    `VGA_DBG_Core_Assignments
endmodule