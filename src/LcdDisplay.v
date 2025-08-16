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
