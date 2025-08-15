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
