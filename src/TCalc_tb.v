`timescale 1ns / 1ps
module TCalc_tb();
    integer fin, fout, tmp, i = 0;

    reg [2:0] w;
    reg [1:0] cal, met;
    reg g;
    wire [8:0] T;

    TCalc uut (
        .w(w),
        .cal(cal),
        .g(g),
        .met(met),
        .T(T)
    );

    initial begin
        fin  = $fopen("input.txt", "r");
        fout = $fopen("output.txt", "w");

        if (fin == 0) begin
            $display("ERROR: Could not open input.txt");
            $finish;
        end
        if (fout == 0) begin
            $display("ERROR: Could not open output.txt");
            $finish;
        end

        while (!$feof(fin)) begin
            tmp = $fscanf(fin, "%8b\n", {w, cal, met, g});
            i = i + 1;

            #5;

            $fdisplay(fout,
                "line = %0d : w=%0d, cal=%0d, met=%0d, g=%0d -> T=%0d",
                i, w, cal, met, g, T
            );
        end

        $fclose(fin);
        $fclose(fout);

        $finish;
    end
endmodule