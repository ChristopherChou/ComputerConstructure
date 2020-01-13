`timescale 1ns / 1ps

module Adder(iSA,iData_a,iData_b,oData,carry,negative,overflow);
    output [31:0] oData	;//最高位为符号位
    output reg carry	;
    output reg negative	;
    output reg overflow ;
     input [3:0]iSA		;//两位
    input [31:0] iData_a;
    input [31:0] iData_b;
	
	reg signed [31:0] na=32'h0000_0000;
    reg signed [31:0] tData=32'h0000_0000;
    reg signed [31:0] tb=32'h0000_0000;
    reg t1=1'b0;//最高位进位
    reg t2=1'b0;//次高位进位
    reg tC=1'b0;
    reg [31:0] sb=32'h0000_0000;
    reg signed [31:0] ta=32'h0000_0000;
    reg signed [31:0] nb=32'h0000_0000;
    always@(*)
    begin
        if(iSA[1]==1'b0)//高位为0，表示无符号计算
        begin
            if(iSA[0]==1'b0)//无符号加
            begin
                 tData=iData_a+iData_b;
                 carry=(tData<iData_a||tData<iData_b)?1'b1:1'b0;
            end
            else if(iSA[0]==1'b1)//无符号减
            begin
            carry=(iData_a<iData_b)?1'b1:1'b0;
            tData=iData_a-iData_b;
            end
        end   
        else if(iSA[1]==1'b1)//高位为1，表示有符号计算
        begin
            ta=$signed(iData_a);
            tb=$signed(iData_b);        
            if(iSA[0]==1'b0)//有符号加
            begin
                tData=ta+tb;
                negative=tData[31];
                overflow=(ta>0&&tb>0&&tData<=0)||(ta<0&&tb<0&&tData>=0)?1'b1:1'b0;
            end
            else
            begin
                tData=ta-tb;
                negative=tData[31];  
                overflow=(ta>0&&tb<0&&tData<=0)||(ta<0&&tb>0&&tData>=0)?1'b1:1'b0;          
            end
        end
    end
 assign oData=tData;
endmodule
