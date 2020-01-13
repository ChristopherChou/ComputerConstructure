`timescale 1ns / 1ps
//下板的顶层模块
module top(clk,rst,o_seg,o_sel);
	input clk				;//时钟
	input rst				;//复位
	output [7:0] o_seg		;//七段数码管的显示
	output [7:0] o_sel		;
   
	wire [31:0] reg28;
	wire locked;
	wire clk_o1,clk_o2;
	
	
	clk_wiz_0 c(.clk_in1(clk),.reset(rst),.locked(locked),.clk_out1(clk_o1));
	seg7x16 s(.clk(clk),.reset(rst&(~locked)),.cs(1'b1),.i_data(reg28),.o_seg(o_seg),.o_sel(o_sel));
	pipeCPU CPU(.clk(clk_o1),.rst(rst&(~locked)),.reg28(reg28));
endmodule
