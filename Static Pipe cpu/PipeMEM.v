`timescale 1ns / 1ps

module PipeMEMreg(clk,
				  alu,a,b,
				  counter,
				  cp0,cuttersource,
				  w_dm,w_hi,w_lo,w_rf,
				  Malu,Ma,Mb,
				  Mcounter,Mcp0,
				  Mdm,
				  hi,hisource,
				  lo,losource,
				  muler_hi,muler_lo,
				  pc4,q,r,
				  rfsource,rn,
				  sign,
				  Mhi,Mhisource,
				  Mlo,Mlosource,
				  Mmuler_hi,Mmuler_lo,
				  Mpc4,Mq,Mr,
				  Mrfsource,Mrn,
				  Msign,
				  Mw_hi,Mw_lo,Mw_rf);
	input clk					;
	input sign					;
	input w_dm					;
	input w_hi					;
	input w_lo					;
	input w_rf					;
	input [31:0] pc4			;
	input [31:0] q				;
	input [31:0] r				;
	input [ 2:0] rfsource		;
	input [ 4:0] rn				;
	output Msign				;
	output Mw_hi				;
	output Mw_lo				;
	output Mw_rf				;  
	input [31:0] alu 			;
	input [31:0] a 				;
	input [31:0] b 				;
	input [31:0] counter 		;
	input [31:0] cp0 			;
	input [ 1:0] cuttersource 	;
	input [31:0] hi 			;
	input [ 1:0] hisource 		;
	input [31:0] lo 			;
	input [ 1:0] losource 		;
	input [31:0] muler_hi		;
	input [31:0] muler_lo		;
	output [31:0] Malu 			;
	output [31:0] Ma 			;
	output [31:0] Mb 			;
	output [31:0] Mcounter 		;
	output [31:0] Mcp0 			;
	output [31:0] Mdm 			;
	output [31:0] Mhi 			;
	output [ 1:0] Mhisource		;
	output [31:0] Mlo 			;
	output [ 1:0] Mlosource		;
	output [31:0] Mpc4			;
	output [31:0] Mq			;
	output [31:0] Mr			;
	output [ 2:0] Mrfsource		;
	output [ 4:0] Mrn			;  
	output [31:0] Mmuler_hi		;
	output [31:0] Mmuler_lo		;
	
	pipeDMEM datamem(.in(b),.addr(alu),.clk(clk),.wmem(w_dm),.out(Mdm));
	assign Mw_rf=w_rf;
	assign Mrfsource=rfsource;
	assign Malu=alu;
	assign Ma=a;
	assign Mb=b;
	assign Mpc4=pc4;
	assign Mrn=rn;
endmodule  