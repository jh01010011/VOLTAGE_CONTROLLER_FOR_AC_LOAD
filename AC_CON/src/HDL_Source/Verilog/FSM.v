timeunit 1ns;
timeprecision 1ps;

module FSM (				
	input logic R_NEG_FLAG, //to check if there are skipped NEG cycle
	input logic R_POS_FLAG, //to check if there are skipped POS cycle
	input logic P_NEG_FLAG, //to check if previous cycle was NEG or not
	input logic P_POS_FLAG, //to check if previous cycle was POS or not
	input logic DAC, 	// digitalized AC signal 
	input logic UI_LT_EQ_PRNG, //to check PRNG  is less than or equal user input
	input logic SYS_CLK, //system clock	  
	//input logic SYS_CLK2,
	logic A_RESET, //Asynchronous reset
	
	output logic DEC_R_NEG, //to decrement reserved NEG cycle counter
	output logic INC_R_NEG, //to increment reserved NEG cycle counter
	output logic DEC_R_POS, //to decrement reserved POS cycle counter
	output logic INC_R_POS, //to increment reserved POS cycle counter 
	output logic M_ON_P,
	output logic M_ON_N,
	output logic M_ON, //motor drive on
	output logic ZC, //zero crossing
	output logic SCLR_PRNG, //to clear PRNG register
	output logic LOAD_PRNG, // to load in PRNG register
	output logic EN_PRNG, //enable the PRNG register
	output logic SCLR_R_NEG, //to clear the reserve NEG cycle counter
	output logic SCLR_R_POS, //to clear the reserve POS cycle counter
	output logic SCLR_N_FLAG, //to store O in previous NEG FLAG register
	output logic SCLR_P_FLAG, ////to store O in previous POS FLAG register
	logic LOAD_P_FLAG, //to store 1 in previous POS FLAG register
	logic LOAD_N_FLAG //to store 1 in previous NEG FLAG register
);

logic[1:0] P_STATE, N_STATE;

always_comb					

begin: NSOL

begin:NSL
N_STATE='bx;
case(P_STATE)

2'b00: N_STATE=2'b01;
2'b01: begin
	   if(DAC) N_STATE=2'b10;
	   else N_STATE=P_STATE;
	   end
2'b10: begin
	   if(DAC) N_STATE=P_STATE;
	   else N_STATE=2'b01;
	   end	
default: N_STATE='b0;
endcase

end:NSL

begin:OL
	 {DEC_R_NEG, INC_R_NEG, DEC_R_POS, INC_R_POS, M_ON,M_ON_P,M_ON_N, ZC, SCLR_PRNG, LOAD_PRNG, EN_PRNG}='b0;
	  {SCLR_R_NEG, SCLR_R_POS, SCLR_N_FLAG, SCLR_P_FLAG, LOAD_P_FLAG, LOAD_N_FLAG}='b0;	 
	  
	  case(P_STATE)
	  2'b00:begin
	  		LOAD_PRNG='b1;
			//{DEC_R_NEG, INC_R_NEG, DEC_R_POS, INC_R_POS, M_ON,M_ON_P,M_ON_N, ZC, SCLR_PRNG, EN_PRNG}='b0;
	  		//{SCLR_R_NEG, SCLR_R_POS, SCLR_N_FLAG, SCLR_P_FLAG, LOAD_P_FLAG, LOAD_N_FLAG}='b0;
	  		end
	  2'b01:begin
	  		EN_PRNG='b1;
			if(DAC)
				begin
				ZC='b1;
				if(UI_LT_EQ_PRNG)
					begin
					if(P_POS_FLAG)INC_R_POS='b1;		
					else
						begin
						M_ON='b1; 
						M_ON_P='b1;
						LOAD_P_FLAG='b1;
						SCLR_N_FLAG='b1;
						end
					end
				else
					begin
					if(!P_POS_FLAG)
					begin
					if(R_POS_FLAG)
						begin
						M_ON='b1; 
						M_ON_P='b1;
						LOAD_P_FLAG='b1;
						SCLR_N_FLAG='b1;
						DEC_R_POS='b1;
						end
					end
					end
				end
			end
			
		2'b10:begin
	  		EN_PRNG='b1;
			if(!DAC)
				begin
				ZC='b1;
				if(UI_LT_EQ_PRNG)
					begin
					if(P_NEG_FLAG)INC_R_NEG='b1;		
					else
						begin
						M_ON='b1;
						M_ON_N='b1;
						LOAD_N_FLAG='b1;
						SCLR_P_FLAG='b1;
						end
					end
				else
					begin
					if(!P_NEG_FLAG)
					begin
					if(R_NEG_FLAG) 
						begin
						M_ON='b1;
						M_ON_N='b1;
						LOAD_N_FLAG='b1;
						SCLR_P_FLAG='b1;
						DEC_R_NEG='b1;
						end
					end
					end
				end
			end	
	default: ;
	endcase
	  
end:OL
end:NSOL

always_ff @(posedge SYS_CLK, posedge A_RESET)
begin:PSR

if(A_RESET)P_STATE<='b0;
else P_STATE<=N_STATE;

end:PSR
endmodule:FSM
