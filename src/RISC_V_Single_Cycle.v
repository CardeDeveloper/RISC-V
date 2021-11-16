/******************************************************************
* Description
*	This is the top-level of a RISC-V Microprocessor that can execute the next set of instructions:
*		add
*		addi
* This processor is written Verilog-HDL. It is synthesizabled into hardware.
* Parameter MEMORY_DEPTH configures the program memory to allocate the program to
* be executed. If the size of the program changes, thus, MEMORY_DEPTH must change.
* This processor was made for computer organization class at ITESO.
* Version:
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	16/08/2021
******************************************************************/

module RISC_V_Single_Cycle
#(
	parameter PROGRAM_MEMORY_DEPTH = 64,
	parameter DATA_MEMORY_DEPTH = 128
)

(
	// Inputs
	input clk,
	input reset,
	output out_top

);
//******************************************************************/
//******************************************************************/

//******************************************************************/
//******************************************************************/
/* Signals to connect modules*/

/**Control**/
wire alu_src_w;
wire reg_write_w;
wire mem_to_reg_w;
wire mem_write_w;
wire mem_read_w;
wire [2:0] alu_op_w;
wire Branch_w;
wire jal_w;
wire jalr_w;

/** Program Counter**/
wire [31:0] pc_plus_4_w;
wire [31:0] pc_w;


/**Register File**/
wire [31:0] read_data_1_w;
wire [31:0] read_data_2_w;

/**Inmmediate Unit**/
wire [31:0] inmmediate_data_w;

/**ALU**/
wire [31:0] alu_result_w;
wire zero_w;

/**Multiplexer MUX_DATA_OR_IMM_FOR_ALU**/
wire [31:0] read_data_2_or_imm_w;

/**ALU Control**/
wire [3:0] alu_operation_w;

/**Instruction Bus**/	
wire [31:0] instruction_bus_w;

wire [31:0] Memory_mix_AluResult_w;
wire [31:0] DataMemory_Result_w;
wire [31:0] pc_imm;
wire ZBrach_w;
wire [31:0] next_pc_w;
wire [31:0] write_data_w;
wire [31:0] PC_IMM_MIX_PC_4_w;

/***************** WIRES para el pipeline **************************/
//wires para IF/ID
wire [31:0] ID_instruction_wire;
wire [31:0] ID_PC_4_wire;

//Wires para ID/EX
wire EX_RegDst_wire;
wire EX_BranchNE_wire;
wire EX_MemReadWire;
wire EX_BranchEQ_wire;
wire EX_MemWriteWire;
wire EX_MemtoRegWire;
wire [3:0] EX_ALUOp_wire;
wire EX_ALUSrc_wire;
wire EX_RegWrite_wire;
wire EX_jump_wire;
wire EX_jal_wire;
wire [31:0] EX_PC_4_wire;
wire [31:0] EX_ReadData1_wire;
wire [31:0] EX_ReadData2_wire;
wire [31:0] EX_InmmediateExtend_wire;
wire [31:0] EX_instruction_wire;

//wires para EX/MEM
wire [31:0] MEM_InmmediateExtendAnded_wire;
wire [31:0] MEM_ALUResult_wire;
wire [31:0] MEM_ReadData2_wire;
wire [4:0] MEM_WriteRegister_wire;
wire [31:0] MEM_MUX_PC_wire;
wire [31:0] MEM_instruction_wire;
wire MEM_MemReadWire;
wire MEM_MemWriteWire;
wire MEM_MemtoRegWire;
wire MEM_RegWrite_wire;
wire MEM_jal_wire;


//wires para MEM/WB
wire [31:0] WB_ramDataWire;
wire [31:0] WB_ALUResult_wire;
wire [4:0] WB_WriteRegister_wire;
wire WB_MemWriteWire;
wire WB_MemtoRegWire;
wire WB_RegWrite_wire;
wire WB_jal_wire;
wire [31:0] WB_MUX_PC_wire;
wire [31:0] WB_instruction_wire;



//******************************************************************/
//******************************************************************/
//******************************************************************/


//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
Control
CONTROL_UNIT
(
	/****/
	.OP_i(instruction_bus_w[6:0]),
	/** outputus**/
	.ALU_Op_o(alu_op_w),
	.ALU_Src_o(alu_src_w),
	.Reg_Write_o(reg_write_w),
	.Mem_to_Reg_o(mem_to_reg_w),
	.Mem_Read_o(mem_read_w),
	.Mem_Write_o(mem_write_w),
	.Branch_o(Branch_w),
	.jal_o(jal_w),
	.jalr_o(jalr_w)
);

