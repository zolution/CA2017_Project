module EXMEM
(
	clk_i,
	pc_i, ALUres_i, wrdata_i,
	pc_o, ALUres_o, wrdata_o,
	Branch_i, MemRead_i, MemWrite_i, RegWrite_i, MemtoReg_i,
	Branch_o, MemRead_o, MemWrite_o, RegWrite_o, MemtoReg_o,
	WriteBackPath_i, WriteBackPath_o
);

input			clk_i;
input	[31:0]	pc_i, ALUres_i, wrdata_i;
output	[31:0]	pc_o, ALUres_o, wrdata_o;
reg		[31:0]	pc_o, ALUres_o, wrdata_o;

// Control Signal
input			Branch_i, MemRead_i, MemWrite_i, RegWrite_i, MemtoReg_i;
output			Branch_o, MemRead_o, MemWrite_o, RegWrite_o, MemtoReg_o;
reg 			Branch_o, MemRead_o, MemWrite_o, RegWrite_o, MemtoReg_o;

// Write path
input 	[4:0]	WriteBackPath_i;
output 	[4:0]	WriteBackPath_o;
reg 	[4:0]	WriteBackPath_o;

always@(posedge clk_i) begin
	pc_o <= pc_i;
	ALUres_o <= ALUres_i;
	wrdata_o <= wrdata_i;
	// Control signal
	Branch_o <= Branch_i;
	MemRead_o <= MemRead_i;
	MemWrite_o <= MemWrite_i;
	RegWrite_o <= RegWrite_i;
	MemtoReg_o <= MemtoReg_i;
	// Writeback path
	WriteBackPath_o <= WriteBackPath_i;
end

endmodule