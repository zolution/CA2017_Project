module MEMWB
(
	clk_i,
	mux0_i, mux1_i,
	mux0_o, mux1_o,
	RegWrite_i, MemtoReg_i,
	RegWrite_o, MemtoReg_o,
	WriteBackPath_i, WriteBackPath_o,
	stall_i
);

input				clk_i;
input		[31:0]	mux0_i, mux1_i;
output	reg	[31:0]	mux0_o = 32'b0, mux1_o = 32'b0;

// Control signal
input			RegWrite_i, MemtoReg_i;
output	reg		RegWrite_o = 1'b0, MemtoReg_o = 1'b0;

// Write path
input		[4:0]	WriteBackPath_i;
output 	reg	[4:0]	WriteBackPath_o = 5'b0;

always@(posedge clk_i && ~stall_i) begin
	mux0_o <= mux0_i;
	mux1_o <= mux1_i;
	// Control signal
	RegWrite_o <= RegWrite_i;
	MemtoReg_o <= MemtoReg_i;
	// Writeback path
	WriteBackPath_o <= WriteBackPath_i;
end

endmodule
