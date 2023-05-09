module datamem (
    memread,
    memwrite,
    addr,
    writedata,
    readdata 
);
    
    input memread, memwrite;
    input [31:0] writedata, addr;
    output reg [31:0] readdata;

    reg [7:0] mem_data [0:255];

    integer i;
    
    initial
    begin
        for (i = 0; i < 256; i = i + 1) begin
            mem_data[i] = 8'd0;    
        end
    end

    always @(memread or memwrite or addr or writedata) begin
        if ((addr & 32'b11) == 0 && addr < 256) begin
            if (memwrite == 1'b1) begin
                {mem_data[addr], mem_data[addr + 1], mem_data[addr + 2], mem_data[addr + 3]} = writedata;
            end else if (memread == 1'b1) begin
                readdata = {mem_data[addr], mem_data[addr + 1], mem_data[addr + 2], mem_data[addr + 3]};
            end  
        end else begin
            readdata = 32'd0;
            $display("error in data mem.");
            $stop;
        end
    end

endmodule