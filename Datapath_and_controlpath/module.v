module PIPO1(d_out,d_in,LdA,clk);
    input [15:0] d_in;
    input LdA,clk;
    output reg [15:0] d_out;

    always @(posedge clk)
        if (LdA) d_out <= d_in;
endmodule

module PIPO2(d_out,d_in,LdP,clrP,clk);
    input [15:0] d_in;
    input LdP,clrP,clk;
    output reg [15:0] d_out;

    always @(posedge clk)
        if(clrP)    d_out <= 16'b0;
        else if (LdP) d_out <= d_in;
endmodule

module CNTR(d_out,d_in,LdB,decB,clk);
    input [15:0] d_in;
    input LdB,decB,clk;
    output reg [15:0] d_out;
    always @(posedge clk)
        if(decB) d_out <= d_out -1;
        else if(LdB) d_out <= d_in;
endmodule

module ADDR(d_out,in1,in2);
    input [15:0] in1,in2;
    output reg [15:0] d_out;
    always @(*)
        d_out <= in1 + in2;
endmodule

module COMP(eqz,d_in);
    input [15:0] d_in;
    output eqz;
    assign eqz = (d_in == 0);
endmodule
