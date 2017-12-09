module Forwarding(EM_RegWrite_i, EM_RegRD_i, MW_RegWrite_i, MW_RegRD_i, IE_RegRS_i, IE_RegRT_i, ForwardA_o, ForwardB_o);

input	[4:0]	EM_RegRD_i, MW_RegRD_i, IE_RegRS_i, IE_RegRT_i;
input			EM_RegWrite_i, MW_RegWrite_i;
output	[1:0]	ForwardA_o, ForwardB_o;

assign ForwardA_o = (EM_RegWrite_i==1'b1 && EM_RegRD_i!=5'b0 && EM_RegRD_i==IE_RegRS_i) ? 2'b10 :
				   (MW_RegWrite_i==1'b1 && MW_RegRD_i!=5'b0 && EM_RegRD_i!=IE_RegRS_i && MW_RegRD_i==IE_RegRS_i) ? 2'b01 : 2'b00;

assign ForwardB_o = (EM_RegWrite_i==1'b1 && EM_RegRD_i!=5'b0 && EM_RegRD_i==IE_RegRT_i) ? 2'b10 :
				   (MW_RegWrite_i==1'b1 && MW_RegRD_i!=5'b0 && EM_RegRD_i!=IE_RegRT_i && MW_RegRD_i==IE_RegRT_i) ? 2'b01 : 2'b00;

endmodule
