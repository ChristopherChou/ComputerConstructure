`timescale 1ns / 1ps

module CP0(
    clk,rst,
    wsta,wcau,wepc,
    mfc0,mtc0,exc,inta,
    pc,npc,mux1,
    wdata,
    alu_mem,
    cause,selpc,
    sta,rdata,exc_addr);
	input clk				;
	input rst				;
	input wcau				;//写控制信号
	input wepc				;//写控制信号
	input wsta				;//写控制信号
	input [1:0]mfc0			;//选择控制信号
	input mtc0				;//选择控制信号
	input exc				;//选择控制信号
	input inta				;//选择控制信号
	input [31:0]cause		;
	input [ 1:0]selpc		;
	output [31:0]sta		;
	output [31:0] rdata		; 
	output [31:0]exc_addr	;
	input [31:0]pc			;
	input [31:0]npc			;
	input [31:0]mux1		;
	input [31:0]wdata		;
	input [31:0]alu_mem		;

	
	wire [31:0]sta_11_a0;
	wire [31:0]epc_11_a0;
	wire [31:0]cau;
	wire [31:0]epc;
	wire [31:0]sta_in;
	wire [31:0]cau_in;
	wire [31:0]epc_in;

	Reg cause_reg(.data_in(cau_in),.clk(clk),.rst(rst),.wena(wcau),.data_out(cau));
	Reg epc_reg(.data_in(epc_in),.clk(clk),.rst(rst),.wena(wepc),.data_out(epc));
	Reg status_reg(.data_in(sta_in),.clk(clk),.rst(rst),.wena(wsta),.data_out(sta));
	mux2x32 cau_11(.a(cause),.b(wdata),.s(mtc0),.y(cau_in));
	mux2x32 epc_11(.a(epc_11_a0),.b(wdata),.s(mtc0),.y(epc_in));
	mux2x32 epc_12(.a(pc),.b(npc),.s(inta),.y(epc_11_a0));
	mux4x32 irq_pc(.a(mux1),.b(epc),.c(32'h0000_0004),.d(32'h0),.pcsource(selpc),.y(exc_addr));
	mux4x32 fromc0_pc(.a(alu_mem),.b(sta),.c(cau),.d(epc),.pcsource(mfc0),.y(rdata));
	mux2x32 sta_11(.a(sta_11_a0),.b(wdata),.s(mtc0),.y(sta_in));
	mux2x32 sta_12(.a({5'h0,sta[31:5]}),.b({sta[26:0],5'h0}),.s(exc),.y(sta_11_a0));
endmodule
