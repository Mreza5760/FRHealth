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
