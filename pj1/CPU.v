module CPU
(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input			clk_i;
input			rst_i;
input			start_i;

wire	[31:0]	inst_addr, inst, ALUres, RTdata, pc_plus4, extended;

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


// PC, Jump, Branch

Adder Add_PC(
    .data1_i	(inst_addr),
    .data2_i	(32'd4),
    .data_o		(pc_plus4)
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (Jump_MUX.data_o),
    .pc_o       (inst_addr)
);

Shift_Left Shift_Left(
    .pc_i       (pc_plus4),
    .inst_i     (inst[25:0]),
    .inst_o     ()
);

MUX32 Jump_MUX(
    .data1_i    (Branch_MUX.data_o),
    .data2_i    (Shift_Left.inst_o),
    .select_i   (Control.Jump_o),
    .data_o     ()
);

Adder Add_branch(
    .data1_i    (pc_plus4),
    .data2_i    ({extended[29:0], 2'b00}),
    .data_o     ()
);

MUX32 Branch_MUX(
    .data1_i    (pc_plus4),
    .data2_i    (Add_branch.data_o),
    .select_i   (Control.Branch_o),
    .data_o     ()
);

// IF stage

Instruction_Memory Instruction_Memory(
    .addr_i     (inst_addr), 
    .instr_o    (inst)
);

IFID IFID(
    .clk_i      (),
    .pc_i       (),
    .inst_i     (),
    .pc_o       (),
    .inst_o     ()
);

// ID stage

Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (inst[25:21]),
    .RTaddr_i   (inst[20:16]),
    .RDaddr_i   (MUX_RegDst.data_o), 
    .RDdata_i   (MUX_MemtoReg.data_o),
    .RegWrite_i (Control.RegWrite_o), 
    .RSdata_o   (), 
    .RTdata_o   (RTdata) 
);

Sign_Extend Sign_Extend(
    .data_i     (inst[15:0]),
    .data_o     (extended)
);

IDEX IDEX(
    .clk_i      (),
    .pc_i       (),
    .data1_i    (),
    .data2_i    (),
    .extend_i   (),
    .pc_o       (),
    .data1_o    (),
    .data2_o    (),
    .extend_o   (),
    // Control input
    .RegDst_i   (),
    .ALUSrc_i   (),
    .MemtoReg_i (),
    .RegWrite_i (),
    .MemWrite_i (),
    .Branch_i   (),
    .Jump_i     (),
    .ExtOp_i    (),
    .ALUOp_i    (),
    .MemRead_i  (),
    // Control output
    .RegDst_o   (),
    .ALUSrc_o   (),
    .MemtoReg_o (),
    .RegWrite_o (),
    .MemWrite_o (),
    .Branch_o   (),
    .Jump_o     (),
    .ExtOp_o    (),
    .ALUOp_o    (),
    .MemRead_o  ()
);

// EX stage

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

EXMEM EXMEM(
    .clk_i      (),
    .pc_i       (),
    .ALUres_i   (),
    .wrdata_i   (),
    .pc_o       (),
    .ALUres_o   (),
    .wrdata_o   (),
    .Branch_i   (),
    .MemRead_i  (),
    .MemWrite_i (),
    .RegWrite_i (),
    .MemtoReg_i (),
    .Branch_o   (),
    .MemRead_o  (),
    .MemWrite_o (),
    .RegWrite_o (),
    .MemtoReg_o ()
);

// MEM stage

Data_Memory Data_Memory(
	.clk		(clk_i),
	.addr_i		(ALUres),
	.w_data_i	(RTdata),
	.MemRead_i	(Control.MemRead_o),
	.MemWrite_i	(Control.MemWrite_o),
	.r_data_o	()
);

MEMWB MEMWB(
    .clk_i      (),
    .mux0_i     (),     .mux1_i     (),
    .mux0_o     (),     .mux1_o     (),
    // Control input
    .RegWrite_i (),     .MemtoReg_i (),
    // Control output
    .RegWrite_o (),     .MemtoReg_o ()
);

// WB stage

MUX32 MUX_MemtoReg(
	.data1_i	(ALUres),
	.data2_i	(Data_Memory.r_data_o),
	.select_i	(Control.MemtoReg_o),
	.data_o		()
);

endmodule

