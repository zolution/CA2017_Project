module Data_Memory(clk, addr_i, w_data_i, MemRead_i, MemWrite_i, r_data_o);

input	wire	[31:0]	addr_i, w_data_i;
input	wire			MemRead_i, MemWrite_i, clk;

output	reg		[31:0]	r_data_o = 32'b0;

reg		[31:0]	memory[31:0];

always @(addr_i or w_data_i or MemRead_i or MemWrite_i) begin
	if (MemRead_i == 1'b1)	begin
		r_data_o  <= memory[addr_i];
	end

	if (MemWrite_i == 1'b1) begin
		memory[addr_i] <= w_data_i;
	end
end

endmodule