PC_Register
PROGRAM_COUNTER
(
	.clk(clk),
	.reset(reset),
	.Next_PC(next_pc_w),
	.PC_Value(pc_w)
);

Program_Memory
#(
	.MEMORY_DEPTH(PROGRAM_MEMORY_DEPTH)
)
PROGRAM_MEMORY
(
	.Address_i(pc_w),
	.Instruction_o(instruction_bus_w)
);


Data_Memory
#(
	.MEMORY_DEPTH(PROGRAM_MEMORY_DEPTH)
)
DataMemory
(
	.Write_Data_i(read_data_2_w),
	.Address_i(alu_result_w),
	.clk(clk),
	.Mem_Write_i(mem_write_w),
	.Mem_Read_i(mem_read_w),
	.Read_Data_o(DataMemory_Result_w)
);

Adder_32_Bits
PC_PLUS_4
(
	.Data0(pc_w),
	.Data1(4),
	
	.Result(pc_plus_4_w)
);

Adder_32_Bits
PC_PLUS_IMM
(
	.Data0(pc_w),
	.Data1(inmmediate_data_w),
	
	.Result(pc_plus_imm)
);

//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/



Register_File
REGISTER_FILE_UNIT
(
	.clk(clk),
	.reset(reset),
	.Reg_Write_i(reg_write_w),
	.Write_Register_i(instruction_bus_w[11:7]),
	.Read_Register_1_i(instruction_bus_w[19:15]),
	.Read_Register_2_i(instruction_bus_w[24:20]),
	.Write_Data_i(alu_result_w),
	.Read_Data_1_o(read_data_1_w),
	.Read_Data_2_o(read_data_2_w)

);



Immediate_Unit
IMM_UNIT
(  .op_i(instruction_bus_w[6:0]),
   .Instruction_bus_i(instruction_bus_w),
   .Immediate_o(inmmediate_data_w)
);



Multiplexer_2_to_1
#(
	.NBits(32)
)
MUX_DATA_OR_IMM_FOR_ALU
(
	.Selector_i(alu_src_w),
	.Mux_Data_0_i(read_data_2_w),
	.Mux_Data_1_i(inmmediate_data_w),
	
	.Mux_Output_o(read_data_2_or_imm_w)

);

Multiplexer_2_to_1
#(
	.NBits(32)
)
MUX_for_WriteData
(
	.Selector_i(jal_w),
	.Mux_Data_0_i(DataMemory_or_AluResult_w),
	.Mux_Data_1_i(pc_plus_4_w),
	
	.Mux_Output_o(write_data_w)
	

);

Multiplexer_2_to_1
#(
	.NBits(32)
)
MUX_rs1plusimm_or_pc
(
	.Selector_i(jalr_w),
	.Mux_Data_0_i(PC_IMM_MIX_PC_4_w),
	.Mux_Data_1_i(alu_result_w),
	
	.Mux_Output_o(next_pc_w)

);

ALU_Control
ALU_CONTROL_UNIT
(
	.funct7_i(instruction_bus_w[30]),
	.ALU_Op_i(alu_op_w),
	.funct3_i(instruction_bus_w[14:12]),
	.ALU_Operation_o(alu_operation_w)

);



ALU
ALU_UNIT
(
	.ALU_Operation_i(alu_operation_w),
	.A_i(read_data_1_w),
	.B_i(read_data_2_or_imm_w),
	.ALU_Result_o(alu_result_w),
	.Zero_o(zero_w)
);

ANDGate
ZeroAndBranch_AND
(
	.A(Branch_w),
	.B(zero_w),
	.C(ZBrach_w)
);


Multiplexer_2_to_1
#(
	.NBits(32)
)
MUX_DataMemory_OR_ALUResult
(
	.Selector_i(mem_to_reg_w),
	.Mux_Data_0_i(alu_result_w),
	.Mux_Data_1_i(DataMemory_Result_w),
	
	.Mux_Output_o(DataMemory_or_AluResult_w)

);

Multiplexer_2_to_1
#(
	.NBits(32)
)
MUX_PC_IMM_OR_PC_4
(
	.Selector_i(ZBrach_w),
	.Mux_Data_0_i(pc_plus_4_w),
	.Mux_Data_1_i(pc_plus_imm),
	
	.Mux_Output_o(PC_IMM_MIX_PC_4_w)

);

assign out_top=write_data_w;
endmodule

