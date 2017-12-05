module ALU_Control(funct_i, ALUOp_i, ALUCtrl_o);

input	[5:0]	funct_i;
input	[1:0]	ALUOp_i;
output	[2:0]	ALUCtrl_o;

// ALUOp: 0:R-type, 1:I-type
// ALUSrc: 0:R-type, 1:I-type
// 1:+, 2:-, 3:&, 4:|, 5:*
// add: 100000
// sub: 100010
// and: 100100
// or : 100101
// mul: 011000
assign ALUCtrl_o =	(funct_i==6'b100000||ALUOp_i==2'd1) ? 3'd1 :
					(funct_i==6'b100010||ALUOp_i==2'd2) ? 3'd2 :
					(funct_i==6'b100100) ? 3'd3 :
					(funct_i==6'b100101) ? 3'd4 :
					(funct_i==6'b011000) ? 3'd5 :
					0;

endmodule
