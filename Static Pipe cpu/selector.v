`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2018/03/27 16:19:05
// Module Name: selector
// Project Name: my_static_pipeline_CPU
// Description: 5x32������
// Dependencies: decoder(idata,ena,odata);
//               ���� idata ��5λ�ĵ�ַ
//               ���� ena	��ʹ���źţ�we
//               ��� odata	�����32λ����
// Revision:0.1 File Created
//////////////////////////////////////////////////////////////////////////////////



module selector(clk,idata,raddr,rdata);
    input clk			;
    input [1023:0]idata	;
    input [   4:0]raddr	;//5λ��ַѡ����
    output [31:0] rdata ;//����31λ����
    assign rdata=idata[raddr*32+:32];
  
endmodule
