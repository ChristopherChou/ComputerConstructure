`timescale 1ns / 1ps
module decoder(idata,ena,odata);
    input ena			;
    input [4:0] idata	;//5位地址可以有32种
    output  [31:0] odata;

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