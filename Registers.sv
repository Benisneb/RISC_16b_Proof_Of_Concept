/***************************************************************************
*** *
*** ECE 526 | Final Proj - 16-b RISC Processor | Ben_Cooper | Fall, 2022 ***
*** ***
*** Final Project - Design of 16-b RISC Processor ***
*** ***
***************************************************************************
*** Filename: Registers.v Created by Ben_Cooper, 5/10/22 ***
*** --- revision history, if any, goes here --- ***
***************************************************************************/
//`include "globalDefine.sv"							
`timescale 1 ns / 100 ps				
							
// General purpose registers for instruction operations:
// 	OPc  WrtDst, RegS1, RegS2	
//	WrtDst <= RegS1 {OPc} RegS2
	
			 // 	  Addreses		   Data Bus'
			 // 3b-In  3b-In  3b-In   16b-O   16b-O   16b-In
module Registers( CLK, WEN, RegS1, RegS2, WrtDst, S1_Out, S2_Out, WriteData);	
	import gP::*;					input bit CLK, WEN;

	input [2:0] RegS1, RegS2, WrtDst;   		input [width-1:0] WriteData;    	
	// Address for S1, S2, and Write  		Write data as an input from bus

	output [width-1:0] S1_Out, S2_Out;	 	reg [width-1:0] regARR [rowData-1:0];	
	// Data Output for S1,S2			8 General Purpose 16b registers in mem		

	assign S1_Out = regARR[RegS1];			assign S2_Out = regARR[RegS2];
	// Assign S1 output from RegS1 addr		Assign S2 output from RegS2 addr
	
	initial begin
		for (shortint i=0; i<rowData; i=i+1) begin	
			regARR[i]=`w'd0; end		
	end		// Initialize all registers to 0

	always@( posedge CLK ) begin
		if ( WEN ) regARR[WrtDst] <= WriteData;
	end	// Write 16b on write bus to addressed memory reg

endmodule
