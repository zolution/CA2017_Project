// TODO: remove pc 
module EXMEM
(
	clk_i,
	pc_i, ALUres_i, wrdata_i,
	pc_o, ALUres_o, wrdata_o,
	MemRead_i, MemWrite_i, RegWrite_i, MemtoReg_i,
	MemRead_o, MemWrite_o, RegWrite_o, MemtoReg_o,
	WriteBackPath_i, WriteBackPath_o
);

input					clk_i;
input			[31:0]	pc_i, ALUres_i, wrdata_i;
output	reg		[31:0]	pc_o = 32'd0, ALUres_o = 32'd0, wrdata_o = 32'd0;

// Control Signal
input			MemRead_i, MemWrite_i, RegWrite_i, MemtoReg_i;
output	reg		MemRead_o = 1'b0, MemWrite_o = 1'b0, RegWrite_o = 1'b0, MemtoReg_o = 1'b0;

// Write path
input		[4:0]	WriteBackPath_i;
output 	reg	[4:0]	WriteBackPath_o = 5'b0;

always@(posedge clk_i) begin
	pc_o <= pc_i;
	ALUres_o <= ALUres_i;
	wrdata_o <= wrdata_i;
	// Control signal
	MemRead_o <= MemRead_i;
	MemWrite_o <= MemWrite_i;
	RegWrite_o <= RegWrite_i;
	MemtoReg_o <= MemtoReg_i;
	// Writeback path
	WriteBackPath_o <= WriteBackPath_i;
end

endmodule
