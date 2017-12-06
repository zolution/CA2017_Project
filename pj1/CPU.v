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

wire            registers_equal = (Registers.RSdata_o == Registers.RTdata_o);
wire            Branch_MUX_select = Control.Branch_o & registers_equal;

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

MUX32 Branch_MUX(
    .data1_i    (pc_plus4),
    .data2_i    (Add_branch.data_o),
    .select_i   (Branch_MUX_select),
    .data_o     ()
);

// IF stage

Instruction_Memory Instruction_Memory(
    .addr_i     (inst_addr), 
    .instr_o    ()
);

IFID IFID(
    .clk_i      (clk_i),
    .pc_i       (pc_plus4),
    .inst_i     (Instruction_Memory.instr_o),
    .pc_o       (),
    .inst_o     (inst)
);

// ID stage

Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (inst[25:21]),
    .RTaddr_i   (inst[20:16]),
    .RDaddr_i   (MEMWB.WriteBackPath_o), 
    .RDdata_i   (MUX_MemtoReg.data_o),
    .RegWrite_i (MEMWB.RegWrite_o), 
    .RSdata_o   (), 
    .RTdata_o   () 
);

Sign_Extend Sign_Extend(
    .data_i     (inst[15:0]),
    .data_o     ()
);

IDEX IDEX(
    .clk_i      (clk_i),
    .pc_i       (IFID.pc_o),
    .data1_i    (Registers.RSdata_o),
    .data2_i    (Registers.RTdata_o),
    .extend_i   (Sign_Extend.data_o),
    .pc_o       (),
    .data1_o    (),
    .data2_o    (RTdata),
    .extend_o   (extended),
    // Control input
    .RegDst_i   (Control.RegDst_o),
    .ALUSrc_i   (Control.ALUSrc_o),
    .MemtoReg_i (Control.MemtoReg_o),
    .RegWrite_i (Control.RegWrite_o),
    .MemWrite_i (Control.MemWrite_o),
    .Branch_i   (Control.Branch_o),
    .Jump_i     (Control.Jump_o),
    .ExtOp_i    (Control.ExtOp_o),
    .ALUOp_i    (Control.ALUOp_o),
    .MemRead_i  (Control.MemRead_o),
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
    .MemRead_o  (),
    // Writeback path
    .MUX0_i     (inst[20:16]),
    .MUX1_i     (inst[15:11]),
    .MUX0_o     (),
    .MUX1_o     ()
);

// EX stage

Adder Add_branch(
    .data1_i    (IDEX.pc_o),
    .data2_i    ({extended[29:0], 2'b00}),
    .data_o     ()
);

MUX5 MUX_RegDst(
    .data1_i    (IDEX.MUX0_o),
    .data2_i    (IDEX.MUX1_o),
    .select_i   (IDEX.RegDst_o),
    .data_o     ()
);

MUX32 MUX_ALUSrc(
    .data1_i    (RTdata),
    .data2_i    (Sign_Extend.data_o),
    .select_i   (IDEX.ALUSrc_o),
    .data_o     ()
);
  
ALU ALU(
	.data1_i    (Registers.RSdata_o),
    .data2_i    (MUX_ALUSrc.data_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     (),
    .Zero_o     ()
);

ALU_Control ALU_Control(
    .funct_i    (inst[5:0]),
    .ALUOp_i    (IDEX.ALUOp_o),
    .ALUCtrl_o  ()
);

EXMEM EXMEM(
    .clk_i      (clk_i),
    .pc_i       (Add_branch.data_o),
    .ALUres_i   (ALU.data_o),
    .wrdata_i   (RTdata),
    .pc_o       (),
    .ALUres_o   (ALUres),
    .wrdata_o   (),
    // Control input
    .Branch_i   (IDEX.Branch_o),
    .MemRead_i  (IDEX.MemRead_o),
    .MemWrite_i (IDEX.MemWrite_o),
    .RegWrite_i (IDEX.RegWrite_o),
    .MemtoReg_i (IDEX.MemtoReg_o),
    // Control output
    .Branch_o   (),
    .MemRead_o  (),
    .MemWrite_o (),
    .RegWrite_o (),
    .MemtoReg_o (),
    // Writeback path
    .WriteBackPath_i (MUX_RegDst.data_o),
    .WriteBackPath_o ()
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
    .clk_i      (clk_i),
    .mux0_i     (Data_Memory.r_data_o),
    .mux1_i     (ALUres),
    .mux0_o     (),
    .mux1_o     (),
    // Control input
    .RegWrite_i (EXMEM.RegWrite_o),
    .MemtoReg_i (EXMEM.MemtoReg_o),
    // Control output
    .RegWrite_o (),
    .MemtoReg_o (),
    // Writeback path
    .WriteBackPath_i (EXMEM.WriteBackPath_o),
    .WriteBackPath_o ()
);

// WB stage

MUX32 MUX_MemtoReg(
	.data1_i	(ALUres),
	.data2_i	(Data_Memory.r_data_o),
	.select_i	(Control.MemtoReg_o),
	.data_o		()
);

HazardDetection Hazard_Detect(
    .IDEX_MemRead_i     (),
    .PC_Write_o         (),
    .IFID_Write_o       (),
    .MUX8_o             (),
    .IDEX_RegisterRt_i  (),
    .IFID_RegisterRs_i  (),
    .IFID_RegisterRt_i  ()
);

MUX8 MUX8(
    .MUX8_i     (),
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

endmodule

