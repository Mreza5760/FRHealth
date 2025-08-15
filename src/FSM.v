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
