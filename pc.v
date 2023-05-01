module pc(clk, rst, pcin, pcout);
    input clk, rst;
    input [31:0] pcin;
    output reg [31:0] pcout;

    always @(posedge clk)
    begin
        if(rst == 1)
            pcout = 32'h0000_0000;
        else
            pcout = pcin;
    end
endmodule