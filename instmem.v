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
            = {`opcode_rtype, 5'd14, 5'd11, 5'd2, 5'd0, `func_add};

        for (i = 4; i < 256; i = i + 1) begin
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
