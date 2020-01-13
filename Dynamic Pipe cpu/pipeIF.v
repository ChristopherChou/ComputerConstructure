`timescale 1ns / 1ps
//IF including imem,cla
module pipeIF(bpc,cpc,jpc,pc,pcsource,rpc,inst,npc,pc4);
    input [31:0] bpc		;
    input [31:0] cpc		;
    input [31:0] jpc		;
    input [31:0] pc 		;
    input [ 2:0] pcsource 	;
    input [31:0] rpc	  	;
    output [31:0] inst		;
    output [31:0] npc		;
    output [31:0] pc4		;
	assign pc4=pc+4;
	mux4x32 next_pc(.a(pc4),.b(bpc),.c(rpc),.d(jpc),.pcsource(pcsource[1:0]),.y(npc));
	pipeIMEM imem(.pc(pc),.inst(inst));
endmodule
