module Data_Memory(clk, addr_i, w_data_i, MemRead_i, MemWrite_i, r_data_o);

input	wire	[31:0]	addr_i, w_data_i;
input	wire			MemRead_i, MemWrite_i, clk;
output	reg		[31:0]	r_data_o;

reg		[31:0]	Mem[7:0];

always @(posedge clk) begin
	if (MemRead_i == 1'b1)	begin
		r_data_o  <= Mem[addr_i];
	end

	if (MemWrite_i == 1'b1) begin
		Mem[addr_i] <= w_data_i;
	end
end

endmodule
