timeunit 1ns;
timeprecision 1ps;

module DATA_PATH (
	
	input logic SYS_CLK,
	logic A_RESET,
	input logic LOAD_N_FLAG,
	input logic LOAD_P_FLAG,
	input logic SCLR_P_FLAG,
	input logic SCLR_N_FLAG,
	input logic SCLR_R_POS,
	input logic SCLR_R_NEG,
	input logic EN_PRNG,
	input logic LOAD_PRNG,
	input logic SCLR_PRNG,
	input logic INC_R_POS,
	input logic DEC_R_POS,
	input logic INC_R_NEG,
	input logic DEC_R_NEG,
	input logic [3:0] UI,
	input logic [3:0] SEED,
	
	output logic UI_LT_EQ_PRNG,
	output logic P_POS_FLAG,
	output logic P_NEG_FLAG,
	output logic R_POS_FLAG,
	output logic R_NEG_FLAG,
	logic[3:0] PRNG,
	logic[20:0] R_NEG,
	logic[20:0] R_POS
);  

PRNG P1(.*);

always_ff@(posedge SYS_CLK,posedge A_RESET)
begin:SKIPPED_NUM_OF_POS_CYCLE
	if(A_RESET)R_POS<='b0;
	else if(SCLR_R_POS)R_POS<='b0;
	else if(INC_R_POS)R_POS<=R_POS+1;
	else if(DEC_R_POS)R_POS<=R_POS-1;
end:SKIPPED_NUM_OF_POS_CYCLE

always_ff@(posedge SYS_CLK,posedge A_RESET)
begin:SKIPPED_NUM_OF_NEG_CYCLE
	if(A_RESET)R_NEG<='b0;
	else if(SCLR_R_NEG)R_NEG<='b0;
	if(INC_R_NEG)R_NEG<=R_NEG+1;
	else if(DEC_R_NEG)R_NEG<=R_NEG-1;
end:SKIPPED_NUM_OF_NEG_CYCLE

always_ff@(posedge SYS_CLK)
begin:PREVIOUS_POS_FLAG_REGISTER
	if(SCLR_P_FLAG)P_POS_FLAG<=1'b0;
	else if(LOAD_P_FLAG)P_POS_FLAG<=1'b1;

end:PREVIOUS_POS_FLAG_REGISTER

always_ff@(posedge SYS_CLK)
begin:PREVIOUS_NEG_FLAG_REGISTER
	if(SCLR_N_FLAG)P_NEG_FLAG<=1'b0;
	else if(LOAD_N_FLAG)P_NEG_FLAG<=1'b1;

end:PREVIOUS_NEG_FLAG_REGISTER	

always_comb 
begin:UI_PRNG_COM
   if(PRNG<=UI)UI_LT_EQ_PRNG='b1;
   else UI_LT_EQ_PRNG='b0;
end:UI_PRNG_COM
always_comb 
begin:R_POS_FLAG_COM
	if(R_POS>0)R_POS_FLAG=1'b1;
	else R_POS_FLAG=1'b0;
end:R_POS_FLAG_COM 
always_comb 
begin:R_NEG_FLAG_COM
	if(R_NEG>0)R_NEG_FLAG=1'b1;
	else R_NEG_FLAG=1'b0;
end:R_NEG_FLAG_COM


endmodule: DATA_PATH
