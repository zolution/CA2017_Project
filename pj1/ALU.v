module ALU (data1_i, data2_i, ALUCtrl_i, data_o, Zero_o);

input	[31:0]	data1_i, data2_i;
input	[2:0]	ALUCtrl_i;
output	[31:0]	data_o, Zero_o;


// 1:+, 2:-, 3:&, 4:|, 5:^
/* implement here */
assign data_o =	(ALUCtrl_i==3'd1) ? data1_i+data2_i :
				    (ALUCtrl_i==3'd2) ? data1_i-data2_i :
					(ALUCtrl_i==3'd3) ? data1_i&data2_i :
					(ALUCtrl_i==3'd4) ? data1_i|data2_i :
					(ALUCtrl_i==3'd5) ? data1_i*data2_i :
					0;
assign Zero_o = (data_o == 32'b0) ? 1 : 0;

endmodule
