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

input			clk_i;
input	[31:0]	pc_i, data1_i, data2_i, extend_i;
output	[31:0]	pc_o, data1_o, data2_o, extend_o;
reg		[31:0]	pc_o, data1_o, data2_o, extend_o;

// Control signal
input			RegDst_i, ALUSrc_i, MemtoReg_i, RegWrite_i, MemWrite_i, ExtOp_i, MemRead_i;
output			RegDst_o, ALUSrc_o, MemtoReg_o, RegWrite_o, MemWrite_o, ExtOp_o, MemRead_o;
input	[1:0]	ALUOp_i;
output	[1:0]	ALUOp_o;
reg 			RegDst_o, ALUSrc_o, MemtoReg_o, RegWrite_o, MemWrite_o, ExtOp_o, MemRead_o;
reg 	[1:0]	ALUOp_o;

// Writeback path
input	[4:0]	MUX0_i, MUX1_i;
output	[4:0]	MUX0_o, MUX1_o;
reg		[4:0]	MUX0_o, MUX1_o;

// Forwarding
input	[4:0]	inst0_i, inst1_i;
output	[4:0]	inst0_o, inst1_o;
reg		[4:0]	inst0_o, inst1_o;

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