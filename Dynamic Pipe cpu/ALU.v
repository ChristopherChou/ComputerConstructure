`timescale 1ns / 1ps
//ALU
module ALU(a,b,aluc,r,zero,carry,negative,overflow);
    //input &output
    input [31:0] a	;
    input [31:0] b	;
    input [3:0] aluc;
    output[31:0] r	;//result
    output zero		;
    output carry	;
    output negative	;  
    output overflow	;
    //wire&reg
    wire [31:0] d_add;
    wire d_c,d_n,d_o;

    //Adder
    Adder add(aluc,a,b,d_add,d_c,d_n,d_o);

    //
    wire [31:0] d_and=a&b;
    wire [31:0] d_or=a|b;
    wire [31:0] d_xor=a^b;
    wire [31:0] d_nor=~(a|b);
    wire [31:0] d_lui={b[15:0],16'h0};
    wire [31:0] d_slt_s=($signed(a)<$signed(b))?1:0;
    wire d_slt_s_z=(a==b)?1'b1:1'b0;
    wire d_slt_s_n=d_slt_s[0];
    wire [31:0] d_slt_u=(a<b)?1:0;  
    wire d_slt_u_c=d_slt_u[0];
    wire d_slt_u_z=(a==b)?1'b1:1'b0;
    wire [31:0]  sra=$signed(b)>>>a;
    wire [31:0]temp_sra=$signed(b)>>>(a-1);
    wire sra_c=temp_sra[0];
    wire [31:0] sll=$unsigned(b)<<a;
    wire [31:0]temp_sll=$unsigned(b)<<(a-1);
    wire sll_c=temp_sll[31];
    wire [31:0] srl=$unsigned(b)>>a;
    wire [31:0]temp_srl=$unsigned(b)>>>(a-1);
    wire srl_c=temp_srl[0];
    reg [31:0]temp;
    reg tz,tc,to,tn;
    always@(*)
    begin
        if(!{aluc[3],aluc[2]})//0123
        begin
            temp<=d_add;
            tc<=d_c;
            tn<=d_n;
            to<=d_o;
        end
        else if(aluc==4'b0100)
            temp<=d_and;
        else if(aluc==4'b0101)
            temp<=d_or;
        else if(aluc==4'b0110)
            temp<=d_xor;
        else if(aluc==4'b0111)
            temp<=d_nor;
        else if({aluc[3],aluc[2],aluc[1]}==3'b100)
            temp<=d_lui;
        else if(aluc==4'b1011)
            temp<=d_slt_s;
        else if(aluc==4'b1010)
        begin
            temp<=d_slt_u;  
            tc<=d_slt_u_c;    
        end
        else if(aluc==4'b1100)
        begin
            temp<=sra;
            tc<=sra_c;
        end
        else if(aluc==4'b1111||aluc==4'b1110)
        begin
            temp<=sll;
            tc<=sll_c;
        end
        else if(aluc==4'b1101)
        begin
            temp<=srl;
            tc<=srl_c;
        end
    end
   
    assign r=temp;
    assign zero=(aluc==4'b1010)?d_slt_u_z:(aluc==4'b1011)?d_slt_s_z:!r;
    assign overflow=to;
    assign negative=(aluc==4'b0010||aluc==4'b0011)?tn:(aluc==4'b1011)?d_slt_s_n:temp[31];
    assign carry=tc;
endmodule

module Adder(iSA,iData_a,iData_b,oData,carry,negative,overflow);
    //
    input [3:0]iSA		;
    input [31:0] iData_a;
    input [31:0] iData_b;
    output [31:0] oData	;//���λΪ����λ
    output reg carry	;
    output reg negative	;
    output reg overflow ;
    //
    reg signed [31:0] tData=32'h0000_0000;
    reg signed [31:0] ta=32'h0000_0000;
    reg signed [31:0] tb=32'h0000_0000;
    reg signed [31:0] na=32'h0000_0000;
    reg signed [31:0] nb=32'h0000_0000;
    reg t1=1'b0;//���λ��λ
    reg t2=1'b0;//�θ�λ��λ
    reg tC=1'b0;
    reg [31:0] sb=32'h0000_0000;
    
    always@(*)
    begin
        if(iSA[1]==1'b0)//��λΪ0����ʾ�޷��ż���
        begin
            if(iSA[0]==1'b0)//�޷��ż�
            begin
                 tData=iData_a+iData_b;
                 carry=(tData<iData_a||tData<iData_b)?1'b1:1'b0;
            end
            else if(iSA[0]==1'b1)//�޷��ż�
            begin
                  tData=iData_a-iData_b;
                  carry=(iData_a<iData_b)?1'b1:1'b0;
            end
        end   
        else if(iSA[1]==1'b1)//��λΪ1����ʾ�з��ż���
        begin
            ta=$signed(iData_a);
            tb=$signed(iData_b);        
            if(iSA[0]==1'b0)//�з��ż�
            begin
                tData=ta+tb;
                overflow=(ta>0&&tb>0&&tData<=0)||(ta<0&&tb<0&&tData>=0)?1'b1:1'b0;
                negative=tData[31];
            end
            else
            begin
                tData=ta-tb;
                overflow=(ta>0&&tb<0&&tData<=0)||(ta<0&&tb>0&&tData>=0)?1'b1:1'b0;          
                 negative=tData[31];  
            end
        end
    end
 assign oData=tData;
endmodule
