`include "opfunc.v"
`timescale 1ns/1ns

module alu (
    A,
    B,
    result,
    aluop,
    zero_flag,
);
    
    input signed [31:0] A, B;
    input [2:0] aluop;
    output reg signed [31:0] result;
    output reg zero_flag;

    always @(A or B or aluop) begin
        case (aluop)
            `aluop_add:    result = A + B;
            `aluop_sub:    result = A - B;
            `aluop_and:    result = A & B;
            `aluop_or:     result = A | B;
            `aluop_slt:    result = A < B; 
            default:       result = 32'd0;
        endcase
        
        zero_flag = (result == 0);
    end

endmodule