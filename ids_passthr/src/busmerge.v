// Bus merge 

module busmerge(
	input [47:0] da,	// high-bit
	input [63:0] db,	// lower-bit
	output [111:0] q
);

	assign q = {da, db};

endmodule 