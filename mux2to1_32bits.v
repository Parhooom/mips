module mux2to1_32bit (
    i0,
    i1,
    sel,
    out
);

    input [31:0] i0, i1;
    input sel;
    output [31:0] out;

    // always @(i0 or i1 or sel) begin
    //     if (sel == 1'b1) out = i1;
    //     else out = i0;
    // end
    assign out = (sel == 1'b1) ? i1: i0;

endmodule