module IFID
(
	clk_i,
	pc_i, inst_i,
	pc_o, inst_o
);

input			clk_i;
input	[31:0]	inst_i, pc_i;
output	[31:0]	inst_o, pc_o;
reg		[31:0]	inst_o, pc_o;

always@(posedge clk_i) begin
    inst_o <= inst_i;
    pc_o <= pc_i;
end

endmodule