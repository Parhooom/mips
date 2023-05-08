module regfile (
    readreg1,
    readreg2,
    writereg,
    writedata,
    regwrite,
    readdata1,
    readdata2
);
    
    input regwrite;
    input [4:0] readreg1, readreg2, writereg;
    input [31:0] writedata;
    output reg [31:0] readdata1, readdata2;

    reg [31:0] file_reg [0:31];

    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin // for testing
            file_reg[i] = i;
        end
    end

    always @(readreg1 or readreg2 or writereg
    or writedata or regwrite) begin
        if (regwrite && writereg != 5'd0) begin
            file_reg[writereg] = writedata;        
        end else begin
            readdata1 = file_reg[readreg1];
            readdata2 = file_reg[readreg2];
        end
    end

endmodule

module regfile_test;
    
    reg regwrite;
    reg [4:0] readreg1, readreg2, writereg;
    reg [31:0] writedata;
    wire [31:0] readdata1, readdata2;

    regfile u0(
        readreg1,
        readreg2,
        writereg,
        writedata,
        regwrite,
        readdata1,
        readdata2
    );

    initial
    begin
        regwrite = 1'b0;
        readreg1 = 5'd2;
        readreg2 = 5'd11;

        writereg = 5'd5;
        writedata = 32'd10;

        #30;
        $stop;
    end
    
endmodule