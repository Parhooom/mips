`include "opfunc.v"
`timescale 1ns/1ns

module controller (
    clk,
    opcode,
    func,
    regdst,
    regwrite,
    alusrc,
    memread,
    memwrite,
    memtoreg,
    branch,
    jump,
    aluop
);
    
    input clk;
    input [5:0] opcode, func;
    output reg regdst, regwrite,
    alusrc, memread, memwrite,
    memtoreg, branch, jump;
    output reg [2:0] aluop = `aluop_add;

    initial begin
        regdst = 1'b0;
        regwrite = 1'b0;
        alusrc = 1'b0;
        memread = 1'b0;
        memwrite = 1'b0;
        memtoreg = 1'b0;
        branch = 1'b0;
        jump = 1'b0;
    end

    always @(posedge clk or func or opcode) begin
        case (opcode)
            `opcode_rtype: begin
                case (func)
                    `func_add: aluop = `aluop_add;
                    `func_sub: aluop = `aluop_sub;
                    `func_and: aluop = `aluop_and;
                    `func_or:  aluop = `aluop_or;
                    `func_slt: aluop = `aluop_slt;
                    default:   aluop = `aluop_add;
                endcase

                regdst <=    1'b1;
                regwrite <=  1'b1;
                alusrc <=    1'b0;
                memread <=   1'b0;
                memwrite <=  1'b0;
                memtoreg <=  1'b0;
                branch <=    1'b0;
                jump <=      1'b0;
            
            end
            `opcode_lw: begin
                regdst <=    1'b0;
                regwrite <=  1'b1;
                alusrc <=    1'b1;
                memread <=   1'b1;
                memwrite <=  1'b0;
                memtoreg <=  1'b1;
                branch <=    1'b0;
                jump <=      1'b0;
                aluop <=     `aluop_add;

            end
            `opcode_sw: begin
                regdst <=    1'b0;
                regwrite <=  1'b0;
                alusrc <=    1'b1;
                memread <=   1'b0;
                memwrite <=  1'b1;
                memtoreg <=  1'b0;
                branch <=    1'b0;
                jump <=      1'b0;
                aluop <=     `aluop_add;

            end
            `opcode_beq: begin
                regdst <=    1'b0;
                regwrite <=  1'b0;
                alusrc <=    1'b0;
                memread <=   1'b0;
                memwrite <=  1'b0;
                memtoreg <=  1'b0;
                branch <=    1'b1;
                jump <=      1'b0;
                aluop <=     `aluop_sub;

            end
            `opcode_j: begin
                regdst <=    1'b0;
                regwrite <=  1'b0;
                alusrc <=    1'b0;
                memread <=   1'b0;
                memwrite <=  1'b0;
                memtoreg <=  1'b0;
                branch <=    1'b0;
                jump <=      1'b1;
                aluop <=     `aluop_add; // dont care

            end
            default: begin 
                regdst <=    1'b0;
                regwrite <=  1'b0;
                alusrc <=    1'b0;
                memread <=   1'b0;
                memwrite <=  1'b0;
                memtoreg <=  1'b0;
                branch <=    1'b0;
                jump <=      1'b0;
                aluop <=     `aluop_add; // dont care 
            end
        endcase
    end

endmodule

module controller_test;

    reg clk;
    reg [5:0] opcode, func;
    wire regdst, regwrite,
    alusrc, memread, memwrite,
    memtoreg, branch, jump;
    wire [2:0] aluop;


    controller control(
        clk,
        opcode,
        func,
        regdst,
        regwrite,
        alusrc,
        memread,
        memwrite,
        memtoreg,
        branch,
        jump,
        aluop
    );

    initial begin
        clk = 1'b0;
    end

    always begin
        #5 clk = ~clk;
    end  

    initial begin
        #5;
        opcode = `opcode_rtype;
        func = `func_add;

        #10;
        opcode = `opcode_rtype;
        func = `func_sub;

        #10;
        opcode = `opcode_rtype;
        func = `func_and;

        #10;
        opcode = `opcode_rtype;
        func = `func_or;

        #10; 
        opcode = `opcode_rtype;
        func = `func_slt;

        #10;
        opcode = `opcode_lw;

        #10;
        opcode = `opcode_sw;

        #10;
        opcode = `opcode_beq;

        #10;
        opcode = `opcode_j;
    end

endmodule
