/***************************************************************************
*** *
*** ECE 526 | Final Proj - 16-b RISC Processor | Ben_Cooper | Fall, 2022 ***
*** ***
*** Final Project - Design of 16-b RISC Processor ***
*** ***
***************************************************************************
*** Filename: test_16b_RISC.v Created by Ben_Cooper, 5/10/22 ***
*** --- revision history, if any, goes here --- ***
***************************************************************************/

`timescale 1 ns / 100 ps

// 16b-RISC - Datapath DTP takes in clock, flags,  and ALU_OP as inputs then returns OPCODE
//	      Control CTR takes in clock, and OPCODE as input, returns ALU_OP and flags

module test_16b_RISC;	
	import gP::*;
		
	reg clk;		

	RISC_16b u1( .Clock( clk ) );

	initial begin
		$vcdpluson;	// Graphical viewer (waveforms)
		clk = 0;
		#simTime;
		$finish;
	end	

	always #5 clk = ~clk;

endmodule
