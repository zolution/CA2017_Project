module HazardDetection(
	IDEX_MemRead_i,
	PC_Write_o, IFID_Write_o, MUX8_o,
	IDEX_RegisterRt_i, IFID_RegisterRs_i, IFID_RegisterRt_i
);

input			IDEX_MemRead_i;
output			PC_Write_o, IFID_Write_o, MUX8_o;

input	[4:0]	IDEX_RegisterRt_i, IFID_RegisterRs_i, IFID_RegisterRt_i;

assign PC_Write_o = (IDEX_MemRead_i && (IDEX_RegisterRt_i == IFID_RegisterRs_i) || (IDEX_RegisterRt_i == IFID_RegisterRt_i)) ? 1'b1 : 1'b0;

assign IFID_Write_o = PC_Write_o;
assign MUX8_o = PC_Write_o;

endmodule
