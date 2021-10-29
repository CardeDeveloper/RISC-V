/******************************************************************
* Description
*	This module performs a sign extension operation that is need with
*	in instruction like andi and constructs the immediate constant.
* Version:
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	16/08/2021
******************************************************************/
module Immediate_Unit
(   
	input [6:0] op_i,
	input [31:0]  Instruction_bus_i,
	
   output reg [31:0] Immediate_o
);
//opcodes
localparam Type_I= 7'h13;
localparam Type_U= 7'h37;
localparam Type_B= 7'h63;
localparam Type_S= 7'h23;
localparam Type_J= 7'h6f;
localparam Type_I_LW= 7'h03;
localparam Type_I_jalr= 7'h67;

//assign Immediate_o = (op_i == 7'h13) ?{{20{Instruction_bus_i[31]}},Instruction_bus_i[31:20]}:
//VALOR_2:;

always@(op_i or Instruction_bus_i) begin
//concat each imm size fr each instruction
	case(op_i)
	Type_I:
		Immediate_o = {{20{Instruction_bus_i[31]}},Instruction_bus_i[31:20]};// I format
	Type_I_LW:
		Immediate_o = {{20{Instruction_bus_i[31]}},Instruction_bus_i[31:20]};// for Lw format	
	Type_I_jalr:
		Immediate_o = {{20{Instruction_bus_i[31]}},Instruction_bus_i[31:20]};// for jalr format	
	Type_U:
		Immediate_o = {{11{Instruction_bus_i[31]}},Instruction_bus_i[31:12]};// U format
	Type_B:
		Immediate_o = {{19{Instruction_bus_i[31]}},Instruction_bus_i[31],Instruction_bus_i[7],Instruction_bus_i[30:25],Instruction_bus_i[11:8],1'b0};// B format
	Type_S:
		Immediate_o = {{20{Instruction_bus_i[31]}},Instruction_bus_i[31:25],Instruction_bus_i[11:7]};// S format	
	Type_J:
		Immediate_o = {{11{Instruction_bus_i[31]}},Instruction_bus_i[31],Instruction_bus_i[19:12],Instruction_bus_i[20],Instruction_bus_i[30:21],1'b0};// J format	

	default:
			Immediate_o= 7'h00;
	endcase
end

endmodule // signExtend
