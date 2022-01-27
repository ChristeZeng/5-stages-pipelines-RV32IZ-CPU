`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/30 15:06:52
// Design Name: 
// Module Name: Top
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
module Top(
    input clk_100mhz,
    input rstn,
    input [15:0] sw_in,
    input [4:0] key_col,
    output [4:0] key_row,
    output hs, vs,
    output [3:0] vga_r, vga_g, vga_b 
    );
    wire [4:0] key_x, key_y;
    wire [15:0] sw;
    wire [31:0] clk_div;
    wire  rst, clk_cpu;
    
    wire [31:0] imem_o_data;
    wire [31:0] dmem_o_data;
    wire [31:0] imem_addr;
    wire dmem_wen;
    wire [31:0] dmem_addr;
    wire [31:0] dmem_i_data;
    
    ClockDividor clock_dividor(
        .clk(clk_100mhz), 
        .rst(rst), 
        .step_en(sw[0]), 
        .clk_step(key_x[0]), 
        .clk_div(clk_div), 
        .clk_cpu(clk_cpu)
        );
        
    InputAntiJitter inputter(
        .clk(clk_100mhz), 
        .rstn(rstn), 
        .key_col(key_col), 
        .sw_in(sw_in), 
        .rst(rst), 
        .key_row(key_row), 
        .key_x(key_x), 
        .key_y(key_y), 
        .sw(sw)
        );
    `VGA_DBG_Core_Declaration  //µ÷ÊÔ²ÎÊý
    `VGA_DBG_RegFile_Declaration
    Core core(
        `VGA_DBG_Core_Arguments
         .clk(clk_cpu), 
         .rst(rst), 
         .imem_o_data(imem_o_data), 
         .dmem_o_data(dmem_o_data), 
         .imem_addr(imem_addr), 
         .dmem_wen(dmem_wen), 
         .dmem_addr(dmem_addr), 
         .dmem_i_data(dmem_i_data)
    );
    
    IMem i_mem(
        .addr(imem_addr), 
        .data(imem_o_data)
        );
        
    DMem d_men(
        .clk(~clk_cpu), 
        .wen(dmem_wen), 
        .addr(dmem_addr), 
        .i_data(dmem_i_data), 
        .o_data(dmem_o_data)
        );
        
    VGA vga(
        `VGA_DBG_VgaDebugger_Arguments
        .rst(rst), 
        .clk_div(clk_div), 
        .hs(hs), 
        .vs(vs), 
        .vga_r(vga_r), 
        .vga_g(vga_g), 
        .vga_b(vga_b)
    );
endmodule