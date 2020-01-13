`timescale 1ns / 1ps
//ID 
module pipeID(Ealu,Ecp0,Ehi,Ehisource,
			  EisGoto,Elo,Elosource,
			  Emuler_hi,Emuler_lo,Eq,Er,
			  Erfsource,Ern,Ew_hi,Ew_lo,Ew_rf,
			  Malu,Mdm,Mrfsource,
			  Mmuler_hi,Mmuler_lo,
			  Mrn,Mw_rf,Mw_hi,Mw_lo,
			  Wdata_hi,Wdata_lo,Wdata_rf,
			  Wena_hi,Wena_lo,Wena_rf,Wrn,
			  clk,inst,pc4,rst,
			  CP0out,
			  Dpc4,
			  Hiout,Loout,Rsout,Rtout,
			  aluc,asource,bsource,
			  bpc,cpc,
			  cuttersource,
			  div,
			  reg28,
			  hisource,
			  imm,isGoto,
			  jpc,
			  losource,pcsource,
			  rfsource,rn,rpc,
			  sign,stall,
			  w_dm,w_hi,w_lo,w_rf);
	input [31:0] Ealu			;//前推alu
/**/input [31:0] Ecp0			;
	input [31:0] Ehi			;
	input [ 1:0] Ehisource		;
	input EisGoto				;//从EXE传回的isGoto(ejal)
	input [31:0] Elo			;
	input [ 1:0] Elosource		;
	input [31:0] Emuler_hi		;
	input [31:0] Emuler_lo		;
	input [31:0] Eq				;
	input [31:0] Er				;
	input [ 2:0] Erfsource		;
	input [ 4:0] Ern			;//
	input Ew_hi					;//写hi使能信号
	input Ew_lo					;//写lo使能信号
	input Ew_rf					;//写rf使能信号,ewreg

	input [31:0] Malu			;//前推alu
	input [31:0] Mdm			;
	input [ 4:0] Mrn			;//
	input [ 2:0] Mrfsource		;
	input [31:0] Mmuler_hi		;
	input [31:0] Mmuler_lo		;
	input Mw_rf					;//写rf的信号，mwreg
	input Mw_hi					;//写rf的信号，mwreg
	input Mw_lo					;//写rf的信号，mwreg

	input [31:0] Wdata_hi		;//写入hi
	input [31:0] Wdata_lo		;//写入lo
	input [31:0] Wdata_rf		;//写入rf的数,会在WB周期返回，写入rn
	input Wena_hi				;//hi写使�?
	input Wena_lo				;//lo写使�?
	input Wena_rf				;//rf写使�?
	input [ 4:0] Wrn			;//Wrn
    input clk					;//时钟
    input [31:0] inst			;//指令
    input [31:0] pc4			;//pc+4
    input rst					;//复位信号
/**/output [31:0] CP0out		;//cp0输出	
	output [31:0] Dpc4			;//pc+4输出
	output [31:0] Hiout			;//Hi寄存�?
	output [31:0] Loout			;//Lo寄存�?
	output [31:0] Rsout			;//Rs输出
	output [31:0] Rtout			;//Rt输出
	output [ 3:0] aluc			;//alu控制信号
	output asource				;//alu的a选择信号,shift
	output bsource				;//alu的b选择信号,aluimm
	output [31:0] bpc			;//beq的跳转pc	
    output [31:0] cpc			;//
    output [ 1:0] cuttersource	;//
    output div					;//
    output [ 1:0] hisource		;//hi的�?�择信号
    output [ 1:0] losource		;//lo的�?�择信号
	output [31:0] imm			;//扩展后的立即�?
    output isGoto				;//jal
	output [31:0] jpc			;//跳转的pc
	output [ 2:0] pcsource		;//pc的�?�择信号
	output [ 2:0] rfsource		;//写回rf的来�?
	output [ 4:0] rn			;//
	output [31:0] rpc			;//寄存器堆得到的下�?�?
	output sign					;
	output stall				;//停止
	output w_hi					;//写hi信号  ,1�?0不写
	output w_lo					;//写lo信号  ,1�?0不写
	output w_dm					;//写dmem信号,1�?0不写(wmem)
	output w_rf					;//写rf信号  ,1�?0不写(wreg)
	output [31:0]reg28;
	wire [ 5:0] op,func;//op and func
	wire [ 4:0] rs,rt,rd;//3个寄存器地址

	assign func = inst[ 5: 0];
	assign op   = inst[31:26];
	assign rs   = inst[25:21];
	assign rt   = inst[20:16];
	assign rd   = inst[15:11];
	
	wire reg_rt;//0选rd作为目的寄存�?,1选rt作为目的寄存�?
	wire sext;//是否符号扩展
	wire zero;
	wire [31:0] qa,qb;
	wire [31:0] Rsout0,Rtout0;
	assign zero = (Rsout==Rtout);
	wire [1:0] fwda0,fwda1,fwdb0,fwdb1;
	wire delay;

	//cu
	pipeIDcu cu(.op1(rs),.op2(rt),.op(op),.func(func),.rd(rd),.zero(zero),
				.EisGoto(EisGoto),
				.Erfsource(Erfsource),.Mrfsource(Mrfsource),
				.Ew_rf(Ew_rf),.Mw_rf(Mw_rf),
				.Ern(Ern),.Mrn(Mrn),
				.isGoto(isGoto),
				.aluc(aluc),.asource(asource),.bsource(bsource),
				.pcsource(pcsource),.rfsource(rfsource),
				.w_dm(w_dm),.w_rf(w_rf),
				.reg_rt(reg_rt),
				.sext(sext),.stall(stall),
				.fwda0(fwda0),.fwdb0(fwdb0),
				.fwda1(fwda1),.fwdb1(fwdb1),
				.delay(delay));
	
	assign rn=reg_rt?rt:rd;
	
	//regfile rf (.clk(~clk),.rst(rst),.we(Wena_rf),.raddr1(rs),.raddr2(rt),
      //              .waddr(Wrn),.wdata(Wdata_rf),.rdata1(qa),.rdata2(qb));
	regfile rf (.clk(~clk),.rst(rst),.we(Wena_rf),.raddr1(rs),.raddr2(rt),
				.waddr(Wrn),.wdata(Wdata_rf),.rdata1(qa),.rdata2(qb),.reg28(reg28));

	mux4x32 a0(.a(qa),.b(Ealu),.c(Malu),.d(Mdm),.pcsource(fwda0),.y(Rsout0));
	mux4x32 b0(.a(qb),.b(Ealu),.c(Malu),.d(Mdm),.pcsource(fwdb0),.y(Rtout0));
	mux4x32 a1(.a(Rsout0),.b(Emuler_lo),.c(Mmuler_lo),.d(32'h0000),.pcsource(fwda1),.y(Rsout));
	mux4x32 b1(.a(Rtout0),.b(Emuler_lo),.c(Mmuler_lo),.d(32'h0000),.pcsource(fwdb1),.y(Rtout));
	
	wire [31:0] hi,lo;
	wire [16:0] ext16;//16位符号扩�?
	wire [31:0] br_offset;//寄存器的输出qa,qb,branch_offset 分支偏移
	wire e;
	assign e = sext&inst[15];//符号扩展
	assign ext16 = {16{e}};	
	assign imm = {ext16,inst[15:0]};//16位扩�?,32位的立即�?
	assign br_offset = {imm[29:0],2'b00};//18位扩�?,branch_offset 分支偏移,跳转地址
	assign bpc=pc4+br_offset;
	assign rpc   = Rsout-32'h00400000;
	assign jpc   = {pc4[31:28],inst[25:0],2'b00};	
	assign Dpc4  = pc4;
	assign sign  = sext;	
	
	//CP0
	/*CP0 cp0(.clk(clk),.rst(rst),.wsta(wsta),.wcau(wcau),
			.wepc(wepc),.mfc0(mfc0),.mtc0(mtc0),.exc(exc),
			.inta(inta),.pc(pc),.npc(npc),.mux1(mux1),
			.wdata(wdata),.alu_mem(alu_mem),.cause(cause),
			.selpc(selpc),.sta(sta),.rdata(rdata),
			.exc_addr(exc_addr));*/
		
endmodule
