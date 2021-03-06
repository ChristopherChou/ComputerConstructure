`timescale 1ns / 1ps

module PipeDEreg(
	input [ 3:0] Daluc              ,
	input [31:0] Da					,//pipeID��Rsout
	input [31:0] Db					,//pipeID��Rsout
	input Dasource					,
	input Dbsource					,
	input [31:0] Dcp0				,
	input [ 4:0] Drn				,//pipeID��rn
	input Dsign						,
	input Dw_dm						,
	input Dw_hi						,
	input Dw_lo						,
	input Dw_rf						,
	input clk						,
	input rst						,
	input wena						,
	input [ 1:0] Dcuttersource		,
	input Ddiv						,
	input [31:0] Dhi				,
	input [ 1:0] Dhisource			,
	input [31:0] Dimm				,
	input DisGoto					,
	input [31:0] Dlo				,
	input [ 1:0] Dlosource			,
	input [31:0] Dpc4				,
	input [ 2:0] Drfsource			,
	output reg [ 1:0] Elosource		,
	output reg [31:0] Epc4			,
	output reg [ 2:0] Erfsource		,
	output reg [ 4:0] Ern			,
	output reg [ 3:0] Ealuc			,
	output reg [31:0] Ea			,
	output reg [31:0] Eb			,
	output reg Easource				,
	output reg Ebsource				,
	output reg [31:0] Ecp0			,
	output reg [ 1:0] Ecuttersource	,
	output reg Ediv					,  
	output reg [31:0] Ehi			,
	output reg [ 1:0] Ehisource		,
	output reg [31:0] Eimm			,
	output reg EisGoto				,
	output reg [31:0] Elo			,
	output reg Esign				,
	output reg Ew_dm				,
	output reg Ew_hi				,
	output reg Ew_lo				,
	output reg Ew_rf				
	);   
	always@(posedge rst or posedge clk)
	begin
		if(rst==1)
		begin
			Elo				<= 0;
			Elosource		<= 0;
			Epc4			<= 0;
			Erfsource		<= 0;
			Ern				<= 0;
			Esign			<= 0;
			Ew_dm			<= 0;
			Ew_hi			<= 0;
			Ew_lo			<= 0;
			Ew_rf			<= 0;	
			Ealuc			<= 0;
			Ea				<= 0;
			Eb				<= 0;
			Easource		<= 0;
			Ebsource		<= 0;
			Ecp0			<= 0;
			Ecuttersource	<= 0;
			Ediv			<= 0;
			Ehi				<= 0;
			Ehisource		<= 0;
			Eimm			<= 0;
			EisGoto			<= 0;	
		end
		else
		begin
			Elo				<= Dlo				;	
			Elosource		<= Dlosource		;	
			Epc4			<= Dpc4				;
			Erfsource		<= Drfsource		;	
			Ern				<= Drn				;	
			Esign			<= Dsign			;	
			Ew_dm			<= Dw_dm			;	
			Ew_hi			<= Dw_hi			;	
			Ew_lo			<= Dw_lo			;	
			Ew_rf			<= Dw_rf			;	
			Ealuc			<= Daluc			;	
			Ea				<= Da				;	
			Eb				<= Db				;	
			Easource		<= Dasource			;
			Ebsource		<= Dbsource			;
			Ecp0			<= Dcp0				;
			Ecuttersource	<= Dcuttersource	;	
			Ediv			<= Ddiv				;
			Ehi				<= Dhi				;	
			Ehisource		<= Dhisource		;	
			Eimm			<= Dimm				;
			EisGoto			<= DisGoto			;			
		end
	end
endmodule  
           