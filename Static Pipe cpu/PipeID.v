`timescale 1ns / 1ps
//ID������ �������Ƶ�ԪCU �Ĵ����� CP0 HILO ��֧�Ƚ� ��չ������ ����ת�Ƶ�ַ ��·ѡ����
//���� ��WB�����ص�д�źš�д��ַ��д���� IF�����ݵ�ֵ
//��� ��������ź� ��EXE�����ݵĸ���Ĵ���������ֵ


module PipeID(EisGoto,Ern,Ew_hi,Ew_lo,Ew_rf,
			  Mrn,Mw_rf,
			  Wdata_hi,Wdata_lo,Wdata_rf,
			  Wena_hi,Wena_lo,Wena_rf,Wrn,
			  Ealu,Malu,
			  Mdm,
			  Erfsource,Mrfsource,
			  clk,inst,pc4,rst,
			  CP0out,
			  losource,pcsource,
			  reg28,
			  rfsource,rn,rpc,
			  sign,stall,
			  Dpc4,
			  Hiout,Loout,Rsout,Rtout,
			  aluc,asource,bsource,
			  bpc,cpc,
			  cuttersource,
			  div,
			  hisource,
			  imm,isGoto,
			  jpc,
			  w_dm,w_hi,w_lo,w_rf);
	input EisGoto				;//从EXE传回的isGoto(ejal)
	input [ 4:0] Ern			;//
	input Ew_hi					;//写hi使能信号
	input Ew_lo					;//写lo使能信号
	input Ew_rf					;//写rf使能信号,ewreg
	input [2:0] Erfsource		;
	input [ 4:0] Mrn			;//
	input Mw_rf					;//写rf的信号，mwreg
	input [2:0] Mrfsource		;
	input [31:0] Wdata_hi		;//写入hi的数�?
	input [31:0] Wdata_lo		;//写入lo的数�?
	input [31:0] Wdata_rf		;//写入rf的数�?,会在WB周期返回，写�?rn
	input Wena_hi				;//hi写使能信�?
	input Wena_lo				;//lo写使能信�?
	input Wena_rf				;//rf写使能信�?
	input [ 4:0] Wrn			;//Wrn
    input clk					;//时钟
    input [31:0] inst			;//指令
    input [31:0] pc4			;//pc+4
    input rst					;//复位信号
	input [31:0] Ealu			;//前推alu的结�?
	input [31:0] Malu			;//前推alu的结�?
	input [31:0] Mdm			;
	output [31:0] CP0out		;//cp0输出	
	output [31:0] Dpc4			;//pc+4输出
	output [31:0] Hiout			;//Hi寄存器输�?
	output [31:0] Loout			;//Lo寄存器输�?
	output [31:0] Rsout			;//Rs输出
	output [31:0] Rtout			;//Rt输出
	output [ 3:0] aluc			;//alu控制信号
	output asource				;//alu的a选择信号,shift
	output bsource				;//alu的b选择信号,aluimm
	output [31:0] bpc			;//beq的跳转pc	
	output [31:0] cpc			;//
	output [ 1:0] cuttersource	;//
	output div					;//
	output [ 1:0] hisource		;//hi的�?�择信�?
	output [ 1:0] losource		;//lo的�?�择信�?
	output [31:0] imm			;//扩展后的立即�?
	output isGoto				;//jal
	output [31:0] jpc			;//跳转的pc
	output [ 2:0] pcsource		;//pc的�?�择信号�??5�?1，需�?3�?
	output [31:0] reg28			;//
	output [ 2:0] rfsource		;//写回rf的来�?�?�?
	output [ 4:0] rn			;//rt,rd�?选择得到的结�?
	output [31:0] rpc			;//寄存器堆得到的下�?�条指�??
	output sign					;//符号�?		
	output stall				;//停�??
	output w_hi					;//写hi信号  ,1�?0不写
	output w_lo					;//写lo信号  ,1�?0不写
	output w_dm					;//写dmem信号,1�?0不写(wmem)
	output w_rf					;//写rf信号  ,1�?0不写(wreg)
	
	wire [ 5:0] op,func;//op and func
	wire [ 4:0] rs,rt,rd;
	wire reg_rt;
	wire sext;
	wire zero;
	wire [31:0] qa,qb;
	wire [1:0] fwda,fwdb;
	wire delay;
	assign zero = (Rsout==Rtout);
	assign func = inst[ 5: 0];
	assign op   = inst[31:26];
	assign rs   = inst[25:21];
	assign rt   = inst[20:16];
	assign rd   = inst[15:11];

	pipeIDcu cu(.op1(rs),.op2(rt),.op(op),.func(func),.rd(rd),.zero(zero),
				.EisGoto(EisGoto),
				.Erfsource(Erfsource),.Mrfsource(Mrfsource),
				.Ew_rf(Ew_rf),.Mw_rf(Mw_rf),
				.Ern(Ern),.Mrn(Mrn),
				.isGoto(isGoto),
				.aluc(aluc),.asource(asource),.bsource(bsource),
				.pcsource(pcsource),.rfsource(rfsource),
				.w_dm(w_dm),.w_rf(w_rf),.reg_rt(reg_rt),
				.sext(sext),.stall(stall),
				.fwda(fwda),.fwdb(fwdb),
				.delay(delay));
	
	mux2x5 des_reg(.a(rd),.b(rt),.ena(reg_rt),.o(rn));
	
	wire [16:0] ext16;//16位�?�号扩展
	wire [31:0] br_offset;//寄存器的输出qa,qb,branch_offset 分支偏移
	wire e;
	assign e = sext&inst[15];//符号扩展
	assign ext16 = {16{e}};	
	regfile rf (.clk(~clk),.rst(rst),.we(Wena_rf),.raddr1(rs),.raddr2(rt),
				.waddr(Wrn),.wdata(Wdata_rf),.rdata1(qa),.rdata2(qb),.reg28(reg28));
	mux4x32 a(.a(qa),.b(Ealu),.c(Malu),.d(Mdm),.pcsource(fwda),.y(Rsout));
	mux4x32 b(.a(qb),.b(Ealu),.c(Malu),.d(Mdm),.pcsource(fwdb),.y(Rtout));

	assign imm = {ext16,inst[15:0]};//16位扩�?,32位的立即�?
	assign br_offset = {imm[29:0],2'b00};//18位扩�?,branch_offset 分支偏移,跳转地址
	cla32 br_adr(.a(pc4),.b(br_offset),.sub(1'b0),.s(bpc));//beq，bne的跳�?地址
	CP0 cp0(.clk(clk),.rst(rst),.wsta(wsta),.wcau(wcau),
			.wepc(wepc),.mfc0(mfc0),.mtc0(mtc0),.exc(exc),
			.inta(inta),.pc(pc),.npc(npc),.mux1(mux1),
			.wdata(wdata),.alu_mem(alu_mem),.cause(cause),
			.selpc(selpc),.sta(sta),.rdata(rdata),
			.exc_addr(exc_addr));
		
	assign rpc   = Rsout-32'h00400000;
	assign jpc   = {pc4[31:28],inst[25:0],2'b00};	
	assign Dpc4  = pc4;
	assign sign  = sext;
	
	Reg hi(.data_in(Wdata_hi),.clk(clk),.rst(rst),.wena(w_hi),.data_out(Hiout));
	Reg lo(.data_in(Wdata_lo),.clk(clk),.rst(rst),.wena(w_lo),.data_out(Loout));

endmodule
