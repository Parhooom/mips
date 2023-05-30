`timescale 1ns/1ns

module signextend (
    data,
    extended_data
);

    input [15:0] data;
    output [31:0] extended_data;

    assign extended_data = {{ 16 {data[15]} }, data};
    
endmodule
