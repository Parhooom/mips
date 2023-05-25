`define opcode_rtype 6'h0

`define func_add 6'h20
`define func_sub 6'h22
`define func_and 6'h24
`define func_or 6'h25
`define func_slt 6'h2A

`define opcode_lw 6'h23
`define opcode_sw 6'h2B
`define opcode_beq 6'h04
`define opcode_j 6'h02
`define opcode_addi 6'h08

`define aluop_add 3'b010
`define aluop_sub 3'b110
`define aluop_and 3'b000
`define aluop_or 3'b001
`define aluop_slt 3'b111