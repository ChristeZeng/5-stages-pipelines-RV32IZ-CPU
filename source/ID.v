`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/06 14:40:06
// Design Name: 
// Module Name: ID
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


module ID(
    input clk,
    input clc,
    input en,
    input [31:0] PCF,
    input [31:0] IMem_o_data,
    output reg [31:0] PCD,
    output reg [31:0] IMemData
    );
    initial begin
        PCD      = 0;
        IMemData = 0;
    end
    
    always@(posedge clk) begin
        if(en) begin
            PCD      <= clc ? 0 : PCF;
            IMemData <= clc ? 0 : IMem_o_data;
        end
    end
    
/*    
    reg stall = 1'b0;
    reg clear = 1'b0;
    reg [31:0] IMemOldData = 32'b0;
    
    always@(posedge clk) begin
        stall <= ~en;
        clear <= clc;
        IMemOldData <= IMem_o_data; 
    end 
    assign IMemData = stall ? IMemOldData : (clear ? 32'b0 : IMem_o_data);
*/  
endmodule
