module DFF(input Clk, input D, output Q);
    reg Q;
    always @(posedge Clk)
        Q <= D;
endmodule

module Debouncer(input Clk, input Sig, output Deb);
    DFF dff1(Clk, Sig, Q0),
        dff2(Clk, Q0, Q1),
        dff3(Clk, Q1, Q2);

    assign Deb = Q0 & Q1 & ~Q2;

endmodule
