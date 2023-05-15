module mips_cpu (
    clk,
    rst
);

    input clk, rst;

    reg [31:0] pcin = 32'd0;
    wire [31:0] pcout;
    pc programcounter(
    .clk(clk),
    .rst(rst),
    .pcin(pcin),
    .pcout(pcout)
    );


    wire [31:0] instruction;
    instmem instructionmemory(
    .read_addr(pcout),
    .instruction(instruction)
    );

    
    wire regdst, regwrite, alusrc, memread, memwrite,
         memtoreg, branch, jump;
    wire [2:0] aluop;
    controller controlunit(
    .clk(clk),
    .opcode(instruction[31:26]),
    .func(instruction[5:0]),
    .regdst(regdst),
    .regwrite(regwrite),
    .alusrc(alusrc),
    .memread(memread),
    .memwrite(memwrite),
    .memtoreg(memtoreg),
    .branch(branch),
    .jump(jump),
    .aluop(aluop)
    );

    
    wire [4:0] readreg1, readreg2, writereg;
    wire [31:0] writedata, readdata1, readdata2;
    assign readreg1 = instruction[25:21];
    assign readreg2 = instruction[20:16];


    mux2to1_32bit mux_writereg(
    .i0(instruction[20:16]),
    .i1(instruction[15:11]),
    .sel(regdst),
    .out(writereg)
    );


    regfile registerfile(
    .readreg1(readreg1),
    .readreg2(readreg2),
    .writereg(writereg),
    .writedata(writedata),
    .regwrite(regwrite),
    .readdata1(readdata1),
    .readdata2(readdata2)
    );


    wire [31:0] extended_data;
    signextend dataextend(
    .data(instruction[15:0]),
    .extended_data(extended_data)
    );

    
    wire [31:0] alu_b_input;
    mux2to1_32bit (
    .i0(readdata2),
    .i1(extended_data),
    .sel(alusrc),
    .out(alu_b_input)
    );

endmodule
