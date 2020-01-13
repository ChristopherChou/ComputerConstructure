`timescale 1ns / 1ps
//ͨ�üĴ���ģ��
module Reg(
    input clk,//ʱ��������ΪPC�Ĵ�����ֵ
    input rst,//�ߵ�ƽ����
    input wena,//1λ���룬д�ź�
    input [31:0] data_in,//32λ����
    output reg [31:0] data_out //32λ���������ʱ���PC�Ĵ�����ֵ
);
always @(posedge clk,posedge rst)
    if(rst)
        data_out<=0;
    else if(wena)
        data_out<=data_in;
endmodule