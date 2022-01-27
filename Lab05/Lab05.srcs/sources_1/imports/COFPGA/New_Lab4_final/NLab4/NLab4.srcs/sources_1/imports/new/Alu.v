`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/28 15:07:38
// Design Name: 
// Module Name: Alu
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
module Alu(
    input [31:0] a_val,
    input [31:0] b_val,
    input [3:0] ctrl,
    output reg [31:0] result
    );
    always @(a_val or b_val or ctrl) begin
        case(ctrl)
            4'd0: result <= a_val + b_val;
            4'd1: result <= a_val - b_val;
            4'd2: result <= (a_val << b_val);
            4'd3: result <= ($signed(a_val) < $signed(b_val)) ? 1 : 0; //LT
            4'd4: result <= (a_val < b_val) ? 1 : 0; //LTU
            4'd5: result <= a_val ^ b_val;
            4'd6: result <= (a_val >> b_val);
            4'd7: result <= (($signed(a_val)) >>> b_val[4:0]); //
            4'd8: result <= a_val | b_val;
            4'd9: result <= a_val & b_val;
            default: result <= a_val + b_val;
        endcase
    end
endmodule
