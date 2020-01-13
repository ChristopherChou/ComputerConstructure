`timescale 1ns / 1ps

module PipeIF(bpc,cpc,jpc,pc,pcsource,rpc,inst,npc,pc4);
    input [31:0] bpc		;
    input [31:0] cpc		;
    input [31:0] jpc		;
    input [31:0] pc 		;
    input [ 2:0] pcsource 	;
    input [31:0] rpc	  	;
    output [31:0] inst		;
    output [31:0] npc		;
    output [31:0] pc4		;
	
	mux4x32 next_pc(.a(pc4),.b(bpc),.c(rpc),.d(jpc),.pcsource(pcsource[1:0]),.y(npc));
	cla32 pcplus4(.a(pc),.b(32'h4),.sub(1'b0),.s(pc4));
	PipeIMEM imem(.pc(pc),.inst(inst));
endmodule

