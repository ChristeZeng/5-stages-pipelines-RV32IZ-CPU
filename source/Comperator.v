`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/28 15:08:45
// Design Name: 
// Module Name: Comperator
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
module Comperator(
    input [31:0] a_val,
    input [31:0] b_val,
    input [2:0] ctrl,
    output reg result
    );
    always @(a_val or b_val or ctrl) begin
        case(ctrl)
            3'd0: result = (a_val == b_val) ? 1 : 0;
            3'd1: result = (a_val == b_val) ? 0 : 1; 
            3'd4: result = ($signed(a_val) < $signed(b_val)) ? 1 : 0;
            3'd5: result = ($signed(a_val) >= $signed(b_val) ) ? 1 : 0;
            3'd6: result = (a_val < b_val) ? 1 : 0;
            3'd7: result = (a_val >= b_val) ? 1 : 0;
            default: result = 0;
        endcase
     end
endmodule
