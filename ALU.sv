/***************************************************************************
*** *
*** ECE 526 | Final Proj - 16-b RISC Processor | Ben_Cooper | Fall, 2022 ***
*** ***
*** Final Project - Design of 16-b RISC Processor ***
*** ***
***************************************************************************
*** Filename: ALU.sv Created by Ben_Cooper, 5/10/22 ***

*** --- revision history, if any, goes here --- ***

always@( OPCODE, tempR ) begin
	if ( OE == 0 ) FLAG[3:0] = 'bZ;	
	if (CLK == 1'b1) begin
		// Check Negative Flag
		if ( tempR[width-1] == 1 )	
			begin	FLAG[1] = 1'b1; 	end 
			else	begin	FLAG[1] = 1'b0;	end

		// Check Zero Flag
		if ( ( |tempR ) == 1'b0 )
			begin	FLAG[0] = 1'b1;	end
			else	begin	FLAG[0] = 1'b0;	end
		
		// Check Carry Flag
		if ( ( (tempR[width] == 1) && (OPCODE == additio) ) | 
		     ( (tempR[width] == 1) && (OPCODE == subtrac) && (A < B) ) )	
			begin	FLAG[3] = 1'b1;	end
			else	begin	FLAG[3] = 1'b0;	end

		// Check Overflow Flag
		if ( ( tempR[width-1] != A[width-1] ) && ( A[width-1] == B[width-1] ) )
			begin	FLAG[2] = 1'b1;	end
			else	begin	FLAG[2] = 1'b0;	end
		
		// Check if OE = 0 last, if so -> Z's
		if ( OE == 0 ) FLAG[3:0] = 'bZ;	

	end 	
end
	
***************************************************************************/
`timescale 1 ns / 100 ps

// ALU - In this design the ALU has a zero flag and result as output
//	 ALU_OP from ALU control unit, FSM

module ALU( ALU_OP, A, B, ALU_OUT, ZF);	
	import gP::*;
		
	input [2:0] ALU_OP;			output ZF;
	// ALU_OP from ALU control unit		Zero in ALU - flag
		
	input [width-1:0] A, B;			output [width-1:0] ALU_OUT;
	// Input registers for arith		// Result of ALU operation

	// No need for CLK, ALU is combinationally triggered not by CLK
	//	- Below are ALU operation mappings to ALU_OP
	
	localparam additio = 3'b000;		localparam subtrac = 3'b001;
	localparam LogcNOT = 3'b010;		localparam LShfLft = 3'b011;
	localparam LShfRht = 3'b100;		localparam LogcAND = 3'b101;
	localparam LogcORR = 3'b110;		localparam SetIfLT = 3'b111;

	logic [width:0] ALU_dat;	

	assign ALU_OUT = ALU_dat[width-1:0];		assign ZF = (ALU_OUT == `w'd0) ? 1'b1 : 1'b0;
	// Assign ALU_OUT with result of op		// Assign zero flag if ALU_OUT = 0

	assign Au = (A < 0) ? ~A : A;			assign Bu = (B < 0) ? ~B : B;
	// Handling of signed values			Return signed to unsigned

	always_comb begin
		case(ALU_OP) 
			additio: ALU_dat = Au + Bu;		// Addition +
			subtrac: ALU_dat = Au + (~Bu + 1);	// A + 2's Compliment (Sub -)
			LogcNOT: ALU_dat = ~Au;			// Logical Not ~
			LShfLft: ALU_dat = Au << Bu;		// Logical Shift Left << (Mul)
			LShfRht: ALU_dat = Au >> Bu;		// Logical Shift Right >> (Div)
			LogcAND: ALU_dat = Au & Bu;		// Logical AND &
			LogcORR: ALU_dat = Au | Bu;		// Logical ORR |
			SetIfLT: begin				// Set ALU_OUT = (A<B) ? 1 : 0;
				if (Au<Bu) ALU_dat = 16'b1;	
				else ALU_dat = 16'b0;		end	
			default: ALU_dat = Au + Bu;		// Else addition
		endcase
	end			

endmodule
