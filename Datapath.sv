/***************************************************************************
*** *
*** ECE 526 | Final Proj - 16-b RISC Processor | Ben_Cooper | Fall, 2022 ***
*** ***
*** Final Project - Design of 16-b RISC Processor ***
*** ***
***************************************************************************
*** Filename: Datapath.v Created by Ben_Cooper, 5/10/22 ***
*** --- revision history, if any, goes here --- ***
***************************************************************************/

`timescale 1 ns / 100 ps

// Datapath - Assigning connections between modules and wires
//	    - Conditional assignment (Multiplexor's) for tristate

module Datapath( clk, JMP, BEQ, BNE, MRead, MWrite, ALUsrc, RegDst, M2R, RegWrite, ALU_op, OPCODE );	
	import gP::*;
		
	input bit clk, JMP, BEQ, BNE, MRead, MWrite, ALUsrc, RegDst, M2R, RegWrite;
	// Recieve Flag's and CLK as input to determine OPCODE
	
	input [1:0] ALU_op;			output [3:0] OPCODE;
						// Calculates opcode based on inputs/state
	
	reg [width-1:0] PC_;		// Program counter, points to current instr. address

	wire [2:0] wrtDst, regS1, regS2, ALU_cnt;		wire [12:0] Jshift;
	// Internal operands for instructions + ALU control	// Offset for JMP (11:0 shifted L)	

	wire [width-1:0] PCn1, PCn2, Instr_, S1_O, S2_O, WriteData_, ALU_O, a, b, memDatRead, 				       im_Ext, ALU_B, J, BEQa, BNEa, PCn2_or_BEQ, PCn2_or_BXX;
	wire Z;		    // Inner Connections PCn1 is next state, PCn2 points to inst after PCn1


	initial PC_ <= 16'b0;			always@(posedge clk) PC_ <= PCn1;
	// Start program counter @ 0		At every rising clock edge, move to next PC addr

		// IM( PC, Instr );
		IM Inst_Mem( .PC( PC_ ), .Instr( Instr_ ) );	

		// DatMem( CLK, ADDR,  WriteDat, ReadDat, WEN, REN );	
		DatMem DM1( .CLK( clk ), .ADDR( ALU_O ),  .WriteDat( S2_O ), .ReadDat( memDatRead ), 
			.WEN( MWrite ), .REN( MRead ) );

		// ALU_Control( ALU_OP, OPCODE, ALU_CNT );
		ALU_Control aluCTR( .ALU_OP( ALU_op ), .OPCODE( Instr_[15:12] ), .ALU_CNT( ALU_cnt ) );

		// ALU( ALU_OP, A, B, ALU_OUT, ZF);
		ALU alu( .ALU_OP( ALU_cnt ), .A( S1_O ), .B( ALU_B ), .ALU_OUT( ALU_O ), .ZF( Z ) );

		// Registers( CLK, WEN, RegS1, RegS2, WrtDst, S1_Out, S2_Out, WriteData);
		Registers regList( .CLK( clk ), .WEN( RegWrite ) , .RegS1( regS1 ), .RegS2( regS2 ),
		   .WrtDst( wrtDst ), .S1_Out( S1_O ), .S2_Out( S2_O ), .WriteData( WriteData_ ) );

	assign PCn2 = PC_ + 16'd2;	// PCn2 = PC+2 for next address given no jump/branch	

	assign Jshift = {Instr_[11:0], 1'b0};		assign J = { PCn2[15:13], Jshift };
	//Jshift = Offset << 1				Jump instruct = Old PCn2 with Jump offset

	assign wrtDst = (RegDst) ? Instr_[5:3] : Instr_[8:6];
	// Write destination is OP3 (write dest) if RegDst=1, otherwise wrtDst => RegS2 addr

	assign regS1 = Instr_[11:9];	assign regS2 = Instr_[8:6];
	// Assign internal regS1 & regS2 with respective addresses

	assign im_Ext = { {10{Instr_[5]}} , Instr_[5:0] };
	// Immediate extension turns INSTR_[5:0] ---> xxxx_xxxx_xx54 3210 [x = bit 5 repeated]

	assign  ALU_B = (ALUsrc) ? im_Ext : S2_O;
	// If ALUsrc = 1, IM_Ext becomes ALU_B | Otherwise ALU_B remains S2_0

	assign BEQa = PCn2 + { im_Ext[14:0] , 1'b0 };	assign BNEa = PCn2 + { im_Ext[14:0] , 1'b0 };
	// Concatenate Immediate signed extension with 1 in LSB spot, add this to PCn2 for BEQ/NE

	assign PCn2_or_BEQ = (BEQ & Z) ? BEQa : PCn2;		// If no BEQ/NE load PCn2 like usual
	assign PCn2_or_BXX = (BNE & !Z) ? BNEa : PCn2_or_BEQ;	// If BEQ/NE & Z or !Z, load B addr

	assign PCn1 = (JMP) ? J : PCn2_or_BXX;		// Jump to J addr if JMP, else PCn2 or Branch	

	assign WriteData_ = (M2R) ? memDatRead : ALU_O;		// If M2R cont sig, then output of
								// DataMemory read -> WriteData regList 

	assign OPCODE = Instr_[15:12];		// Output OPCODE from instruction opcode	

endmodule
