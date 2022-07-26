/***************************************************************************
*** *
*** ECE 526 | Final Proj - 16-b RISC Processor | Ben_Cooper | Fall, 2022 ***
*** ***
*** Final Project - Design of 16-b RISC Processor ***
*** ***
***************************************************************************
*** Filename: Data_Memory.v Created by Ben_Cooper, 5/10/22 ***
*** --- revision history, if any, goes here --- ***
***************************************************************************/
//`include "globalDefine.sv"							
`timescale 1 ns / 100 ps				
							
// Data Memory - stores
	
	    	 // 	  Instructions	       Strobes
	    	 // 16b-I  16b-I     16b-O    1-I  1-I
module DatMem( CLK, ADDR,  WriteDat, ReadDat, WEN, REN );
	import gP::*;					integer writeFilePointer;

	input [width-1:0] ADDR, WriteDat;   		output  [width-1:0] ReadDat;    	
	// Address for S1, S2, and Write  		Write data as an input from bus

	input bit CLK, WEN, REN;		// Clock, write/read strobes			

	reg [width-1:0] mem [rowData-1:0];	//8 x 16 memory registers in mem		

	reg [2:0] WrtDst;				assign WrtDst = ADDR [2:0];
	// Address from instruction			continously assign address to reg	

	assign 	ReadDat = (REN) ? mem[WrtDst] : 16'b0;	// ReadDat driven w/ mem@ ADDR
								//	only if REN=1 WEN=0
	initial begin
		//for (shortint i=0; i<rowData; i=i+1) begin	
		//	mem[i]=`w'b0; end	// Initialize all registers to 0
		
		$readmemb("test.data", mem);	// Load data for internal start
			
		writeFilePointer = $fopen("DM_Output.txt", "w");	// Opens file to write/read to

		// $fdisplayb( writeFilePointer, "%8b",  )
		
		$fmonitor ( writeFilePointer, "Time: %3d | Register States\n", $time,
			"\tReg0[%b]\n", mem[0], "\tReg1[%b]\n", mem[1], "\tReg2[%b]\n", mem[2], 
			"\tReg3[%b]\n", mem[3], "\tReg4[%b]\n", mem[4], "\tReg5[%b]\n", mem[5], 
			"\tReg6[%b]\n", mem[6], "\tReg7[%b]\n", mem[7]);
		
		#simTime; 
		$fclose( writeFilePointer );
	end		

	always@( posedge CLK ) begin
		if ( WEN ) mem[WrtDst] <= WriteDat;
	end	// Write 16b on write bus to addressed memory reg

endmodule

// Read reg 1/2, write reg, write data, 
// Read data 1/2, 	//regWrite
