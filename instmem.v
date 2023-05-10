module instmem (
    read_addr,
    instruction
);
    
    input [31:0] read_addr;
    output reg [31:0] instruction;

    reg [7:0] inst_data [0:255];

    
    always @(read_addr) begin
        if ((read_addr & 32'b11) == 0 && read_addr < 256) begin
            instruction = {inst_data[read_addr], inst_data[read_addr + 1],
             inst_data[read_addr + 2], inst_data[read_addr + 3]};
        end else begin
            instruction = 32'd0;
            $display("error in inst mem.");
            $stop;
        end
    end

endmodule
