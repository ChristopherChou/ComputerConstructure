`timescale 1ns / 1ps
//4选1
module mux4x32 (a,b,c,d,pcsource,y);
	input [31:0] a,b,c,d; 
	input [1:0]pcsource; 
	output [31:0] y; 
	assign y = pcsource==2'b00 ? a :
	           pcsource==2'b01 ? b :
	           pcsource==2'b10 ? c :
	           pcsource==2'b11 ? d :0;
endmodule 

