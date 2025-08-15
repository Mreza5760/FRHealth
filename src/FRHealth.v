module FRHealth(Clk, w, cal, g, met, St, Re, Sk, seg_data, seg_sel, BuFreq, LCD_RS, LCD_E, LCD_DATA);
    input Clk, g, St, Re, Sk;
    input [2:0] w;
    input [1:0] cal, met;
    output [7:0] seg_data;
    output [4:0] seg_sel;
    output BuFreq;
    output LCD_RS, LCD_E;
    output [3:0] LCD_DATA;

    reg [1:0] Bu;
    reg [8:0] Cn;
    reg [5:0] Ti;
    reg [3:0] WCn;
    wire StDeb, ReDeb, SkDeb;
    wire ClkFsm, Clk7seg, ClkDeb, ClkLcd, beep500, beep1k, beep2k;

    Debouncer deb1(ClkDeb, St, StDeb),
              deb2(ClkDeb, Re, ReDeb),
              deb3(ClkDeb, Sk, SkDeb);

    FreqDiv freqDiv(Clk, ClkFsm, Clk7seg, ClkDeb, ClkLcd, beep500, beep1k, beep2k);
    FSM fsm(ClkFsm, w, cal, g, met, StDeb, ReDeb, SkDeb, Bu, Cn, Ti, WCn);
    SevenSeg sevenSeg(Clk7seg, Cn[6:0], {1'b0,Ti}, seg_data, seg_sel);
    LcdDisplay lcdDisp(ClkLcd, Cn, Ti, WCn, LCD_RS, LCD_E, LCD_DATA);

    assign BuFreq = (Bu == 2'b00) ? 0 :
                    (Bu == 2'b01) ? beep1k :
                    (Bu == 2'b10) ? beep500 :
                    beep2k;

endmodule
