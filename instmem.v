`include "opfunc.v"
`timescale 1ns/1ns

module instmem (
    read_addr,
    instruction
);
    
    input [31:0] read_addr;
    output reg [31:0] instruction;

    reg [7:0] inst_data [0:255];

    integer i;

    initial begin
        {inst_data[0], inst_data[1], inst_data[2], inst_data[3]}
            = {`opcode_lw, 5'd0, 5'd3, 16'd0};
            // lw $3, 0($0)  suppose the n in
            //  sum(n) is stored in the first
            //  word of the data memory
        
        {inst_data[4], inst_data[5], inst_data[6], inst_data[7]}
            = {`opcode_addi, 5'd3, 5'd3, 16'd1};
            // addi $3, $3, 1

        {inst_data[8], inst_data[9], inst_data[10], inst_data[11]}
            = {`opcode_addi, 5'd0, 5'd2, 16'd1};
            // addi $2, $0, 1
        
        {inst_data[12], inst_data[13], inst_data[14], inst_data[15]}
            = {`opcode_rtype, 5'd0, 5'd0, 5'd1, 5'd0, `func_add};
            // add $1, $0, $0

        // Loop:
        {inst_data[16], inst_data[17], inst_data[18], inst_data[19]}
            = {`opcode_beq, 5'd2, 5'd3, 16'd3};
            // beq $2, $3, Exit

        {inst_data[20], inst_data[21], inst_data[22], inst_data[23]}
            = {`opcode_rtype, 5'd1, 5'd2, 5'd1, 5'd0, `func_add};
            // add $1, $1, $2

        {inst_data[24], inst_data[25], inst_data[26], inst_data[27]}
            = {`opcode_addi, 5'd2, 5'd2, 16'd1};
            // addi $2, $2, 1
        
        {inst_data[28], inst_data[29], inst_data[30], inst_data[31]}
            = {`opcode_j, 26'd4};
            // j Loop

        // Exit:
        {inst_data[32], inst_data[33], inst_data[34], inst_data[35]}
            = {`opcode_sw, 5'd0, 5'd1, 16'd4};
            // sw $1, 4($0)

        {inst_data[36], inst_data[37], inst_data[38], inst_data[39]}
            = {`opcode_j, 26'd0};
            // j Program
        
        for (i = 40; i < 256; i = i + 1) begin
            inst_data[i] = 8'd0;
        end
    end
    
    always @(read_addr) begin
        if ((read_addr & 32'b11) == 0 && read_addr < 256) begin
            instruction = {inst_data[read_addr], inst_data[read_addr + 1],
             inst_data[read_addr + 2], inst_data[read_addr + 3]};
        end else begin
            instruction = 32'd0;
            $display("error in inst mem. time: %t", $time);
        end    
    end

endmodule
