`timescale 1ns/1ns

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
        {mem_data[0], mem_data[1], mem_data[2], mem_data[3]}
            = 32'd6;

        for (i = 4; i < 256; i = i + 1) begin
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
        end
    end

endmodule

module datamem_test;

    reg memread, memwrite;
    reg [31:0] writedata, addr;
    wire [31:0] readdata;
    
    datamem datamemory(
    memread,
    memwrite,
    addr,
    writedata,
    readdata 
    );

    initial begin
        memread = 1'b0;
        memwrite = 1'b0;
        #10;

        addr = 32'd4;
        writedata = 32'd27;
        memwrite = 1'b1;
        #10 memwrite = 1'b0;
        
        #10;
        addr = 32'd0;
        writedata = 32'd17;
        memwrite = 1'b1;
        #10 memwrite = 1'b0;

        #10;
        addr = 32'd0;
        memread = 1'b1;

        #10;
        addr = 32'd4;
    end
   

endmodule