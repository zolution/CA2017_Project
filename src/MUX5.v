module MUX5(data1_i, data2_i, select_i, data_o);

input			select_i;
input	[4:0]	data1_i, data2_i;
output	[4:0]	data_o;

assign data_o = (select_i==0) ? data1_i : data2_i;

endmodule
