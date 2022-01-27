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
    
    wire MemRead, MemReadE;                //没有用到?
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
    wire [31:0] ResultW; //DataMem写入的数据
    wire RegWrite, RegWriteE, RegWriteM, RegWriteW;
    wire ALUSrc, ALUSrcE;
    wire [31:0] mem_w_data, mem_w_dataM;
    wire [31:0] JalTarge, JalrTarge;
//*****************IF部分************************    
    //计算下一条指令的PC值的模块，常通
    PC pc(
        .PC(PCF),                    //IF阶段的PC值   
        .PCD(PCD),
        .PCE(PCE),    
        .rst(rst),                   //清零
        .JumpE(JumpE),               //jalr指令跳转标志 EX阶段
        //.JumpD(JumpD),               //jal指令跳转标志  ID阶段
        .Branch(BranchE),            //Branch跳转标志   EX阶段
        .ImmE(ImmE),                 //Branch跳转到PCE + ImmE 
        //.ImmD(imm),                  //Jal跳转到   PCD + ImmD
        .Zero(ZeroE),                //Branch是否要跳转的必要条件之一
        .ALU_result(ALUOutE),        //Jalr跳转到  PCE + ALUOutE 
        .nextpc(PC_In),              //此周期的下一条指令的PC地址
        .JalTarge(JalTarge),
        .JalrTarge(JalrTarge)
        );   
        
     IF IF_ID1(
        .clk(clk),
        .en(~StallF),        
        .clc(FlushF),
        .PC_In(PC_In),               //下一条预备好写入的PC地址
        .PCF(PCF)                    //此周期的PC地址
        ); 
    
    assign imem_addr = PCF;         //从IMem中取得指令 
   
//*****************ID部分************************    
    ID IF_ID2(
        .clk(clk),
        .clc(FlushD),
        .en(~StallD),
        .PCF(PCF),                  
        .IMem_o_data(imem_o_data), //IF阶段读取到的原始指令
        .IMemData(Ins),            //经过选择后的指令
        .PCD(PCD)                  //将PCF保存到ID模块
    );
    
    ImmGen(.Ins(Ins), .Imm(imm));  //这里的imm为ImmD(ID阶段的指令生成的立即数)     
    
    //生成的均是ID阶段的控制指令
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
        .clk(~clk),                //下降沿写入double bump
        .rst(rst),
        .wen(RegWriteW),           //WB阶段的数据
        .rs1(Ins[19:15]),
        .rs2(Ins[24:20]),
        .rd(rdW),                 //WB阶段才能决定的数据
        .i_data(ResultW),         //WB阶段的返回数据
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
        .a_val(Op1),      //ALU的1号操作数: 1.前送的MEM阶段ALU计算结果 2.来自Load阶段前送的将要WB的内存值(已加bubble) 3.来自EX阶段的rs1_valD
        .b_val(Op2),      //ALU的2号操作数: 2.前送的MEM阶段ALU计算结果 2.来自Load阶段前送的将要WB的内存值(已加bubble) 3.来自EX阶段的rs2_valD 4.ImmE
        .ctrl(CtrlE),     //操作类型
        .result(ALUOutE)  //ALU计算结果
    );
    assign JalrTarge = ImmE + rs1_valE;
    //判断Branch是否满足条件，返回ZeroE
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
        else if(MemtoRegM == 2'b00) ResultM <= ALUOutM;               //ALU结果
        else if(MemtoRegM == 2'b01) ResultM <= dmem_o_data;           //Load有点问题
        else if(MemtoRegM == 2'b10) ResultM <= PCM + 4;               //jal jalr
        else                         ResultM <= PCM;               //auipc 
    end 
    
    assign dmem_wen    = MemWriteM;    //写入使能
    assign dmem_i_data = mem_w_dataM;     //Store Data
    assign dmem_addr   = ALUOutM;      //读取与写入地址均是ALUOutM
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