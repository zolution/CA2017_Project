module EXMEM
(
	clk_i,
	pc_i, ALUres_i, wrdata_i,
	pc_o, ALUres_o, wrdata_o
);

input			clk_i;
input	[31:0]	pc_i, ALUres_i, wrdata_i;
output	[31:0]	pc_o, ALUres_o, wrdata_o;
reg		[31:0]	pc_o, ALUres_o, wrdata_o;

always@(posedge clk_i) begin
	pc_o <= pc_i;
	ALUres_o <= ALUres_i;
	wrdata_o <= wrdata_i;
end

endmodule