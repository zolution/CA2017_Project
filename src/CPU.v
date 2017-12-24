module CPU
(
	clk_i,
	rst_i,
	start_i,
 
	mem_data_i,
	mem_ack_i,
	mem_data_o,
	mem_addr_o,
	mem_enable_o,
	mem_write_o
);

//input
input clk_i;
input rst_i;
input start_i;

//
// to Data Memory interface
//
input	[256-1:0]	mem_data_i;
input				mem_ack_i;
output	[256-1:0]	mem_data_o;
output	[32-1:0]	mem_addr_o;
output				mem_enable_o;
output				mem_write_o;

//
// add your project1 here!
//
wire	[31:0]	inst_addr, inst, ALUres, RTdata, pc_plus4, pc_next, extended, funct, WBdata, WRdata;

wire            registers_equal = (Registers.RSdata_o == Registers.RTdata_o) ? 1'b1 : 1'b0;
wire            Branch_MUX_select = Control.Branch_o & registers_equal;

// For Flush
wire            IFID_needflush = Control.Jump_o | Branch_MUX_select;
wire			stall;

// Hazard & Forwarding
wire            MemRead, RegWrite_WB, RegWrite_MEM;
wire    [4:0]   IDEX_MUX0, WriteBack_MEM, WriteBack_WB;

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

MUX8 MUX8(
    .MUX8_i     (HazardDetection.MUX8_o),
    .RegDst_i   (Control.RegDst_o),
    .ALUSrc_i   (Control.ALUSrc_o),
    .MemtoReg_i (Control.MemtoReg_o),
    .RegWrite_i (Control.RegWrite_o),
    .MemWrite_i (Control.MemWrite_o),
    .ExtOp_i    (Control.ExtOp_o),
    .ALUOp_i    (Control.ALUOp_o),
    .MemRead_i  (Control.MemRead_o),
    .RegDst_o   (),
    .ALUSrc_o   (),
    .MemtoReg_o (),
    .RegWrite_o (),
    .MemWrite_o (),
    .ExtOp_o    (),
    .ALUOp_o    (),
    .MemRead_o  ()
);

// PC, Jump, Branch

Adder Add_PC(
    .data1_i	(inst_addr),
    .data2_i	(32'd4),
    .data_o		(pc_plus4)
);

PC PC
(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.start_i(start_i),
	.stall_i(stall),
	.pcEnable_i(~HazardDetection.PC_Write_o),
	.pc_i(Jump_MUX.data_o),
	.pc_o(inst_addr)
);

/* Origin Code
PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (Jump_MUX.data_o),
    .pc_o       (inst_addr),
    .Hazard_i   (HazardDetection.PC_Write_o)
);
*/

Shift_Left Shift_Left(
    .pc_i       (pc_next),
    .inst_i     (inst[25:0]),
    .inst_o     ()
);

MUX32 Jump_MUX(
    .data1_i    (pc_next),
    .data2_i    (Shift_Left.inst_o),
    .select_i   (Control.Jump_o),
    .data_o     ()
);

MUX32 Branch_MUX(
    .data1_i    (pc_plus4),
    .data2_i    (Add_branch.data_o),
    .select_i   (Branch_MUX_select),
    .data_o     (pc_next)
);

// IF stage

Instruction_Memory Instruction_Memory(
	.addr_i(inst_addr),
	.inst_o()
);

/*Origin Code
Instruction_Memory Instruction_Memory(
    .addr_i     (inst_addr),
    .inst_o     ()
);
*/

IFID IFID(
    .clk_i      (clk_i),
    .pc_i       (pc_plus4),
    .inst_i     (Instruction_Memory.inst_o),
    .pc_o       (),
    .inst_o     (inst),
    .Hazard_i   (HazardDetection.IFID_Write_o),
	.stall_i(stall),
    .Flush_i    (IFID_needflush)
);

// ID stage
Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (inst[25:21]),
    .RTaddr_i   (inst[20:16]),
    .RDaddr_i   (WriteBack_WB),
    .RDdata_i   (WBdata),
    .RegWrite_i (RegWrite_WB),
    .RSdata_o   (),
    .RTdata_o   ()
);

Sign_Extend Sign_Extend(
    .data_i     (inst[15:0]),
    .data_o     (extended)
);

