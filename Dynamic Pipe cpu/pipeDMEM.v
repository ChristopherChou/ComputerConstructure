`timescale 1ns / 1ps
//DMEM ip
module pipeDMEM(in,addr,clk,wmem,out);
    input [31:0]in		;
    input [31:0]addr	;
    input clk			;
    input wmem			;
    output [31:0] out	;
    DMEM d(.a(addr),.d(in),.clk(clk),.we(wmem),.spo(out));
endmodule
