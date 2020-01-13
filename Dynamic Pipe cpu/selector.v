`timescale 1ns / 1ps
//5*32选择
module selector(clk,idata,raddr,rdata);
    input clk			;
    input [1023:0]idata	;
    input [   4:0]raddr	;//5位地址选择线
    output [31:0] rdata ;//读出31位数据
    assign rdata=idata[raddr*32+:32];
endmodule
