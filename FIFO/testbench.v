`timescale 1ns/1ps

`define FWIDTH 32
`define FDEPTH 4
`define FCWIDTH 2

module FIFO_tb;

    reg clk;
    reg RstN;
    reg InN;
    reg clrN;
    reg OutN;
    reg [`FWIDTH-1:0] Data_in;

    wire [`FWIDTH-1:0] F_data;
    wire F_FullN;
    wire F_EmptyN;
    wire F_LastN;
    wire F_SLastN;
    wire F_firstN;

    FIFO dut (
        .clk(clk),
        .RstN(RstN),
        .Data_in(Data_in),
        .InN(InN),
        .clrN(clrN),
        .OutN(OutN),
        .F_data(F_data),
        .F_FullN(F_FullN),
        .F_EmptyN(F_EmptyN),
        .F_LastN(F_LastN),
        .F_SLastN(F_SLastN),
        .F_firstN(F_firstN)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("fifo_tb.vcd");
        $dumpvars(0, FIFO_tb);

        clk = 0;
        RstN = 0;
        clrN = 1;
        InN = 1;
        OutN = 1;
        Data_in = 0;

        #20;
        RstN = 1;

        // Write first data
        #10;
        Data_in = 32'hAAAA_0001;
        InN = 0;
        OutN = 1;

        #10;
        InN = 1;

        // Write second data
        #10;
        Data_in = 32'hBBBB_0002;
        InN = 0;

        #10;
        InN = 1;

        // Write third data
        #10;
        Data_in = 32'hCCCC_0003;
        InN = 0;

        #10;
        InN = 1;

        // Write fourth data
        #10;
        Data_in = 32'hDDDD_0004;
        InN = 0;

        #10;
        InN = 1;

        // Read first data
        #10;
        OutN = 0;
        InN = 1;

        #10;
        OutN = 1;

        // Read second data
        #10;
        OutN = 0;

        #10;
        OutN = 1;

        // Simultaneous read and write
        #10;
        Data_in = 32'hEEEE_0005;
        InN = 0;
        OutN = 0;

        #10;
        InN = 1;
        OutN = 1;

        // Clear FIFO
        #10;
        clrN = 0;

        #10;
        clrN = 1;

        // Write after clear
        #10;
        Data_in = 32'h1234_5678;
        InN = 0;
        OutN = 1;

        #10;
        InN = 1;

        // Read after clear
        #10;
        OutN = 0;

        #10;
        OutN = 1;

        #50;
        $finish;
    end

    initial begin
        $monitor("Time=%0t RstN=%b clrN=%b InN=%b OutN=%b Data_in=%h F_data=%h FullN=%b EmptyN=%b LastN=%b SLastN=%b FirstN=%b",
                 $time, RstN, clrN, InN, OutN, Data_in, F_data,
                 F_FullN, F_EmptyN, F_LastN, F_SLastN, F_firstN);
    end

endmodule