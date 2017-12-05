module MEMWB
(
	clk_i,
	mux0_i, mux1_i,
	mux0_o, mux1_o,
	RegWrite_i, MemtoReg_i,
	RegWrite_o, MemtoReg_o
);

input			clk_i;
input	[31:0]	mux0_i, mux1_i;
output	[31:0]	mux0_o, mux1_o;
reg		[31:0]	mux0_o, mux1_o;

input			RegWrite_i, MemtoReg_i;
output			RegWrite_o, MemtoReg_o;
reg   			RegWrite_o, MemtoReg_o;

always@(posedge clk_i) begin
	mux0_o <= mux0_i;
	mux1_o <= mux1_i;
	RegWrite_o <= RegWrite_i;
	MemtoReg_o <= MemtoReg_i;
end

endmodule