module FreqDiv(input Clk, output ClkFsm, output Clk7seg, output ClkDeb, output ClkLcd, output beep500, output beep1k, output Beep2k);

    reg [22:0] cntDeb = 0;
    reg [25:0] cntFsm = 0;
    reg [15:0] cnt7seg = 0, cntLcd = 0, cnt500 = 0, cnt1k = 0, cnt2k = 0;

    always @(posedge Clk) begin
        cntFsm <= cnt1Hz + 1;
        if (cntFsm == 20_000_000) begin
            ClkFsm <= ~ClkFsm;
            cntFsm <= 0;
        end

        cnt7seg <= cnt7seg + 1;
        if (cnt7seg == 80_000) begin
            Clk7seg <= ~Clk7seg;
            cnt7seg <= 0;
        end

        cntDeb <= cntDeb + 1;
        if (cntDeb == 400_000) begin
            ClkDeb <= ~ClkDeb;
            cntDeb <= 0;
        end

        cntLcd <= cntLcd + 1;
        if (cntLcd == 20_000) begin
            ClkLcd <= ~ClkLcd;
            cntLcd <= 0;
        end

        cnt500 <= cnt500 + 1;
        if (cnt500 == 40_000) begin
            beep500 <= ~beep500;
            cnt500 <= 0;
        end

        cnt1k <= cnt1k + 1;
        if (cnt1k == 20_000) begin
            beep1k <= ~beep1k;
            cnt1k <= 0;
        end

        cnt2k <= cnt2k + 1;
        if (cnt2k == 10_000) begin
            beep2k <= ~beep2k;
            cnt2k <= 0;
        end
    end

endmodule
