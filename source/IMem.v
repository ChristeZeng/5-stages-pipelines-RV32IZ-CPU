`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/28 16:21:53
// Design Name: 
// Module Name: Imem
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


module IMem(
    input [31:0] addr,
    output reg [31:0] data
    );

    (* ram_style = "block" *) reg [31:0] mem [0:4095];
    initial $readmemh("imem_data.mem", mem);

    always @(*) begin
        data <= mem[addr>>2];
    end    
    
endmodule
