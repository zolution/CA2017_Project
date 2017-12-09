module IDEX
(
	clk_i,
	pc_i, data1_i, data2_i, extend_i,
	pc_o, data1_o, data2_o, extend_o,
	RegDst_i, ALUSrc_i, MemtoReg_i, RegWrite_i, MemWrite_i, ExtOp_i, ALUOp_i, MemRead_i,
	RegDst_o, ALUSrc_o, MemtoReg_o, RegWrite_o, MemWrite_o, ExtOp_o, ALUOp_o, MemRead_o,
	MUX0_i, MUX1_i, MUX0_o, MUX1_o,
	inst0_i, inst1_i, inst0_o, inst1_o
);

input				clk_i;
input		[31:0]	pc_i, data1_i, data2_i, extend_i;
output reg	[31:0]	pc_o=32'b0, data1_o=32'b0, data2_o=32'b0, extend_o=32'b0;

// Control signal
input				RegDst_i, ALUSrc_i, MemtoReg_i, RegWrite_i, MemWrite_i, ExtOp_i, MemRead_i;
output reg			RegDst_o=0, ALUSrc_o=0, MemtoReg_o=0, RegWrite_o=0, MemWrite_o=0, ExtOp_o=0, MemRead_o=0;
input		[1:0]	ALUOp_i;
output reg	[1:0]	ALUOp_o=2'b0;

// Writeback path
input		[4:0]	MUX0_i, MUX1_i;
output reg	[4:0]	MUX0_o=5'b0, MUX1_o=5'b0;

// Forwarding
input		[4:0]	inst0_i, inst1_i;
output reg	[4:0]	inst0_o=5'b0, inst1_o=5'b0;

always@(posedge clk_i) begin
	pc_o <= pc_i;
	data1_o <= data1_i;
	data2_o <= data2_i;
	extend_o <= extend_i;
	// Control signal
	RegDst_o <= RegDst_i;
	ALUSrc_o <= ALUSrc_i;
	MemtoReg_o <= MemtoReg_i;
	RegWrite_o <= RegWrite_i;
	MemWrite_o <= MemWrite_i;
	ExtOp_o <= ExtOp_i;
	ALUOp_o <= ALUOp_i;
	MemRead_o <= MemRead_i;
	// Writeback path
	MUX0_o <= MUX0_i;
	MUX1_o <= MUX1_i;
	// Forwarding
	inst0_o <= inst0_i;
	inst1_o <= inst1_i;
end

endmodule