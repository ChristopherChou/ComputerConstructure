`timescale 1ns / 1ps
//2ѡ1 5λ
module mux2x5(
    input [4:0]a,
    input [4:0]b,
    input ena,
    output [4:0]o
    );
    assign o=ena?b:a;
endmodule
