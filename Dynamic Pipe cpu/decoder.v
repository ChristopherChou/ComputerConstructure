`timescale 1ns / 1ps
//5位decoder
module decoder(idata,ena,odata);
    input [4:0] idata	;//5位地址可以有32种
    input ena			;//使能信号就是we
    output  [31:0] odata;//出来的结果作为寄存器使能信号，所以高电平
	reg [31:0] tdata=32'h00000000;

    always@(*) 
    begin
        if(ena)
        begin
            tdata<=0;
            tdata[idata]<=1'b1;
        end
    end
assign odata=tdata;
endmodule
