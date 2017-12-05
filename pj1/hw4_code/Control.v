module Control(Op_i, RegDst_o, ALUOp_o, ALUSrc_o, RegWrite_o);

input	[5:0]	Op_i;
output			RegDst_o, ALUSrc_o, RegWrite_o;
output	[1:0]	ALUOp_o;

// RegDst: 0:I-type, 1:R-type
assign RegDst_o = (Op_i == 6'd0) ? 1'd1 : 1'd0;

// ALUOp: 0:R-type, 1:I-type
assign ALUOp_o = (Op_i == 6'd0) ? 2'd0 : 2'd1;

// ALUSrc: 0:R-type, 1:I-type
assign ALUSrc_o = (Op_i == 6'd0) ? 1'd0 : 1'd1;

// always need to write
assign RegWrite_o = 1'd1;

endmodule
