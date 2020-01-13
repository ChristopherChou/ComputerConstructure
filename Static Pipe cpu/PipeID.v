`timescale 1ns / 1ps
//ID级部件 包含控制单元CU 寄存器堆 CP0 HILO 分支比较 扩展立即数 计算转移地址 多路选择器
//输入 从WB级传回的写信号、写地址和写数据 IF级传递的值
//输出 各类控制信号 向EXE级传递的各类寄存器读出的值


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
	input EisGoto				;//浠嶦XE浼犲洖鐨刬sGoto(ejal)
	input [ 4:0] Ern			;//
	input Ew_hi					;//鍐檋i浣胯兘淇″彿
	input Ew_lo					;//鍐檒o浣胯兘淇″彿
	input Ew_rf					;//鍐檙f浣胯兘淇″彿,ewreg
	input [2:0] Erfsource		;
	input [ 4:0] Mrn			;//
	input Mw_rf					;//鍐檙f鐨勪俊鍙凤紝mwreg
	input [2:0] Mrfsource		;
	input [31:0] Wdata_hi		;//鍐欏叆hi鐨勬暟鎹?
	input [31:0] Wdata_lo		;//鍐欏叆lo鐨勬暟鎹?
	input [31:0] Wdata_rf		;//鍐欏叆rf鐨勬暟鎹?,浼氬湪WB鍛ㄦ湡杩斿洖锛屽啓鍏?rn
	input Wena_hi				;//hi鍐欎娇鑳戒俊鍙?
	input Wena_lo				;//lo鍐欎娇鑳戒俊鍙?
	input Wena_rf				;//rf鍐欎娇鑳戒俊鍙?
	input [ 4:0] Wrn			;//Wrn
    input clk					;//鏃堕挓
    input [31:0] inst			;//鎸囦护
    input [31:0] pc4			;//pc+4
    input rst					;//澶嶄綅淇″彿
	input [31:0] Ealu			;//鍓嶆帹alu鐨勭粨鏋?
	input [31:0] Malu			;//鍓嶆帹alu鐨勭粨鏋?
	input [31:0] Mdm			;
	output [31:0] CP0out		;//cp0杈撳嚭	
	output [31:0] Dpc4			;//pc+4杈撳嚭
	output [31:0] Hiout			;//Hi瀵勫瓨鍣ㄨ緭鍑?
	output [31:0] Loout			;//Lo瀵勫瓨鍣ㄨ緭鍑?
	output [31:0] Rsout			;//Rs杈撳嚭
	output [31:0] Rtout			;//Rt杈撳嚭
	output [ 3:0] aluc			;//alu鎺у埗淇″彿
	output asource				;//alu鐨刟閫夋嫨淇″彿,shift
	output bsource				;//alu鐨刡閫夋嫨淇″彿,aluimm
	output [31:0] bpc			;//beq鐨勮烦杞琾c	
	output [31:0] cpc			;//
	output [ 1:0] cuttersource	;//
	output div					;//
	output [ 1:0] hisource		;//hi鐨勯?銐鎷╀俊鍙?
	output [ 1:0] losource		;//lo鐨勯?銐鎷╀俊鍙?
	output [31:0] imm			;//鎵╁睍鍚庣殑绔嬪嵆鏁?
	output isGoto				;//jal
	output [31:0] jpc			;//璺宠浆鐨刾c
	output [ 2:0] pcsource		;//pc鐨勯?銐鎷╀俊鍙凤??5閫?1锛岄渶瑕?3浣?
	output [31:0] reg28			;//
	output [ 2:0] rfsource		;//鍐欏洖rf鐨勬潵鑷?鍝?閲?
	output [ 4:0] rn			;//rt,rd涓?閫夋嫨寰楀埌鐨勭粨鏋?
	output [31:0] rpc			;//瀵勫瓨鍣ㄥ爢寰楀埌鐨勪笅涓?沔潯鎸囦??
	output sign					;//绗﹀彿浣?		
	output stall				;//鍋滄??
	output w_hi					;//鍐檋i淇″彿  ,1鍐?0涓嶅啓
	output w_lo					;//鍐檒o淇″彿  ,1鍐?0涓嶅啓
	output w_dm					;//鍐檇mem淇″彿,1鍐?0涓嶅啓(wmem)
	output w_rf					;//鍐檙f淇″彿  ,1鍐?0涓嶅啓(wreg)
	
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
	
	wire [16:0] ext16;//16浣嶇?﹀彿鎵╁睍
	wire [31:0] br_offset;//瀵勫瓨鍣ㄧ殑杈撳嚭qa,qb,branch_offset 鍒嗘敮鍋忕Щ
	wire e;
	assign e = sext&inst[15];//绗﹀彿鎵╁睍
	assign ext16 = {16{e}};	
	regfile rf (.clk(~clk),.rst(rst),.we(Wena_rf),.raddr1(rs),.raddr2(rt),
				.waddr(Wrn),.wdata(Wdata_rf),.rdata1(qa),.rdata2(qb),.reg28(reg28));
	mux4x32 a(.a(qa),.b(Ealu),.c(Malu),.d(Mdm),.pcsource(fwda),.y(Rsout));
	mux4x32 b(.a(qb),.b(Ealu),.c(Malu),.d(Mdm),.pcsource(fwdb),.y(Rtout));

	assign imm = {ext16,inst[15:0]};//16浣嶆墿灞?,32浣嶇殑绔嬪嵆鏁?
	assign br_offset = {imm[29:0],2'b00};//18浣嶆墿灞?,branch_offset 鍒嗘敮鍋忕Щ,璺宠浆鍦板潃
	cla32 br_adr(.a(pc4),.b(br_offset),.sub(1'b0),.s(bpc));//beq锛宐ne鐨勮烦杞?鍦板潃
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
