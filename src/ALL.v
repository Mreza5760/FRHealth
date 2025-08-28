module FCalc (w, cal, f);
	input [2:0] w;
	input [1:0] cal;
	output [7:0] f;

	assign f[0] = (~cal[1]&w[1]&w[0]&~w[2]) |
	              (cal[0]&w[1]&~w[0]&~w[2]) |
	              (~cal[0]&~cal[1]&~w[0]&w[2]) |
	              (cal[0]&cal[1]&~w[0]&w[2]) |
	              (~cal[0]&w[1]&w[2]);

	assign f[1] = (~cal[0]&w[0]&~w[1]) |
	              (~cal[0]&~cal[1]&~w[0]&w[1]) |
	              (cal[0]&~cal[1]&w[0]&w[1]) |
	              (cal[0]&~cal[1]&~w[0]&w[2]) |
	              (cal[0]&cal[1]&w[1]&~w[2]) |
	              (~cal[0]&cal[1]&w[0]&w[2]);

	assign f[2] = (~cal[0]&~w[0]&~w[1]&~w[2]) |
	              (~cal[0]&~cal[1]&w[0]&w[1]&~w[2]) |
	              (~cal[1]&w[0]&~w[1]&w[2]) |
	              (cal[0]&~cal[1]&~w[0]&w[1]) |
	              (cal[0]&cal[1]&w[0]&w[1]) |
	              (cal[1]&~w[0]&~w[1]&w[2]) |
	              (cal[0]&cal[1]&w[1]&w[2]) |
	              (~cal[0]&cal[1]&~w[1]&~w[2]) |
				  (cal[0]&~cal[1]&w[0]&~w[1]);

	assign f[3] = (~cal[1]&~w[0]&~w[1]&~w[2]) |
	              (~cal[0]&~cal[1]&~w[0]&w[1]) |
	              (w[0]&~w[1]&w[2]) |
	              (~cal[0]&w[0]&w[2]) |
	              (cal[0]&~cal[1]&w[0]&w[1]&~w[2]) |
	              (cal[0]&cal[1]&w[0]&~w[1]) |
	              (cal[0]&cal[1]&~w[0]&w[1]);

	assign f[4] = (~cal[0]&~w[1]&~w[2]) |
	              (~w[0]&~w[1]&~w[2]) |
	              (w[0]&~w[1]&w[2]) |
	              (~cal[1]&w[1]&w[2]) |
	              (~cal[0]&~w[0]&w[1]&w[2]) |
	              (cal[0]&~cal[1]&~w[0]&~w[2]) |
	              (cal[1]&w[0]&w[1]&~w[2]);

	assign f[5] = (~cal[0]&~cal[1]&~w[2]) |
	              (~w[0]&~w[1]&~w[2]) |
	              (~cal[1]&~w[1]&~w[2]) |
	              (~cal[0]&~w[0]&~w[1]) |
	              (~cal[0]&w[0]&w[1]&~w[2]) |
	              (cal[0]&w[0]&w[2]) |
	              (cal[0]&w[1]&w[2]) |
	              (cal[0]&cal[1]&~w[0]&w[1]);

	assign f[6] = (cal[0]&~cal[1]&~w[0]&~w[1]) |
	              (cal[0]&~cal[1]&~w[2]) |
	              (cal[0]&~w[1]&~w[2]) |
	              (cal[1]&w[0]&w[2]) |
	              (cal[1]&w[1]&w[2]) |
	              (~cal[0]&cal[1]&w[0]&w[1]) |
	              (~cal[0]&cal[1]&w[2]);

	assign f[7] = (cal[0]&cal[1]&~w[0]&~w[1]) |
	              (cal[1]&~w[1]&~w[2]) |
	              (cal[0]&cal[1]&~w[2]) |
	              (cal[1]&~w[0]&w[1]&~w[2]);

endmodule

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

//// //// //// ////

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

//// //// //// ////

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

//// //// //// ////

