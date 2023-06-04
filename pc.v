`timescale 1ns/1ns

module pc (
    clk,
    rst,
    pcin,
    pcout
);

    input clk, rst;
    input [31:0] pcin;
    output reg [31:0] pcout = 32'd0;

    always @(posedge clk)
    begin
        if(rst == 1'b1)
            pcout = 32'd0;
        else
            pcout = pcin;

        if (pcout == 32'd32) begin
            $display("time: %t", $time);
        end
    end

endmodule