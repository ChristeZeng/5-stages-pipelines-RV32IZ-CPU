`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/28 16:23:47
// Design Name: 
// Module Name: DMem
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


module DMem(
    input clk,
    input wen,
    input [31:0] addr,
    input [31:0] i_data,
    output reg [31:0] o_data
    );
    
    (* ram_style = "block" *) reg [31:0] mem [0:4095];
    initial $readmemh("dmem_data.mem", mem);

    always @(*) begin
        o_data <= mem[addr];
    end   
    
    always @(posedge clk) begin
        if(wen == 1)
            mem[addr] <= i_data;
    end
    
endmodule
