/***************************************************************************
*** *
*** ECE 526 | Final Proj - 16-b RISC Processor | Ben_Cooper | Fall, 2022 ***
*** ***
*** Final Project - Design of 16-b RISC Processor ***
*** ***
***************************************************************************
*** Filename: 16b_RISC.v Created by Ben_Cooper, 5/10/22 ***
*** --- revision history, if any, goes here --- ***
***************************************************************************/

`timescale 1 ns / 100 ps

// 16b-RISC - Datapath DTP takes in clock, flags,  and ALU_OP as inputs then returns OPCODE
//	      Control CTR takes in clock, and OPCODE as input, returns ALU_OP and flags

module RISC_16b( Clock );	
	import gP::*;
		
	input Clock;		wire [1:0] ALU_OP;		wire [3:0] OPc;

	wire jmp, beq, bne, mRead, mWrite, aluSrc, regDst, m2R, regWrite;

	// Datapath( clk, JMP, BEQ, BNE, MRead, MWrite, ALUsrc, RegDst, M2R, RegWrite, ALU_op, OPCODE );
	Datapath DTP(Clock, jmp, beq, bne, mRead , mWrite, aluSrc, regDst, m2R, regWrite, ALU_OP, OPc);
	
	// Control( JMP, BEQ, BNE, MRead, MWrite, ALUsrc, RegDst, M2R, RegWrite, ALU_OP, OPCODE );
	Control CTR( jmp, beq, bne, mRead , mWrite, aluSrc, regDst, m2R, regWrite, ALU_OP, OPc );
		
endmodule
