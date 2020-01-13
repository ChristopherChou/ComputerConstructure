`timescale 1ns / 1ps

module pipeIDcu(op1,op2,op,func,rd,zero,
				EisGoto,
				Ew_rf,Mw_rf,
				Ern,Mrn,
				Erfsource,Mrfsource,
				isGoto,
				aluc,asource,bsource,
				pcsource,rfsource,
				w_dm,w_rf,reg_rt,
				sext,stall,
				fwda,fwdb,
				delay);

	input EisGoto			;
	input Ew_rf				;
	input Mw_rf				;
	input [4:0]Ern			;
	input [4:0] op1	   		;//第一个操作数，即rs
	input [4:0] op2	   		;//第二个操作数，即rt
	input [5:0] op	   		;
	input [5:0] func   		;
	input [4:0] rd			;
	input zero				;//rs,rt相等
	input [4:0]Mrn			;
	input [2:0] Erfsource	;
	input [2:0] Mrfsource	;
	output isGoto			;
	output [3:0] aluc		;//aluc的选择信号
	output asource			;
	output bsource			;
	output [2:0] pcsource	;//pc的五选一选择信号
	output [2:0] rfsource	;
	output w_dm				;
	output w_rf				;
	output reg_rt			;
	output sext				;//是否符号扩展
	output stall			;
	output reg [1:0] fwda	;
	output reg [1:0] fwdb	;
	output delay			;
	//31条指令译码
	wire r_type=~|op;
	wire i_addi = ~op[5] & ~op[4] &  op[3] & ~op[2] & ~op[1] & ~op[0];
	wire i_addiu= ~op[5] & ~op[4] &  op[3] & ~op[2] & ~op[1] &  op[0];
	wire i_andi = ~op[5] & ~op[4] &  op[3] &  op[2] & ~op[1] & ~op[0];
	wire i_ori  = ~op[5] & ~op[4] &  op[3] &  op[2] & ~op[1] &  op[0];
	wire i_xori = ~op[5] & ~op[4] &  op[3] &  op[2] &  op[1] & ~op[0];
	wire i_lw   =  op[5] & ~op[4] & ~op[3] & ~op[2] &  op[1] &  op[0];
	wire i_sw   =  op[5] & ~op[4] &  op[3] & ~op[2] &  op[1] &  op[0];
	wire i_beq  = ~op[5] & ~op[4] & ~op[3] &  op[2] & ~op[1] & ~op[0];
	wire i_bne  = ~op[5] & ~op[4] & ~op[3] &  op[2] & ~op[1] &  op[0];
	wire i_slti = ~op[5] & ~op[4] &  op[3] & ~op[2] &  op[1] & ~op[0];
    wire i_sltiu= ~op[5] & ~op[4] &  op[3] & ~op[2] &  op[1] &  op[0];
	wire i_lui  = ~op[5] & ~op[4] &  op[3] &  op[2] &  op[1] &  op[0];
	wire i_j    = ~op[5] & ~op[4] & ~op[3] & ~op[2] &  op[1] & ~op[0];
	wire i_jal  = ~op[5] & ~op[4] & ~op[3] & ~op[2] &  op[1] &  op[0];
    wire i_sll  = r_type & ~func[5] & ~func[4] & ~func[3] &~func[2] & ~func[1] & ~func[0];
	wire i_srl  = r_type & ~func[5] & ~func[4] & ~func[3] &~func[2] &  func[1] & ~func[0];
	wire i_sra  = r_type & ~func[5] & ~func[4] & ~func[3] &~func[2] &  func[1] &  func[0];
	wire i_sllv = r_type & ~func[5] & ~func[4] & ~func[3] & func[2] & ~func[1] & ~func[0];
    wire i_srlv = r_type & ~func[5] & ~func[4] & ~func[3] & func[2] &  func[1] & ~func[0];
    wire i_srav = r_type & ~func[5] & ~func[4] & ~func[3] & func[2] &  func[1] &  func[0];
	wire i_jr   = r_type & ~func[5] & ~func[4] &  func[3] &~func[2] & ~func[1] & ~func[0];
	 wire i_add  = r_type &  func[5] & ~func[4] & ~func[3] &~func[2] & ~func[1] & ~func[0];
    wire i_addu = r_type &  func[5] & ~func[4] & ~func[3] &~func[2] & ~func[1] &  func[0];
	wire i_sub  = r_type &  func[5] & ~func[4] & ~func[3] &~func[2] &  func[1] & ~func[0];
	wire i_subu = r_type &  func[5] & ~func[4] & ~func[3] &~func[2] &  func[1] &  func[0];
	wire i_and  = r_type &  func[5] & ~func[4] & ~func[3] & func[2] & ~func[1] & ~func[0];
	wire i_or   = r_type &  func[5] & ~func[4] & ~func[3] & func[2] & ~func[1] &  func[0];
	wire i_xor  = r_type &  func[5] & ~func[4] & ~func[3] & func[2] &  func[1] & ~func[0];
    wire i_nor  = r_type &  func[5] & ~func[4] & ~func[3] & func[2] &  func[1] &  func[0];
    wire i_slt  = r_type &  func[5] & ~func[4] &  func[3] &~func[2] &  func[1] & ~func[0];
    wire i_sltu = r_type &  func[5] & ~func[4] &  func[3] &~func[2] &  func[1] &  func[0];
	//54指令译码
    wire i_eret   = c0_type& op1[4]&~op1[3] &~op1[2]&~op1[1]&~op1[0]&~func[5]& func[4] & func[3]&~func[2] & ~func[1] & ~func[0];
	 wire c0_type  = ~op[5] &  op[4] & ~op[3] & ~op[2] & ~op[1] & ~op[0];
    wire i_mfc0   = c0_type&~op1[4]&~op1[3] &~op1[2]&~op1[1]&~op1[0];
    wire i_mtc0   = c0_type&~op1[4]&~op1[3] & op1[2]&~op1[1]&~op1[0];
    wire i_divu     = r_type & ~func[5] &  func[4] &  func[3] &~func[2] &  func[1] &  func[0];
    wire i_div      = r_type & ~func[5] &  func[4] &  func[3] &~func[2] &  func[1] & ~func[0];  
    wire i_multu    = r_type & ~func[5] &  func[4] &  func[3] &~func[2] & ~func[1] &  func[0];
    wire i_mfhi     = r_type & ~func[5] &  func[4] & ~func[3] &~func[2] & ~func[1] & ~func[0];
    wire i_mflo     = r_type & ~func[5] &  func[4] & ~func[3] &~func[2] &  func[1] & ~func[0];
    wire i_mthi     = r_type & ~func[5] &  func[4] & ~func[3] &~func[2] & ~func[1] &  func[0];
    wire i_mtlo     = r_type & ~func[5] &  func[4] & ~func[3] &~func[2] &  func[1] &  func[0]; 
	wire i_syscall= r_type & ~func[5] & ~func[4] &  func[3] & func[2] & ~func[1] & ~func[0];
    wire i_break  = r_type & ~func[5] & ~func[4] &  func[3] & func[2] & ~func[1] &  func[0];
    wire i_teq    = r_type &  func[5] &  func[4] & ~func[3] & func[2] & ~func[1] & ~func[0];
    wire i_jalr   = r_type & ~func[5] & ~func[4] &  func[3] &~func[2] & ~func[1] &  func[0]; 
	 wire i_lb       = op[5] & ~op[4] & ~op[3] & ~op[2] & ~op[1] & ~op[0];
    wire i_lbu      = op[5] & ~op[4] & ~op[3] &  op[2] & ~op[1] & ~op[0];
    wire i_lh       = op[5] & ~op[4] & ~op[3] & ~op[2] & ~op[1] &  op[0];
    wire i_lhu      = op[5] & ~op[4] & ~op[3] &  op[2] & ~op[1] &  op[0];
    wire i_sb       = op[5] & ~op[4] &  op[3] & ~op[2] & ~op[1] & ~op[0];
    wire i_sh       = op[5] & ~op[4] &  op[3] & ~op[2] & ~op[1] &  op[0];
    wire i_clz      =~op[5] &  op[4] &  op[3] &  op[2] & ~op[1] & ~op[0]&  func[5] & ~func[4] & ~func[3] &~func[2] & ~func[1] & ~func[0];
    wire i_mul      =~op[5] &  op[4] &  op[3] &  op[2] & ~op[1] & ~op[0]& ~func[5] & ~func[4] & ~func[3] &~func[2] &  func[1] & ~func[0];
    wire i_bgez     =~op[5] & ~op[4] & ~op[3] & ~op[2] & ~op[1] &  op[0]&  ~op2[4] & ~op2[3]  & ~op2[2]  &~op2[1]  & op2[0];
    //**********************************************************************************

	assign pcsource[2]=1'b0;
    assign pcsource[1]=i_jr|i_j|i_jal|i_jalr;
    assign pcsource[0]=(i_beq&zero)|(i_bne&~zero)|i_j|i_jal;
	assign aluc[0]=i_sub|i_subu|i_or|i_nor|i_slt|i_srl|i_srlv|i_ori|i_beq|i_bne|i_slti|i_clz|i_bgez;
    assign aluc[1]=i_add|i_sub|i_xor|i_nor|i_slt|i_sltu|i_sll|i_sllv|i_addi|i_xori|i_lw|i_sw|i_slti|i_sltiu|i_clz|i_lb|i_lbu|i_sb|i_lh|i_lhu|i_sh;
    assign aluc[2]=i_and|i_or|i_xor|i_nor|i_sll|i_srl|i_sra|i_sllv|i_srlv|i_srav|i_andi|i_ori|i_xori|i_clz;
    assign aluc[3]=i_slt|i_sltu|i_sll|i_srl|i_sra|i_sllv|i_srlv|i_srav|i_slti|i_sltiu|i_lui|i_clz|i_bgez;
	assign delay =(i_beq&zero)|(i_bne&~zero);
	assign isGoto = i_jal;
	
	assign rfsource[2]=1'b0;
	assign rfsource[1]=1'b0;
	assign rfsource[0]=i_lw|i_lb|i_lbu|i_lh|i_lhu;
	
	assign asource=i_sll|i_srl|i_sra;
	assign bsource=i_addi|i_andi|i_ori|i_xori|i_lw|i_lui|i_sw;

    assign sext=((i_addi|i_addiu)|(i_slti|i_sltiu))|((i_lui|i_lw)|i_sw)|i_lh|i_lb|i_sh|i_sb|i_lbu|i_lhu|i_beq|i_bne;
	
	wire i_rs= i_add | i_sub | i_and | i_or | i_xor | i_jr | i_addi|
			   i_andi| i_ori | i_xori| i_lw | i_sw  | i_beq| i_bne ;
    wire i_rt= i_add | i_sub | i_and | i_or | i_xor | i_sll | i_srl|
			   i_sra | i_sw  | i_beq | i_bne ;
	
	assign w_dm=(i_sw|i_sb|i_sh)&(~stall);
	assign w_rf=(i_add|i_addu|i_sub|i_subu|i_and|i_or|i_xor|i_nor|
				i_slt|i_sltu||i_sll|i_srl|i_sra|i_sllv|i_srlv|i_srav|
				i_jr|i_addi|i_addiu|i_andi|i_ori|i_xori|i_lw|i_slti|
				i_sltiu|i_lui|i_jal|i_mfc0|i_mfhi|i_mflo|i_jalr|i_clz|
				i_lb|i_lbu|i_lh|i_lhu|i_mul)&(~stall);
	assign reg_rt=(((i_addi|i_addiu)|(i_andi|i_ori))|((i_xori|i_lw)|(i_sw|i_beq)))|
				  ((i_bne|i_slti)|(i_sltiu|i_lui))|i_lh|i_lhu|i_lb|i_lbu|i_sh|i_sb|i_mfc0;
	//i_addi|i_lw|i_sw|
	assign stall = (Ew_rf & Erfsource[0] & (Ern!=0) & ((i_rs&(Ern==op1)) | (i_rt&(Ern==op2))));
	
	//assign fwda=()
	
	
	always@(Ew_rf or Mw_rf or Ern or Mrn or Erfsource[0] or Mrfsource[0] or op1 or op2)
	begin
		fwda=2'b00;
		if(Ew_rf&(Ern!=0)&(Ern==op1)&~Erfsource[0])
		begin
			fwda=2'b01;//选择Ealu的结果
		end
		else
		begin
			if(Mw_rf&(Mrn!=0)&(Mrn==op1)&~Mrfsource[0])
			begin
				fwda=2'b10;
			end
			else
			begin
				if(Mw_rf&(Mrn!=0)&(Mrn==op1)&Mrfsource[0])
				begin
				fwda=2'b11;
				end
			end
		end
		fwdb=2'b00;
		if(Ew_rf&(Ern!=0)&(Ern==op2)&~Erfsource[0])
		begin
			fwdb=2'b01;//选择Ealu的结果
		end
		else
		begin
			if(Mw_rf&(Mrn!=0)&(Mrn==op2)&~Mrfsource[0])
			begin
				fwdb=2'b10;
			end
			else
			begin
				if(Mw_rf&(Mrn!=0)&(Mrn==op2)&Mrfsource[0])
				begin
				fwdb=2'b11;
				end
			end
		end	
	end
    
   
endmodule