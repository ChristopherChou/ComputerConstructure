`timescale 1ns / 1ps
//EXE including ALU,mul,div,cla
module pipeEXE(aluc,a,b,
			   asource,bsource,
			   cp0,cuttersource,
			   div,   
			   hi,hisource,
			   imm,
			   isGoto,
			   lo,losource,
			   pc4,
			   rfsource,rn,
			   sign,
			   w_dm,w_hi,w_lo,w_rf,
			   Ealu,Ea,Eb,
			   Ecounter,
			   Ecp0,Ecuttersource,
			   Ehi,Ehisource,
			   EisGoto,
			   Elo,Elosource,
			   Emuler_hi,Emuler_lo,
			   Epc4,
			   Eq,Er,
			   Erfsource,Ern,
			   Esign,
			   Ew_dm,Ew_hi,Ew_lo,Ew_rf);  
	input [ 3:0] aluc			;
	input [31:0] a				;
	input [31:0] b				;
	input asource				;
	input bsource				;
    input [31:0] cp0			;
    input [ 1:0] cuttersource	;
    input div					;   
    input [31:0] hi				;
    input [ 1:0] hisource		;
	input [31:0] imm			;
    input isGoto				;//暂时认为是jal_ena�?
    input [31:0] lo				;
    input [ 1:0] losource		;
	input [31:0] pc4			;
	input [ 2:0] rfsource		;
	input [ 4:0] rn				;
	input sign					;
	input w_dm					;
    input w_hi					;
    input w_lo					;
	input w_rf					;
	output [31:0] Ealu			;
	output [31:0] Ea			;
	output [31:0] Eb			;
	output [31:0] Ecounter		;
	output [31:0] Ecp0			;
    output [ 1:0] Ecuttersource	;
    output [31:0] Ehi			;
    output [ 1:0] Ehisource		;
    output EisGoto				;
    output [31:0] Elo			;
    output [ 1:0] Elosource		;
    output [31:0] Emuler_hi		;
    output [31:0] Emuler_lo		;
	output [31:0] Epc4			;
	output [31:0] Eq			;
	output [31:0] Er			;
    output [ 2:0] Erfsource		;
	output [ 4:0] Ern			;
	output Esign				;
	output Ew_dm				; 
	output Ew_hi				;
	output Ew_lo				;
	output Ew_rf				; 
	
	wire [31:0] alua,alub;
	wire [31:0] ext5;
	assign ext5 = {27'b0000_0000_0000_0000_0000_0000_000,imm[10:6]};	

	//mux2x32(a,b,s,y);
	mux2x32 alu_a(.a(a),.b(ext5),.s(asource),.y(alua));
	mux2x32 alu_b(.a(b),.b(imm),.s(bsource),.y(alub));
	assign Ern = rn|{5{isGoto}};//jal�?31号寄存器
	wire [31:0] pc8;
	assign pc8=pc4+4;
	assign Esign=sign;
	assign Ew_dm=w_dm;
	assign Ew_rf=w_rf;
	assign Ew_hi=w_hi;
	assign Ew_lo=w_lo;
	assign Ehi=hi;
	assign Elo=lo;

	assign Er=32'h0000;//没有写除法器
	assign Eq=32'h0000;
	assign Ea=a;
	assign Eb=b;
	assign EisGoto=isGoto;
	assign Erfsource=rfsource;
	assign Epc4=pc4;
	wire [31:0] alu_temp;//ALU的输�?
	ALU alu_unit(.a(alua),.b(alub),.aluc(aluc),.r(alu_temp),.zero(),.carry(),.negative(),.overflow());
	mux2x32 alu_res(.a(alu_temp),.b(pc8),.s(isGoto),.y(Ealu));
	wire [63:0]muls_res,mulu_res;
	mult_gen_0 muls(.A(a),.B(b),.P(muls_res));
	mult_gen_1 mulu(.A(a),.B(b),.P(mulu_res));
	mux2x32 mul_su_hi(.a(muls_res[63:32]),.b(mulu_res[63:32]),.s(~sign),.y(Emuler_hi));
	mux2x32 mul_su_lo(.a(muls_res[31:00]),.b(mulu_res[31:00]),.s(~sign),.y(Emuler_lo));
	
endmodule  