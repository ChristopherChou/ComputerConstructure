`timescale 1ns / 1ps
//IF/ID�����ˮ�Ĵ���
//���ڴ��ȡ����ָ�ִ��pc+4�Ĳ���

module PipeIR(clk,pc4,inst,nostall,rst,Dinst,Dpc4);
    input clk			;//ʱ��
	input [31:0] pc4	;//pc+4
    input [31:0] inst	;//ָ��
    input nostall		;//�Ƿ��
    input rst			;//��λ�ź�
    output [31:0] Dinst;//���ָ��
    output [31:0] Dpc4 ;//���pc+4
	Reg pcplus4(.data_in(pc4),.clk(clk),.rst(rst),.wena(nostall),.data_out(Dpc4));
	Reg instruction(.data_in(inst),.clk(clk),.rst(rst),.wena(nostall),.data_out(Dinst));
endmodule
