`timescale 1ns / 1ps
/*
module pcreg(clk,data_in,rst,wena,data_out);
	input clk;
    input [31:0] data_in;
    input rst;
    input wena;
    output [31:0] data_out;
	Reg pc(.data_in(data_in),.clk(clk),.rst(rst),.wena(wena),.data_out(data_out));
endmodule
*/

module pcreg(
input clk,
input rst,
input wena,
input [31:0]data_in,
output[31:0]data_out
);
reg     [31:0]data;
always @(posedge clk or posedge rst)
    if (rst)
        data <= 32'h00400000;
    else if (wena)
        data <= data_in;
assign data_out = data;
endmodule