module FSM(Clk, w, cal, g, met, St, Re, Sk, Bu, Cn, Ti, WCn);
    input [2:0] w;
    input [1:0] cal, met;
    input Clk, g, St, Re, Sk;
    output reg [1:0] Bu;
    output reg [8:0] Cn;
    output reg [5:0] Ti;
    output reg [3:0] WCn;

    wire [8:0] T;
    TCalc tc(w, cal, g, met, T);

    parameter Start = 2'b00,
              Workout = 2'b01,
              Rest = 2'b10;
    reg [1:0] cur, nxt, nexBu;
    reg [8:0] nexCn;
    reg [5:0] nexTi;
    reg [3:0] nexWCn;

    always @(posedge Clk or posedge Re) begin
        if (Re) begin
            Bu <= 2'b00;
            Cn <= T;
            Ti <= 6'd0;
            WCn <= 3'd0;
            cur <= Start;
        end else begin
            Bu <= nexBu;
            Cn <= nexCn;
            Ti <= nexTi;
            WCn <= nexWCn;
            cur <= nxt;
        end
    end

    always @(*) begin
        nexBu = 2'b00;
        nexCn = Cn;
        nexTi = Ti;
        nexWCn = WCn;
        nxt = cur;
        case (cur)
            Start: begin
                if (St) begin
                    nexCn = 9'd1;
                    nexTi = 6'd45;
                    nxt = Workout;
                end
            end
            Workout: begin
                if (Sk) begin
                    if (Cn == T) begin
                        nexBu = 2'b11;
                        nexTi = 6'd0;
                        nexWCn = 3'd0;
                        nxt = Start;
                    end else begin
                        nexBu = 2'b10;
                        nexCn = Cn+1;
                        nexTi = 6'd45;
                        nexWCn = (WCn == 4'd9) ? 4'd0 : WCn + 1;
                    end
                end else if (Ti == 0) begin
                    nexTi = 6'd15;
                    nxt = Rest;
                end else
                    nexTi = Ti-1;
            end
            Rest: begin
                if (Sk) begin
                    if (Cn == T) begin
                        nexBu = 2'b11;
                        nexTi = 6'd0;
                        nexWCn = 3'd0;
                        nxt = Start;
                    end else begin
                        nexBu = 2'b10;
                        nexCn = Cn+1;
                        nexTi = 6'd45;
                        nexWCn = (WCn == 4'd9) ? 4'd0 : WCn + 1;
                        nxt = Workout;
                    end
                end else if (Ti == 0) begin
                    if (Cn == T) begin
                        nexBu = 2'b11;
                        nexTi = 6'd0;
                        nexWCn = 3'd0;
                        nxt = Start;
                    end else begin
                        nexBu = 2'b01;
                        nexCn = Cn+1;
                        nexTi = 6'd45;
                        nnexWCn = (WCn == 4'd9) ? 4'd0 : WCn + 1;
                        nxt = Workout;
                    end
                end else
                    nexTi = Ti-1;
            end
        endcase
    end

endmodule

//// //// //// ////

module SevenSeg(Clk, Cn, Ti, seg_data, seg_sel);
    input Clk;
    input [6:0] Cn, Ti;
    output reg [4:0] seg_sel;
    output reg [7:0] seg_data;

    reg [1:0] digSel = 0;
    reg [3:0] digit;
    wire [3:0] digits[3:0];

    assign digits[0] = Ti % 10;
    assign digits[1] = Ti / 10;
    assign digits[2] = Cn % 10;
    assign digits[3] = Cn / 10;

    always @(posedge Clk)
        digSel <= (digSel + 1)%4;

    always @(*) begin
        case (digSel)
            2'd0: begin
                seg_sel = 5'b00001;
                digit = digits[0];
            end
            2'd1: begin
                seg_sel = 5'b00010;
                digit = digits[1];
            end
            2'd2: begin
                seg_sel = 5'b00100;
                digit = digits[2];
            end
            2'd3: begin
                seg_sel = 5'b01000;
                digit = digits[3];
            end
        endcase

        case (digit)
            4'd0: seg_data = 8'b01111110;
            4'd1: seg_data = 8'b00110000;
            4'd2: seg_data = 8'b01101101;
            4'd3: seg_data = 8'b01111001;
            4'd4: seg_data = 8'b00110011;
            4'd5: seg_data = 8'b01011011;
            4'd6: seg_data = 8'b01011111;
            4'd7: seg_data = 8'b01110000;
            4'd8: seg_data = 8'b01111111;
            4'd9: seg_data = 8'b11111011;
        endcase
    end

endmodule

//// //// //// ////

module LcdController(clk, data_in, rs, send, busy, lcd_rs, lcd_e, lcd_data);
    input clk;
    input reset;
    input [7:0] data_in;
    input rs;
    input send;

    output reg busy;
    output reg lcd_rs;
    output reg lcd_e;
    output reg [3:0] lcd_data;

    reg rs_buf;
    reg [3:0] state;
    reg [7:0] data_buf;

    always @(posedge clk or posedge reset) begin
        case (state)
            0: begin
                if (send) begin
                    busy <= 1;
                    data_buf <= data_in;
                    rs_buf <= rs;
                    state <= 1;
                end
            end
            1: begin
                lcd_rs <= rs_buf;
                lcd_data <= data_buf[7:4];
                lcd_e <= 1;
                state <= 2;
            end
            2: begin
                lcd_e <= 0;
                state <= 3;
            end
            3: begin
                lcd_data <= data_buf[3:0];
                lcd_e <= 1;
                state <= 4;
            end
            4: begin
                lcd_e <= 0;
                busy <= 0;
                state <= 0;
            end
        endcase
    end
endmodule

module LcdDisplay(clkLcd, Cn, Ti, WCn, lcd_rs, lcd_e, lcd_data);
    input clkLcd;
    input [8:0]  Cn;
    input [5:0]  Ti;
    input [3:0]  WCn;

    output lcd_rs;
    output lcd_e;
    output [3:0] lcd_data;

    reg [127:0] exercise_text [0:9];
    reg [127:0] default_text;
    initial begin
        exercise_text[0] = "Lunges,right leg";
        exercise_text[1] = "Lunges,left leg ";
        exercise_text[2] = "    Push-Ups    ";
        exercise_text[3] = "   SquatJumps   ";
        exercise_text[4] = "   TricepDips   ";
        exercise_text[5] = "MountainClimbers";
        exercise_text[6] = "  Plank Ladder  ";
        exercise_text[7] = "  WallSit Hold  ";
        exercise_text[8] = "   Plank Hold   ";
        exercise_text[9] = "     Burpees    ";
        default_text     = "----------------";
    end

    reg [7:0] top_line    [0:15];
    reg [7:0] bottom_line [0:15];
    integer i;

    function [23:0] bin_to_ascii3;
        input [9:0] value;
        reg [3:0] hundreds, tens, ones;
        begin
            hundreds = value / 100;
            tens     = (value % 100) / 10;
            ones     = value % 10;
            bin_to_ascii3 = { (hundreds ? (hundreds+8'd48) : 8'd32),
                              ((hundreds || tens) ? (tens+8'd48) : 8'd32),
                              (ones+8'd48) };
        end
    endfunction

    task update_lines;
        reg [23:0] cn_ascii;
        reg [15:0] ti_ascii;
        reg [127:0] txt;
        begin
            cn_ascii = bin_to_ascii3(Cn);
            ti_ascii = {8'd32, (Ti/10 + 8'd48), (Ti%10 + 8'd48)};

            for (i=0; i<16; i=i+1) begin
                top_line[i]    = " ";
                bottom_line[i] = " ";
            end

            // Top line: "Cn: xxx / Ti: yy"
            top_line[0]  = "C"; top_line[1]  = "n"; top_line[2]  = ":";
            top_line[4]  = cn_ascii[23:16];
            top_line[5]  = cn_ascii[15:8];
            top_line[6]  = cn_ascii[7:0];
            top_line[8]  = "/";
            top_line[10] = "T"; top_line[11] = "i"; top_line[12] = ":";
            top_line[14] = ti_ascii[7:0];
            top_line[15] = ti_ascii[15:8];

            if (WCn < 10)
                txt = exercise_text[WCn];
            else
                txt = default_text;

            for (i=0; i<16; i=i+1)
                bottom_line[i] = txt[127 - i*8 -: 8];
        end
    endtask

    wire busy;
    reg  send;
    reg  rs;
    reg  [7:0] data_in;
    reg  [5:0] pos;
    reg  [1:0] row;

    LcdController lcd_core(clkLcd, data_in, rs, send, busy, lcd_rs, lcd_e, lcd_data);

    always @(posedge clkLcd or posedge reset) begin
        if (!busy) begin
            if (pos == 0) begin
                rs <= 0;
                data_in <= (row == 0) ? 8'h80 : 8'hC0;
                send <= 1;
                pos <= pos + 1;
            end else if (pos <= 16) begin
                rs <= 1;
                data_in <= (row == 0) ? top_line[pos-1] : bottom_line[pos-1];
                send <= 1;
                pos <= pos + 1;
            end else begin
                pos <= 0;
                row <= row ^ 1;
                update_lines();
            end
        end else begin
            send <= 0;
        end
    end
endmodule

//// ///// //// ////

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
