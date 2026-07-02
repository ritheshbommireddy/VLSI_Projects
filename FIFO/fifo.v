`define FWIDTH 32 
`define FDEPTH 4
`define FCWIDTH 2
module FIFO(clk,RstN,Data_in,InN,clrN,OutN,F_data,F_FullN,F_EmptyN,F_LastN,F_SLastN,F_firstN);
input clk,RstN,InN,clrN,OutN;
input [`FWIDTH-1:0] Data_in;
output [`FWIDTH-1:0] F_data;
output reg F_FullN,F_EmptyN,F_LastN,F_SLastN,F_firstN;

reg [`FCWIDTH-1:0] fcounter;
reg [`FCWIDTH-1:0] rdptr;
reg [`FCWIDTH-1:0] wrptr;
wire [`FWIDTH-1:0] FIFODataOut;
wire [`FWIDTH-1:0] FIFODataIn;

wire readN = OutN;
wire writeN = InN;

assign F_data = FIFODataOut;
assign FIFODataIn = Data_in;

FIFOMemBlock FIFO1(clk,writeN,readN,F_EmptyN,wrptr,rdptr,FIFODataIn,FIFODataOut);

always @(posedge clk or negedge RstN)
begin
    if(!RstN)begin
        fcounter <= 0;
        rdptr <= 0;
        wrptr <= 0;
    end
    else begin
        if(!clrN) begin
            fcounter <= 0;
            rdptr <= 0;
            wrptr <= 0;
        end
    
    else begin
        if(!writeN)
            wrptr <= wrptr + 1;
        if(!readN)
            rdptr <= rdptr + 1;
        if(!writeN && readN && F_FullN)
            fcounter <= fcounter + 1;
        else if (writeN && !readN && F_EmptyN)
            fcounter <= fcounter + 1; 
    end
end
end

always @(posedge clk or negedge RstN)
begin
    if(!RstN)
        F_EmptyN <= 1'b0;
    else begin
        if(clrN == 1'b1) begin
            if(F_EmptyN == 1'b0 && writeN == 1'b0)
                F_EmptyN <= 1'b1;
            else if (F_firstN == 1'b0 && readN == 1'b0 && writeN == 1'b1)
                F_EmptyN <= 1'b0;  
        end
        else 
            F_EmptyN <= 1'b0;
    end 
end

always @(posedge clk or negedge RstN)
begin
    if(!RstN)
        F_firstN <= 1'b1;
    else begin
        if(clrN == 1'b1) begin
            if((F_EmptyN == 1'b0 && writeN == 1'b0) || (fcounter == 2 && readN == 1'b0 && writeN == 1'b1))
                F_firstN <= 1'b0;

            else if (F_firstN == 1'b0 && (readN ^ writeN))
                F_firstN <= 1'b1;     
        end
        else begin
            F_firstN <= 1'b1;
        end
    end 
end

always @(posedge clk or negedge RstN)
begin
    if(!RstN)
        F_SLastN <= 1'b1;
    else begin
        if(clrN == 1'b1) begin
            if((F_LastN==1'b0 && readN==1'b0 && writeN==1'b1) || (fcounter == (`FDEPTH-3) && writeN == 1'b0 && readN == 1'b1))
                F_SLastN <= 1'b0;
            else if(F_SLastN == 1'b0 && (readN ^ writeN))
                F_SLastN <= 1'b1;
        end
        else 
            F_SLastN <= 1'b1;
    end 
end

always @(posedge clk or negedge RstN)
begin
    if(!RstN)
        F_LastN <= 1'b1;
        else begin
            if(clrN==1'b1)begin
                if((F_FullN==1'b0 && readN == 1'b0) || (fcounter == (`FDEPTH-2) && writeN==1'b0 && readN==1'b1))
                    F_LastN <= 1'b0;
                else if(F_LastN == 1'b0 && (readN ^ writeN))
                    F_LastN <= 1'b1;
            end
            else F_LastN <= 1'b1;
        end 
end

always @(posedge clk or negedge RstN)
begin
    if(!RstN)
        F_FullN <= 1'b1;
    else begin
        if(clrN == 1'b1) begin
            if(F_LastN == 1'b0 && writeN==1'b0 && readN==1'b1)
                F_FullN <= 1'b0;
            else if (F_FullN == 1'b0 && readN == 1'b0)
                F_FullN <= 1'b1;     
        end
        else F_FullN <= 1'b1;
    end
end
endmodule   