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
