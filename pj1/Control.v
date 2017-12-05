module Control(Op_i, RegDst_o, ALUSrc_o, MemtoReg_o, RegWrite_o, MemWrite_o, Branch_o, Jump_o, ExtOp_o, ALUOp_o, MemRead_o);

input	[5:0]	Op_i;
output			RegDst_o, ALUSrc_o, MemtoReg_o, RegWrite_o, MemWrite_o, Branch_o, Jump_o, ExtOp_o, MemRead_o;
output	[1:0]	ALUOp_o;

// RegDst: 0:I-type, 1:R-type
assign RegDst_o = (Op_i == 6'd0) ? 1'd1 : 1'd0;

// ALUSrc: 0:R-type, 1:I-type
assign ALUSrc_o = (Op_i == 6'd0 || Op_i == 6'b000100) ? 1'd0 : 1'd1;

assign MemtoReg_o = (Op_i == 6'b100011) ? 1'd1 : 1'd0;

assign RegWrite = (Op_i == 6'b000000 || Op_i == 6'b100011) ? 1'd1 : 1'd0;

assign MemWrite = (Op_i == 6'b101011) ? 1'd1 : 1'd0;

assign Branch_o = (Op_i == 6'b000100) ? 1'd1 : 1'd0;

assign Jump_o = (Op_i == 6'b000010) ? 1'd1 : 1'd0;

assign ExtOp_o = 1'd1;

// ALUOp: 0:R-type, 1:add, 2:sub
assign ALUOp_o = (Op_i == 6'd0) ? 2'd0 :
				 (Op_i == 6'b100011 || Op_i == 6'b101011) ? 2'd1 : 2'd2;


// always need to write
assign RegWrite_o = 1'd1;

assign MemRead_o = (Op_i == 6'b100011) ? 1'd1 : 1'd0;

endmodule
