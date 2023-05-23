module mips_cpu (
    clk,
    rst
);

    input clk, rst;

    wire [31:0] pcin;
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


    mux2to1_5bit mux_writereg(
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
    mux2to1_32bit mux_alu_b_source(
    .i0(readdata2),
    .i1(extended_data),
    .sel(alusrc),
    .out(alu_b_input)
    );


    wire [31:0] alu_result;
    wire zero_flag;    
    alu ALU(
    .A(readdata1),
    .B(alu_b_input),
    .result(alu_result),
    .aluop(aluop),
    .zero_flag(zero_flag)
    );


    wire [31:0] datamem_output;
    datamem datamemory(
    .memread(memread),
    .memwrite(memwrite),
    .addr(alu_result),
    .writedata(readdata2),
    .readdata(datamem_output) 
    );


    mux2to1_32bit mux_memtoreg(
    .i0(alu_result),
    .i1(datamem_output),
    .sel(memtoreg),
    .out(writedata)
    );

    wire [31:0] pcplusfour;
    assign pcplusfour = pcout + 32'd4;
    wire [31:0] branchpc;
    assign branchpc = (readdata2 << 2) + pcplusfour;
    

    wire [31:0] mux_branch_output;
    mux2to1_32bit mux_branch(
    .i0(pcplusfour),
    .i1(branchpc),
    .sel(branch & zero_flag),
    .out(mux_branch_output)
    );


    mux2to1_32bit mux_jump(
    .i0(mux_branch_output),
    .i1({pcout[31:28], instruction[25:0], 2'b00}),
    .sel(jump),
    .out(pcin)
    );

endmodule



module mips_cpu_test;
    reg clk = 1'b0;
    reg rst = 1'b0;

    mips_cpu MIPS(
    .clk(clk),
    .rst(rst)
    );

    always begin
        #10 clk = ~clk;
        $display("haha");
    end 

endmodule