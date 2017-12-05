module MEMWB
(
	clk_i,
	mux0_i, mux1_i,
	mux0_o, mux1_o
);

input			clk_i;
input	[31:0]	mux0_i, mux1_i;
output	[31:0]	mux0_o, mux1_o;
reg		[31:0]	mux0_o, mux1_o;

always@(posedge clk_i) begin
	mux0_o <= mux0_i;
	mux1_o <= mux1_i;
end

endmodule