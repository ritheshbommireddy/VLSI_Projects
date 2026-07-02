module FIFOMemBlock(clk,writeN,readN,emptyN,wr_addr,rd_addr,data_in,data_out);
input clk, writeN,readN,emptyN;
input [`FCWIDTH-1:0] wr_addr,rd_addr;
input [`FWIDTH-1:0] data_in;
output [`FWIDTH-1:0] data_out;

reg [`FWIDTH-1:0] FIFO[`FDEPTH-1:0];

assign data_out =  (!readN && emptyN) ? FIFO[rd_addr] : 32'bx;
always @(posedge clk)
begin
    if(writeN == 1'b0)
        FIFO[wr_addr] <= data_in;
end
endmodule