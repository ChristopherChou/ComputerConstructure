`timescale 1ns / 1ps

module mux2x32(a,b,s,y);
	input [31:0] a,b; 
	input s; 
	output [31:0] y; 
	assign y = s==1'b0 ? a : s==1'b1 ? b :1'b0;
endmodule
