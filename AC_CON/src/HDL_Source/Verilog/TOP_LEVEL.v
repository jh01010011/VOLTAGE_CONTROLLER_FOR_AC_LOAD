timeunit 1ns;
timeprecision 1ps;

module TOP_LEVEL (
	
	input logic [3:0] SEED,
	input logic [3:0] UI,
	input logic DAC,
	input logic SYS_CLK,
	//input logic SYS_CLK2,
	logic A_RESET,
	
	output logic[3:0] PRNG,	
	logic M_ON_P,
	logic M_ON_N,
	logic M_ON,
	logic ZC,
	logic  UI_LT_EQ_PRNG,
	logic MOTOR_D_P,
	logic MOTOR_D_N,
	logic MOTOR_DRIVE,
	logic SCLR_R_POS,
	logic INC_R_POS,
	logic [20:0] COUNT_ZERO,
	logic [20:0] COUNT_MD,
	logic [20:0] COUNT_PRNG_LOGIC,
	logic[20:0] R_NEG,
	logic[20:0] R_POS
);	
logic R_NEG_FLAG, R_POS_FLAG, P_NEG_FLAG, P_POS_FLAG, DEC_R_NEG, INC_R_NEG, DEC_R_POS, SCLR_PRNG, LOAD_PRNG, EN_PRNG, SCLR_R_NEG, SCLR_N_FLAG ;
logic SCLR_P_FLAG, LOAD_P_FLAG, LOAD_N_FLAG;

FSM F(.*);
DATA_PATH DP(.*);
always_ff@(posedge SYS_CLK, posedge A_RESET)
begin:MOTOR_CON
	if(A_RESET)
	begin
	COUNT_ZERO<='b0;
	COUNT_MD<='b0;
	end
	 if(ZC)
	 	begin
		COUNT_ZERO<=COUNT_ZERO+1;
	 	if(M_ON)
			begin
			MOTOR_DRIVE=1'b1;
			COUNT_MD<=COUNT_MD+1;
			end
		else MOTOR_DRIVE=1'b0;
	 	end
end:MOTOR_CON

always_ff@(posedge SYS_CLK, posedge A_RESET)
begin:COUNT_PRNG_LOGIC_TRUE
	if(A_RESET)
	begin
	COUNT_PRNG_LOGIC<='b0;
	end
	 if(ZC)
	 	begin
	 	if(UI_LT_EQ_PRNG)
			begin
			COUNT_PRNG_LOGIC<=COUNT_PRNG_LOGIC+1;
			end
		//else MOTOR_DRIVE=1'b0;
	 	end
end:COUNT_PRNG_LOGIC_TRUE

always_ff@(posedge SYS_CLK)
begin:MOTOR_CON_P	
	 if(ZC)
	 	begin
	 	if(M_ON_P)
			begin
			MOTOR_D_P=1'b1;
			end
		else MOTOR_D_P=1'b0;
	 	end
end:MOTOR_CON_P


always_ff@(posedge SYS_CLK)
begin:MOTOR_CON_N	
	 if(ZC)
	 	begin
	 	if(M_ON_N)
			begin
			MOTOR_D_N=1'b1;
			end
		else MOTOR_D_N=1'b0;
	 	end
end:MOTOR_CON_N	  



endmodule
