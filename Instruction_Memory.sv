/***************************************************************************
*** *
*** ECE 526 | Final Proj - 16-b RISC Processor | Ben_Cooper | Fall, 2022 ***
*** ***
*** Final Project - Design of 16-b RISC Processor ***
*** ***
***************************************************************************
*** Filename: Instruction_Memory.v Created by Ben_Cooper, 5/10/22 ***
*** --- revision history, if any, goes here --- ***
***************************************************************************/

`timescale 1 ns / 100 ps

// Instruction Memory, takes 16 bit instruction address as input, returns instruction

module IM( PC, Instr );	
	import gP::*;	

	input  [15:0] PC;   			output [15:0] Instr;    	
	// Program Counter Input   		Instruction to be computed

	reg [width-1:0] mem [width-1:0];	wire [3:0]ADDR = PC[4:1];
	// Memory is 16 bits x 8 lines		// Grab address from PC address fields
	
	initial begin
		//for (shortint i=0; i<rowData; i=i+1) begin	
		//	mem[i]=`w'b0; end		// Initialize all to 0
		$readmemb("testIM.prog",mem); 	
	end	// Load Data from file start @_0b, end @_14b
	
	assign Instr = mem[ADDR];	
	
endmodule

