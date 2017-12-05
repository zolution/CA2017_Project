module Shift_Left(pc_i, inst_i, inst_o);

input 	[25:0]	inst_i;
input 	[31:0]	pc_i;
output	[31:0]	inst_o;

assign inst_o = { pc_i[31:28], ( inst_i << 2 ) };

endmodule