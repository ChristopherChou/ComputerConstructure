`timescale 1ns / 1ps
//通用寄存器模块
module Reg(
    input clk,//时钟上升沿为PC寄存器赋值
    input rst,//高电平重置
    input wena,//1位输入，写信号
    input [31:0] data_in,//32位输入
    output reg [31:0] data_out //32位输出，工作时输出PC寄存器的值
);
always @(posedge clk,posedge rst)
    if(rst)
        data_out<=0;
    else if(wena)
        data_out<=data_in;
endmodule