Adder Add_branch(
    .data1_i    (IFID.pc_o),
    .data2_i    ({extended[29:0], 2'b00}),
    .data_o     ()
);

HazardDetection HazardDetection(
    .IDEX_MemRead_i     (MemRead),
    .IDEX_RegisterRt_i  (IDEX_MUX0),
    .IFID_RegisterRs_i  (inst[25:21]),
    .IFID_RegisterRt_i  (inst[20:16]),
    .PC_Write_o         (),
    .IFID_Write_o       (),
    .MUX8_o             ()
);

IDEX IDEX(
    .clk_i      (clk_i),
    .pc_i       (),
    .data1_i    (Registers.RSdata_o),
    .data2_i    (Registers.RTdata_o),
    .extend_i   (extended),
    .pc_o       (),
    .data1_o    (),
    .data2_o    (),
    .extend_o   (funct),
    // Control input
    .RegDst_i   (MUX8.RegDst_o),
    .ALUSrc_i   (MUX8.ALUSrc_o),
    .MemtoReg_i (MUX8.MemtoReg_o),
    .RegWrite_i (MUX8.RegWrite_o),
    .MemWrite_i (MUX8.MemWrite_o),
    .ExtOp_i    (MUX8.ExtOp_o),
    .ALUOp_i    (MUX8.ALUOp_o),
    .MemRead_i  (MUX8.MemRead_o),
    // Control output
    .RegDst_o   (),
    .ALUSrc_o   (),
    .MemtoReg_o (),
    .RegWrite_o (),
    .MemWrite_o (),
    .ExtOp_o    (),
    .ALUOp_o    (),
    .MemRead_o  (MemRead),
    // Forwarding unit
    .inst0_i     (inst[25:21]),
    .inst1_i     (inst[20:16]),
    .inst0_o     (),
    .inst1_o     (),
    // WriteBack path
    .MUX0_i     (inst[20:16]),
    .MUX1_i     (inst[15:11]),
    .MUX0_o     (IDEX_MUX0),
	.stall_i(stall),
    .MUX1_o     ()
);

// EX stage

MUX32 MUX_ALUSrc(
    .data1_i    (WRdata),
    .data2_i    (funct),
    .select_i   (IDEX.ALUSrc_o),
    .data_o     ()
);

MUX32_3 MUX6(
	.data1_i	(IDEX.data1_o),
	.data2_i	(WBdata),
	.data3_i	(ALUres),
	.select_i	(Forwarding.ForwardA_o),
	.data_o		()
);

MUX32_3 MUX7(
	.data1_i	(IDEX.data2_o),
	.data2_i	(WBdata),
	.data3_i	(ALUres),
	.select_i	(Forwarding.ForwardB_o),
	.data_o		(WRdata)
);

ALU ALU(
	.data1_i    (MUX6.data_o),
    .data2_i    (MUX_ALUSrc.data_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     (),
    .Zero_o     ()
);

ALU_Control ALU_Control(
    .funct_i    (funct[5:0]),
    .ALUOp_i    (IDEX.ALUOp_o),
    .ALUCtrl_o  ()
);

MUX5 MUX_RegDst(
    .data1_i    (IDEX_MUX0),
    .data2_i    (IDEX.MUX1_o),
    .select_i   (IDEX.RegDst_o),
    .data_o     ()
);

Forwarding Forwarding(
    .IE_RegRS_i     (IDEX.inst0_o),
    .IE_RegRT_i     (IDEX.inst1_o),
    .ForwardA_o     (),
    .ForwardB_o     (),
    // Control signal from EX/MEM stage
    .EM_RegWrite_i	(RegWrite_MEM),
    .EM_RegRD_i		(WriteBack_MEM),
    // Control signal from MEM/WB stage
    .MW_RegWrite_i	(RegWrite_WB),
    .MW_RegRD_i		(WriteBack_WB)
);

// TODO remove PC
EXMEM EXMEM(
    .clk_i      (clk_i),
    .pc_i       (),
    .ALUres_i   (ALU.data_o),
    .wrdata_i   (WRdata),
    .pc_o       (),
    .ALUres_o   (ALUres),
    .wrdata_o   (),
	.stall_i(stall),
    // Control input
    .MemRead_i  (MemRead),
    .MemWrite_i (IDEX.MemWrite_o),
    .RegWrite_i (IDEX.RegWrite_o),
    .MemtoReg_i (IDEX.MemtoReg_o),
    // Control output
    .MemRead_o  (),
    .MemWrite_o (),
    .RegWrite_o (RegWrite_MEM),
    .MemtoReg_o (),
    // WriteBack path
    .WriteBackPath_i (MUX_RegDst.data_o),
    .WriteBackPath_o (WriteBack_MEM)
);

// MEM stage

/*
Data_Memory Data_Memory(
	.clk		(clk_i),
	.addr_i		(ALUres),
	.w_data_i	(EXMEM.wrdata_o),
	.MemRead_i	(EXMEM.MemRead_o),
	.MemWrite_i	(EXMEM.MemWrite_o),
	.r_data_o	()
);
*/

MEMWB MEMWB(
    .clk_i      (clk_i),
    .mux0_i     (ALUres),
    .mux1_i     (dcache.p1_data_o),
    .mux0_o     (),
    .mux1_o     (),
	.stall_i(stall),
    // Control input
    .RegWrite_i (RegWrite_MEM),
    .MemtoReg_i (EXMEM.MemtoReg_o),
    // Control output
    .RegWrite_o (RegWrite_WB),
    .MemtoReg_o (),
    // WriteBack path
    .WriteBackPath_i (WriteBack_MEM),
    .WriteBackPath_o (WriteBack_WB)
);

// WB stage

MUX32 MUX5(
	.data1_i	(MEMWB.mux0_o),
	.data2_i	(MEMWB.mux1_o),
	.select_i	(MEMWB.MemtoReg_o),
	.data_o		(WBdata)
);

//data cache
dcache_top dcache
(
    // System clock, reset and stall
	.clk_i(clk_i),
	.rst_i(rst_i),

	// to Data Memory interface	
	.mem_data_i(mem_data_i),
	.mem_ack_i(mem_ack_i),
	.mem_data_o(mem_data_o),
	.mem_addr_o(mem_addr_o),
	.mem_enable_o(mem_enable_o),
	.mem_write_o(mem_write_o),

	// to CPU interface
	.p1_data_i(EXMEM.wrdata_o),
	.p1_addr_i(ALUres),
	.p1_MemRead_i(EXMEM.MemRead_o),
	.p1_MemWrite_i(EXMEM.MemWrite_o),
	.p1_data_o(),
	.p1_stall_o(stall)
);

endmodule
