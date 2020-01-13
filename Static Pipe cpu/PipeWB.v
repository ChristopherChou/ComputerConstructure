`timescale 1ns / 1ps

module PipeWB(alu,a,b,
			  counter,cp0,
			  dm,
			  hi,hisource,
			  lo,losource,
			  muler_hi,muler_lo,
			  pc4,q,r,
			  rfsource,rn,
			  w_hi,w_lo,w_rf,
			  Wdata_hi,Wdata_lo,Wdata_rf,
			  Wrn,
			  Ww_hi,Ww_lo,Ww_rf);
	input w_hi					;
	input w_lo					;
	input w_rf					;
	input [31:0] alu			;//alu的输出，实际是Malu
	input [31:0] a				;
	input [31:0] b				;
	input [31:0] counter		;
	input [31:0] cp0			;
	input [31:0] dm				;
	input [31:0] hi				;
	input [ 1:0] hisource		;
	input [31:0] lo				;
	input [ 1:0] losource		;
	input [31:0] muler_hi		;
	input [31:0] muler_lo		;
	input [31:0] q				;
	input [31:0] r				;
	input [ 2:0] rfsource		;
	input [31:0] pc4			;
	input [ 4:0] rn				;
	output Ww_hi				;
	output Ww_lo				;
	output Ww_rf				;
	output [31:0] Wdata_hi		;
	output [31:0] Wdata_lo		;
	output [31:0] Wdata_rf		;
	output [ 4:0] Wrn			;
	mux2x32 alu_mem(.a(alu),.b(dm),.s(rfsource[0]),.y(Wdata_rf));
	assign Wrn=rn;
	assign Ww_rf=w_rf;
endmodule  



