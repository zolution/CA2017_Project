module IDEX
(
	clk_i,
	pc_i, data1_i, data2_i, extend_i,
	pc_o, data1_o, data2_o, extend_o
);

input			clk_i;
input	[31:0]	pc_i, data1_i, data2_i, extend_i;
output	[31:0]	pc_o, data1_o, data2_o, extend_o;
reg		[31:0]	pc_o, data1_o, data2_o, extend_o;

always@(posedge clk_i) begin
	pc_o <= pc_i;
	data1_o <= data1_i;
	data2_o <= data2_i;
	extend_o <= extend_i;
end

endmodule