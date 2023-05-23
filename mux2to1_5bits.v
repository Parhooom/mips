module mux2to1_5bit (
    i0,
    i1,
    sel,
    out
);

    input [4:0] i0, i1;
    input sel;
    output [4:0] out;

    // always @(i0 or i1 or sel) begin
    //     if (sel == 1'b1) out = i1;
    //     else out = i0;
    // end

    assign out = (sel == 1'b1) ? i1: i0;

endmodule


module mux_test;
    reg [4:0] i0, i1;
    reg sel;
    wire [4:0] out;

    mux2to1_5bit mux_tb(
    i0,
    i1,
    sel,
    out
    );

    initial begin
        i0 = 5'd11;
        i1 = 5'd2;
        sel = 1'b1;

        #10;

        sel = 1'b0;
        #10;
    end

endmodule 