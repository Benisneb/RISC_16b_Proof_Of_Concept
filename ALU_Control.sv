/***************************************************************************
*** *
*** ECE 526 | Final Proj - 16-b RISC Processor | Ben_Cooper | Fall, 2022 ***
*** ***
*** Final Project - Design of 16-b RISC Processor ***
*** ***
***************************************************************************
*** Filename: ALU_Control.v Created by Ben_Cooper, 5/10/22 ***
*** --- revision history, if any, goes here --- ***
***************************************************************************/
`timescale 1 ns / 100 ps

// ALU Control - Determines operation passed to ALU based on opcode
//	 	 Load performs ADD for 

module ALU_Control( ALU_OP, OPCODE, ALU_CNT );	
	import gP::*;
		
	input [1:0] ALU_OP;			input [3:0] OPCODE;
	// ALU_OP from ALU control unit		OPCODE from 
	
	wire [5:0] ALU_CHK;			output [2:0] ALU_CNT; 

	assign ALU_CHK = {ALU_OP, OPCODE};	// Concatonate ALU_OP w/ OPCODE to match localparam
			// ALU_OP | 10 - Load , 01 - Store | don't care about OPCODE for load/store
	
	localparam load = 6'b10xxxx;		localparam store = 6'b01xxxx;
	localparam additio = 6'b000010;		localparam subtrac = 6'b000011;
	localparam LogcNOT = 6'b000100;		localparam LShfLft = 6'b000101;
	localparam LShfRht = 6'b000110;		localparam LogcAND = 6'b000111;
	localparam LogcORR = 6'b001000;		localparam SetIfLT = 6'b001001;

	localparam ALU_ADD = 3'b000;		localparam ALU_SUB = 3'b001;
	localparam ALU_NOT = 3'b010;		localparam ALU_LSL = 3'b011;
	localparam ALU_LSR = 3'b100;		localparam ALU_AND = 3'b101;
	localparam ALU_ORR = 3'b110;		localparam ALU_SLT = 3'b111;

	reg [2:0] ALU_dat;			assign ALU_CNT = ALU_dat;
						// Assign ALU_CNT operation in dat

	always_comb begin
		casex(ALU_CHK) 
			load   : ALU_dat = ALU_ADD;	// Load/store uses add for + offset
			store  : ALU_dat = ALU_SUB;	// Branching uses sub for - offset
			additio: ALU_dat = ALU_ADD;	// Addition +
			subtrac: ALU_dat = ALU_SUB;	// A + 2's Compliment (Sub -)
			LogcNOT: ALU_dat = ALU_NOT;	// Logical Not ~
			LShfLft: ALU_dat = ALU_LSL;	// Logical Shift Left << (Mul)
			LShfRht: ALU_dat = ALU_LSR;	// Logical Shift Right >> (Div)
			LogcAND: ALU_dat = ALU_AND;	// Logical AND &
			LogcORR: ALU_dat = ALU_ORR;	// Logical ORR |
			SetIfLT: ALU_dat = ALU_SLT;	// Set on less than for SLT OPcode
			default: ALU_dat = ALU_ADD;	// Else addition
		endcase
	end			

endmodule
