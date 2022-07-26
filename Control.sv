/***************************************************************************
*** *
*** ECE 526 | Final Proj - 16-b RISC Processor | Ben_Cooper | Fall, 2022 ***
*** ***
*** Final Project - Design of 16-b RISC Processor ***
*** ***
***************************************************************************
*** Filename: Control.v Created by Ben_Cooper, 5/10/22 ***
*** --- revision history, if any, goes here --- ***
***************************************************************************/

`timescale 1 ns / 100 ps

// Control - Determines operation passed to ALU based on opcode
//	 	 Load performs ADD for 

module Control( JMP, BEQ, BNE, MRead, MWrite, ALUsrc, RegDst, M2R, RegWrite, ALU_OP, OPCODE );	
	import gP::*;
		
	output bit JMP, BEQ, BNE, MRead, MWrite, ALUsrc, RegDst, M2R, RegWrite;
	
	output [1:0] ALU_OP;			input [3:0] OPCODE;

	localparam ALU_LDR = 4'b0000;		localparam ALU_STR = 4'b0001;
	localparam ALU_BEQ = 4'b1011;		localparam ALU_BNE = 4'b1100;
	localparam ALU_JMP = 4'b1101;

/*	Flags for each type of instruction: Translated into Hex	--> 0xxx_xxxx_xxxx
				    0_  3  |   4   |   4 	- > Hex
	ALU_LDR:	contFlags = { 0,1,1,1,1,0,0,0,10,0 };	// Load Contr 0x3C4
	ALU_STR:	contFlags = { 0,1,0,0,0,1,0,0,10,0 };	// Store Contr 0x224
	ALU_DAT:	contFlags = { 1,0,0,1,0,0,0,0,00,0 }; 	// Data Process 0x480
	ALU_BEQ:	contFlags = { 0,0,0,0,0,0,1,0,01,0 };	// BEQ Contr 0x012
	ALU_BNE:	contFlags = { 0,0,0,0,0,0,0,1,01,0 };	// BEQ Contr 0x00A 
	ALU_JMP:	contFlags = { 0,0,0,0,0,0,0,0,00,1 };	// BNE Contr 0x001	*/

	localparam LDRflags_hex = 11'h3C4;	localparam STRflags_hex = 11'h224;
	localparam OPCflags_hex = 11'h480;	localparam BEQflags_hex = 11'h012;
	localparam BNEflags_hex = 11'h00A;	localparam JMPflags_hex = 11'h001;			

	reg [10:0] contFlags;
	
	assign{ RegDst, ALUsrc,M2R, RegWrite, MRead, 
                MWrite, BEQ, BNE, ALU_OP, JMP } =contFlags;
		
	always_comb begin
		case(OPCODE)				
			ALU_LDR: 		contFlags = { LDRflags_hex };	// Load Contr
			ALU_STR:		contFlags = { STRflags_hex };	// Store Contr
			2,3,4,5,6,7,8,9:	contFlags = { OPCflags_hex }; 	// Data Process
			ALU_BEQ:		contFlags = { BEQflags_hex };	// BEQ Contr
			ALU_BNE:		contFlags = { BNEflags_hex };	// BEQ Contr
			ALU_JMP:		contFlags = { JMPflags_hex };	// BNE Contr
			default:		contFlags = { OPCflags_hex }; 	// Data Process
		endcase
	end		
endmodule
