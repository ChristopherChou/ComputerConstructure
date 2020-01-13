`timescale 1ns / 1ps
//IF/ID间的流水寄存器
//用于存放取出的指令并执行pc+4的操作

module PipeIR(clk,pc4,inst,nostall,rst,Dinst,Dpc4);
    input clk			;//时钟
	input [31:0] pc4	;//pc+4
    input [31:0] inst	;//指令
    input nostall		;//是否空
    input rst			;//复位信号
    output [31:0] Dinst;//存的指令
    output [31:0] Dpc4 ;//存的pc+4
	Reg pcplus4(.data_in(pc4),.clk(clk),.rst(rst),.wena(nostall),.data_out(Dpc4));
	Reg instruction(.data_in(inst),.clk(clk),.rst(rst),.wena(nostall),.data_out(Dinst));
endmodule
