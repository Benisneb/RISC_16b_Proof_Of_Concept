/*	Ben Cooper	526 - Final Project	16-b RISC Processor | Tables & Formats
________________________________________________________________________________________________
							|					|
		Instruction Formats			|	  Instruction Opcodes		|
 - - - - - - - - - - - - - - - - - - - - - - - - - - - -| - - - - - - - - - - - - - - - - - - - |
MEM - LOAD ( Read ) ::					|OPCs	Inst	Comment			|
							| - - - - - - - - - - - - - - - - - - - |
	X-X-X-X | X-X-X | X-X-X | X-X-X-X-X-X		|0000	LDR-0	Load word		|
	-OPCODE- -RegS1- -WrtDst-  -Offset-		|0001	STR-1	Store word		|
							|0010	ADD-2	Addition		|
	ld  WrtDst, Offset( RegS1 )			|0011	SUB-3	Subtraction		|
	WrtDst <= MEM [RegS1 + Offset]			|0100	INV-4	Invert (1's comp.)	|
							|0101	LSL-5	Logical Shift Left	|
MEM - STORE ( Write ) ::				|0110	LSR-6	Logical Shift Right	|
							|0111	AND-7	And			|
	X-X-X-X | X-X-X | X-X-X | X-X-X-X-X-X		|1000	OR--8	Or			|
	-OPCODE- -RegS1- -StrDst-  -Offset-		|1001	SLT-9	Set-On-Less-Than	|
							|1010	HMD-10	Hamming Distance	|
	st  StrDst, Offset( RegS1 )			|1011	BEQ-11	Branch if EQ		|
	MEM [RegS1 + Offset] => StrDst			|1100	BNE-12	Branch if NE		|
							|1101	JMP-13	Jump unconditional	|
Data Processing	::					|_______________________________________|
							|					|
	X-X-X-X | X-X-X | X-X-X | X-X-X | X-X-X		|	  ALU Control Operations	|
	-OPCODE- -RegS1- -RegS2- -WrtDst-  JUNK		| - - - - - - - - - - - - - - - - - - - | 	
							|ALU OP| OPc  | ALUcnt | Operat | Instr |  	
	OPc  WrtDst, RegS1, RegS2			| - - - - - - - - - - - - - - - - - - - |
	WrtDst <= RegS1 {OPc} RegS2			|10	xxxx	000	ADD - Load/Store|
							|01	xxxx	001	SUB - BNE / BEQ |
Branch ::						|00	0010	000	ADD - Data-Addng|
							|00	0011	001	SUB - Data-Subtr|
	X-X-X-X | X-X-X | X-X-X | X-X-X-X-X-X		|00	0100	010	INV - 1's complm|
	-OPCODE- -RegS1- -RegS2-  -Offset-		|00	0101	011	LSL - L.Lft Shft|
							|00	0110	100	LSR - L.Rht Shft|
	B{EQ/NE}  RegS1, RegS2, Offset			|00	0111	101	AND - And       |
	Branch -> [ PC + 2 + (Offset << 1) ]		|00	1000	110	OR  - Or        |
	---when rs1=rs2 EQ | when rs1 != rs2 NE 	|00	1001	111	SLT - Set-LesThn|
Jump ::							| - - - - - - - - - - - - - - - - - - - |
							|10  -> Load and store add offset to Rg |
	X-X-X-X | X-X-X-X-X-X-X-X-X-X-X-X		|01  -> Branch by subtraction 		|
	-OPCODE-     -Offset (Lable)-			|					|
							|					|
	JMP Offset->(PC[15:13], (Offset << 1 ))		|					|
________________________________________________________|_______________________________________|
								               |
		      Control Signals For Processor Unit                       |
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _|
       |       |       | Mem-> |Registr|  Mem  |  Mem  |       |       |       |
Instr. |Reg Dst|ALU Src|  Reg  | Write | Read  | Write |Branch | ALU_OP| Jump  |
-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|
Data Pr|   1   |  0    |   0   |   1   |  0    |  0    |  0    |  00   |  0    |
Load   |  0    |   1   |   1   |   1   |   1   |  0    |  0    |  10   |  0    | 
Store  |  0    |   1   |  0    |  0    |  0    |   1   |  0    |  10   |  0    |		
BEQ/NE |  0    |  0    |  0    |  0    |  0    |  0    |   1   |  01   |  0    |
Jump   |  0    |  0    |  0    |  0    |  0    |  0    |  0    |  00   |   1   |
_______|_______|_______|_______|_______|_______|_______|_______|_______|_______|			*/ 

`timescale 1 ns / 100 ps

`define block DM_Output.txt
`define	w 16

package	gP; 	// Global Parameters
	parameter width = 16;
	parameter rowInst = 15;
	parameter rowData = 8;
	parameter simTime = 160;

	// Structure of Jump operation
	typedef struct packed { bit[3:0] OPc;	bit[11:0] Offset; }	
									JUMP_struc;

	// Structure of Branch operation
	typedef struct packed { bit[3:0] OPc;	bit[2:0] rS1;	bit[2:0] rS2;	bit[5:0] Offset; } 
									BRANCH_struc;

	// Structure of Load/Store operation
	typedef struct packed { bit[3:0] OPc;	bit[2:0] rS1;	bit[2:0] rwO;	bit[5:0] Offset; } 
									LDnSW_struc;

	// Structure of DataProcess operation
	typedef struct packed { bit[3:0] OPc;	bit[2:0] rS1;	bit[2:0] rS2;	bit[2:0] rwO;
				bit[2:0] Offset; } 			DatPrc_struc;

	// Structure of Control Flags	
	typedef struct packed { bit RegDst, ALUsrc, M2R, RegWrite, MRead, 
				MWrite, BEQ, BNE, ALU_OP, JMP; }	Flags;

endpackage
