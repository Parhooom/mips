`timescale 1ns/1ns

module mux2to1_32bit (
    i0,
    i1,
    sel,
    out
);

    input [31:0] i0, i1;
    input sel;
    output [31:0] out;


    assign out = (sel == 1'b1) ? i1: i0;

endmodule