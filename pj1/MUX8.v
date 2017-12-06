module MUX8(
    MUX8_i,
    RegDst_i, ALUSrc_i, MemtoReg_i, RegWrite_i, MemWrite_i, Branch_i, Jump_i, ExtOp_i, ALUOp_i, MemRead_i,
	RegDst_o, ALUSrc_o, MemtoReg_o, RegWrite_o, MemWrite_o, Branch_o, Jump_o, ExtOp_o, ALUOp_o, MemRead_o
);

input 			MUX8_i, RegDst_i, ALUSrc_i, MemtoReg_i, RegWrite_i, MemWrite_i, Branch_i, Jump_i, ExtOp_i, MemRead_i;
output			RegDst_o, ALUSrc_o, MemtoReg_o, RegWrite_o, MemWrite_o, Branch_o, Jump_o, ExtOp_o, MemRead_o;
input 	[1:0]	ALUOp_i;
output	[1:0]	ALUOp_o;

// MUX8_i == 1 => isHazard

assign RegDst_o = (MUX8_i == 1'b0) ? RegDst_i : 1'b0;
assign ALUSrc_o = (MUX8_i == 1'b0) ? ALUSrc_i : 1'b0;
assign MemtoReg_o = (MUX8_i == 1'b0) ? MemtoReg_i : 1'b0;
assign RegWrite_o = (MUX8_i == 1'b0) ? RegWrite_i : 1'b0;
assign MemWrite_o = (MUX8_i == 1'b0) ? MemWrite_i : 1'b0;
assign Branch_o = (MUX8_i == 1'b0) ? Branch_i : 1'b0;
assign Jump_o = (MUX8_i == 1'b0) ? Jump_i : 1'b0;
assign ExtOp_o = (MUX8_i == 1'b0) ? ExtOp_i : 1'b0;
assign MemRead_o = (MUX8_i == 1'b0) ? MemRead_i : 1'b0;
assign ALUOp_o = (MUX8_i == 1'b0) ? ALUOp_i : 2'b00;

endmodule



