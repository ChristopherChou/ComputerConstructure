`timescale 1ns / 1ps


module PipeEXE(aluc,a,b,
			   asource,bsource,
			   rfsource,rn,
			   cp0,cuttersource,
			   div,   
			   hi,hisource,
			   imm,
			   isGoto,
			   lo,losource,
			   pc4,
			   sign,
			   w_dm,w_hi,w_lo,w_rf,
			   Ealu,Ea,Eb,
			   Epc4,
			   Eq,Er,
			   Erfsource,Ern,
			   Esign,
			   Ecounter,
			   Ecp0,Ecuttersource,
			   Ehi,Ehisource,
			   EisGoto,
			   Elo,Elosource,
			   Emuler_hi,Emuler_lo,
			   Ew_dm,Ew_hi,Ew_lo,Ew_rf);  
	input [ 3:0] aluc			;
	input [31:0] a				;
	input [31:0] b				;
	input asource				;
	input bsource				;
/**/input [31:0] cp0			;
/**/input [ 1:0] cuttersource	;
/**/input div					;   
/**/input [31:0] hi				;
/**/input [ 1:0] hisource		;
	input [31:0] imm			;
/**/input isGoto				;//暂时认为是jal_ena吧
/**/input [31:0] lo				;
/**/input [ 1:0] losource		;
	input [31:0] pc4			;
	input [ 2:0] rfsource		;
	input [ 4:0] rn				;
	input sign					;
	input w_dm					;
/**/input w_hi					;
/**/input w_lo					;
	input w_rf					;
	output [31:0] Ealu			;
	output [31:0] Ea			;
	output [31:0] Eb			;
	output [31:0] Ecounter		;
	output [31:0] Ecp0			;
/**/output [ 1:0] Ecuttersource	;
/**/output [31:0] Ehi			;
/**/output [ 1:0] Ehisource		;
/**/output EisGoto				;
/**/output [31:0] Elo			;
/**/output [ 1:0] Elosource		;
/**/output [31:0] Emuler_hi		;
/**/output [31:0] Emuler_lo		;
	output [31:0] Epc4			;
/**/output [31:0] Eq			;
/**/output [31:0] Er			;
/**/output [ 2:0] Erfsource		;
	output [ 4:0] Ern			;
	output Esign				;
	output Ew_dm				; 
/**/output Ew_hi				;
/**/output Ew_lo				;
	output Ew_rf				; 
	
	wire [31:0] alua,alub;
	wire [31:0] ext5;
	assign ext5 = {27'b0000_0000_0000_0000_0000_0000_000,imm[10:6]};	

	//mux2x32(a,b,s,y);
	mux2x32 alu_a(.a(a),.b(ext5),.s(asource),.y(alua));
	mux2x32 alu_b(.a(b),.b(imm),.s(bsource),.y(alub));
	assign Ern = rn|{5{isGoto}};//jal写31号寄存器
	wire [31:0] pc8;
	cla32 pc8_(.a(pc4),.b(32'h4),.sub(1'b0),.s(pc8));//pc4+4,jal的跳转地址
	assign Esign=sign;
	assign Ew_dm=w_dm;
	assign Ew_rf=w_rf;
	assign Ea=a;
	assign Eb=b;
	assign EisGoto=isGoto;
	assign Erfsource=rfsource;
	assign Epc4=pc4;
	//ALU(a,b,aluc,r,zero,carry,negative,overflow);
	wire [31:0] alu_temp;//ALU的输出
	ALU alu_unit(.a(alua),.b(alub),.aluc(aluc),.r(alu_temp),.zero(),.carry(),.negative(),.overflow());
	mux2x32 alu_res(.a(alu_temp),.b(pc8),.s(isGoto),.y(Ealu));
endmodule  