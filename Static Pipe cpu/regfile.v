`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 2018/03/27 15:55:29
// Module Name: regfile
// Project Name: my_static_pipeline_CPU
// Description: 通用寄存器堆，32个32位的寄存器
// Dependencies: regfile(clk,rst,we,raddr1,raddr2,waddr,wdata,rdata1,rdata2);
//               输入 raddr ：rs,rt的地址
//               输入 wdata	：rd
//               输入 waddr	：rdc,rd的地址
//               时钟 clk	：时钟
//               复位 rst	：高电平清理
//               使能 we	：高电平写,低电平读
//               输出 rdata	：输出寄存器堆的两个输出qa,qb
// Revision:0.1 File Created
//////////////////////////////////////////////////////////////////////////////////


module regfile(clk,rst,we,raddr1,raddr2,waddr,wdata,rdata1,rdata2,reg28);
    input clk				;//下降沿写入数据
    input rst				;//高电平全部寄存器置零
    input we				;//高电平可以写，低电平可以读
    input [ 4:0] raddr1		;//读的地址
    input [ 4:0] raddr2		;
    input [ 4:0] waddr		;//写的地址
    input [31:0] wdata		;//写的数据，下降沿写入
    output [31:0] rdata1	;
    output [31:0] rdata2	;
	output [31:0] reg28		;
    wire [31:0] select;
	
    //(* KEEP = "TRUE" *)wire [1023:0]data;
	wire [1023:0]data;
    decoder d(waddr,we,select);//选择
    Reg u0 (.clk(clk),.rst(rst||(!waddr)),.wena(select[0]&&waddr&&we),.data_in(wdata),.data_out(data[0*32+:32]));
    Reg u1 (.clk(clk),.rst(rst),.wena(select[ 1]&&we),.data_in(wdata),.data_out(data[ 1*32+:32]));
    Reg u2 (.clk(clk),.rst(rst),.wena(select[ 2]&&we),.data_in(wdata),.data_out(data[ 2*32+:32]));
    Reg u3 (.clk(clk),.rst(rst),.wena(select[ 3]&&we),.data_in(wdata),.data_out(data[ 3*32+:32]));
    Reg u4 (.clk(clk),.rst(rst),.wena(select[ 4]&&we),.data_in(wdata),.data_out(data[ 4*32+:32]));
    Reg u5 (.clk(clk),.rst(rst),.wena(select[ 5]&&we),.data_in(wdata),.data_out(data[ 5*32+:32]));
    Reg u6 (.clk(clk),.rst(rst),.wena(select[ 6]&&we),.data_in(wdata),.data_out(data[ 6*32+:32]));
    Reg u7 (.clk(clk),.rst(rst),.wena(select[ 7]&&we),.data_in(wdata),.data_out(data[ 7*32+:32]));
                                  
    Reg u8 (.clk(clk),.rst(rst),.wena(select[ 8]&&we),.data_in(wdata),.data_out(data[ 8*32+:32]));
    Reg u9 (.clk(clk),.rst(rst),.wena(select[ 9]&&we),.data_in(wdata),.data_out(data[ 9*32+:32]));
    Reg u10(.clk(clk),.rst(rst),.wena(select[10]&&we),.data_in(wdata),.data_out(data[10*32+:32]));
    Reg u11(.clk(clk),.rst(rst),.wena(select[11]&&we),.data_in(wdata),.data_out(data[11*32+:32]));
    Reg u12(.clk(clk),.rst(rst),.wena(select[12]&&we),.data_in(wdata),.data_out(data[12*32+:32]));
    Reg u13(.clk(clk),.rst(rst),.wena(select[13]&&we),.data_in(wdata),.data_out(data[13*32+:32]));
    Reg u14(.clk(clk),.rst(rst),.wena(select[14]&&we),.data_in(wdata),.data_out(data[14*32+:32]));
    Reg u15(.clk(clk),.rst(rst),.wena(select[15]&&we),.data_in(wdata),.data_out(data[15*32+:32]));
                               
    Reg u16(.clk(clk),.rst(rst),.wena(select[16]&&we),.data_in(wdata),.data_out(data[16*32+:32]));
    Reg u17(.clk(clk),.rst(rst),.wena(select[17]&&we),.data_in(wdata),.data_out(data[17*32+:32]));
    Reg u18(.clk(clk),.rst(rst),.wena(select[18]&&we),.data_in(wdata),.data_out(data[18*32+:32]));
    Reg u19(.clk(clk),.rst(rst),.wena(select[19]&&we),.data_in(wdata),.data_out(data[19*32+:32]));
    Reg u20(.clk(clk),.rst(rst),.wena(select[20]&&we),.data_in(wdata),.data_out(data[20*32+:32]));
    Reg u21(.clk(clk),.rst(rst),.wena(select[21]&&we),.data_in(wdata),.data_out(data[21*32+:32]));
    Reg u22(.clk(clk),.rst(rst),.wena(select[22]&&we),.data_in(wdata),.data_out(data[22*32+:32]));
    Reg u23(.clk(clk),.rst(rst),.wena(select[23]&&we),.data_in(wdata),.data_out(data[23*32+:32]));
                                  
    Reg u24(.clk(clk),.rst(rst),.wena(select[24]&&we),.data_in(wdata),.data_out(data[24*32+:32]));
    Reg u25(.clk(clk),.rst(rst),.wena(select[25]&&we),.data_in(wdata),.data_out(data[25*32+:32]));
    Reg u26(.clk(clk),.rst(rst),.wena(select[26]&&we),.data_in(wdata),.data_out(data[26*32+:32]));
    Reg u27(.clk(clk),.rst(rst),.wena(select[27]&&we),.data_in(wdata),.data_out(data[27*32+:32]));
    Reg u28(.clk(clk),.rst(rst),.wena(select[28]&&we),.data_in(wdata),.data_out(data[28*32+:32]));
    Reg u29(.clk(clk),.rst(rst),.wena(select[29]&&we),.data_in(wdata),.data_out(data[29*32+:32]));
    Reg u30(.clk(clk),.rst(rst),.wena(select[30]&&we),.data_in(wdata),.data_out(data[30*32+:32]));
    Reg u31(.clk(clk),.rst(rst),.wena(select[31]&&we),.data_in(wdata),.data_out(data[31*32+:32]));

    selector s1(clk,data,raddr1,rdata1);
    selector s2(clk,data,raddr2,rdata2);  
	assign reg28=data[28*32+:32];
endmodule

