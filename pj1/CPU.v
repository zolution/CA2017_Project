module CPU
(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input	wire	clk_i;
input			rst_i;
input			start_i;

wire	[31:0]	inst_addr, inst, ALUres, RTdata;

Control Control(
    .Op_i       (inst[31:26]),
    .RegDst_o   (),
    .ALUOp_o    (),
    .ALUSrc_o   (),
    .RegWrite_o (),
	.MemtoReg_o	(),
	.MemWrite_o	(),
	.Branch_o	(),
	.Jump_o		(),
	.ExtOp_o	(),
	.MemRead_o	()
);

Adder Add_PC(
    .data1_i	(inst_addr),
    .data2_i	(32'd4),
    .data_o		()
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (Add_PC.data_o),
    .pc_o       (inst_addr)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (PC.pc_o), 
    .instr_o    (inst)
);

Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (inst[25:21]),
    .RTaddr_i   (inst[20:16]),
    .RDaddr_i   (MUX_RegDst.data_o), 
    .RDdata_i   (MUX_MemtoReg.data_o),
    .RegWrite_i (Control.RegWrite_o), 
    .RSdata_o   (), 
    .RTdata_o   () 
);

MUX5 MUX_RegDst(
    .data1_i    (inst[20:16]),
    .data2_i    (inst[15:11]),
    .select_i   (Control.RegDst_o),
    .data_o     ()
);

MUX32 MUX_ALUSrc(
    .data1_i    (RTdata),
    .data2_i    (Sign_Extend.data_o),
    .select_i   (Control.ALUSrc_o),
    .data_o     ()
);

Sign_Extend Sign_Extend(
    .data_i     (inst[15:0]),
    .data_o     ()
);
  
ALU ALU(
	.data1_i    (Registers.RSdata_o),
    .data2_i    (MUX_ALUSrc.data_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     (ALUres),
    .Zero_o     ()
);

ALU_Control ALU_Control(
    .funct_i    (inst[5:0]),
    .ALUOp_i    (Control.ALUOp_o),
    .ALUCtrl_o  ()
);

Data_Memory Data_Memory(
	.clk		(clk),
	.addr_i		(ALUres),
	.w_data_i	(RTdata),
	.MemRead_i	(Control.MemRead_o),
	.MemWrite_i	(Control.MemWrite_o),
	.r_data_o	()
);

MUX32 MUX_MemtoReg(
	.data1_i	(DAtaMemory.r_data_o),
	.data2_i	(ALUres),
	.select_i	(Control.MemtoReg),
	.data_o		()
);

endmodule

