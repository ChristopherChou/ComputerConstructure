`timescale 1ns / 1ps
//tb
module pipeline_CPU_tb();
	reg clk;
	reg rst;
	wire [31:0] pc;
	wire [31:0] inst;
	wire [31:0] ealu;
	wire [31:0] malu;
	wire [31:0] walu;
	wire [31:0] reg28;
	
	//integer cnt;
	initial
	begin
	//	cnt=0;
		// fp_w = $fopen("test_result_my_lbu.txt", "w");  
		clk=0;
		rst=1;
		#1
		rst=0;
	end
	
	initial
	begin
		forever
		begin
			#10 clk=~clk;
		end
	end
	pipeCPU CPU(.clk(clk),.rst(rst),.reg28(reg28),
	._inst(inst),._ealu(ealu),._malu(malu),._walu(walu),
	._pc(pc));

endmodule
