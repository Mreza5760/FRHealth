module  TCalc(w, cal, g, met, T);
    input g;
    input [2:0] w;
    input [1:0] cal, met;
    output [8:0] T;

    wire [8:0] gOut;
    wire [7:0] f1, f2;
    FCalc fc(w, cal, f1);
    assign f2 = f1 + (f1>>3);
    assign gOut = g ? f2 : f1;

    wire [8:0] m1, m2, m3, m4;
    assign m1 = gOut;
    assign m2 = gOut>>1;
    assign m3 = gOut>>2;
    assign m4 = gOut>>3;
    assign T = (met == 2'b00) ? m1 :
                  (met == 2'b01) ? m2 :
                  (met == 2'b10) ? m3 :
                                   m4;

endmodule
