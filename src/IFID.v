module IFID
(
	clk_i, stall_i,
	pc_i, inst_i,
	pc_o, inst_o,
	Hazard_i, Flush_i,
);

input				clk_i, Hazard_i, Flush_i;
input		[31:0]	inst_i, pc_i;
output reg	[31:0]	inst_o=32'b0, pc_o=32'b0;

always@(posedge clk_i & !stall_i) begin
    inst_o <= ((Flush_i) ? 32'b0 : 
    		  ((Hazard_i) ? inst_o : inst_i)); //flush or stall or normal
    pc_o <= pc_i;
end

endmodule
