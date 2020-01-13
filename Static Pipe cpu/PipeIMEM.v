`timescale 1ns / 1ps

module PipeIMEM(pc,inst);
	input [31:0] pc;
    output [31:0] inst;
	IMEM i(.a({2'b00,pc[31:2]}),.spo(inst));
endmodule


