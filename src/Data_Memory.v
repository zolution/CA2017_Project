module Data_Memory(clk, addr_i, w_data_i, MemRead_i, MemWrite_i, r_data_o);

input	wire	[31:0]	addr_i, w_data_i;
input	wire	MemRead_i, MemWrite_i, clk;
output	wire	[31:0]	r_data_o;

reg		[31:0]	memory[31:0];

assign	r_data_o = memory[addr_i];

always @(posedge clk) begin
	if (MemWrite_i == 1'b1) begin
		memory[addr_i  ] <= w_data_i;
	end
end

endmodule