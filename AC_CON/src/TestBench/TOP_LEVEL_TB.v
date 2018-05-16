timeunit 1ns;
timeprecision 1ps;

module TOP_LEVEL_tb;


//Internal signals declarations:
logic [9:0]SEED;
logic [9:0]UI;
logic DAC;
logic SYS_CLK;
//logic SYS_CLK2;
logic A_RESET;
logic [3:0]PRNG;
logic M_ON_P;
logic M_ON_N;
logic M_ON;
logic ZC;  
logic UI_LT_EQ_PRNG;
logic MOTOR_D_P;
logic MOTOR_D_N;
logic MOTOR_DRIVE; 
logic[20:0] COUNT_ZERO;
logic[20:0] COUNT_MD;
logic[20:0] COUNT_PRNG_LOGIC;
logic[20:0] R_NEG;
logic SCLR_R_POS;
logic INC_R_POS;
logic[20:0] R_POS;



// Unit Under Test port map
	TOP_LEVEL UUT (
		.SEED(SEED),
		.UI(UI),
		.DAC(DAC),
		.SYS_CLK(SYS_CLK),
		//.SYS_CLK2(SYS_CLK2),
		.A_RESET(A_RESET),
		.PRNG(PRNG),
		.M_ON_P(M_ON_P),
		.M_ON_N(M_ON_N),
		.M_ON(M_ON),
		.ZC(ZC),
		.UI_LT_EQ_PRNG(UI_LT_EQ_PRNG),
		.MOTOR_D_P(MOTOR_D_P),
		.MOTOR_D_N(MOTOR_D_N),
		.MOTOR_DRIVE(MOTOR_DRIVE),
		.COUNT_ZERO(COUNT_ZERO),
		.COUNT_PRNG_LOGIC(COUNT_PRNG_LOGIC),
		.COUNT_MD(COUNT_MD),
		.R_NEG(R_NEG),
		.SCLR_R_POS(SCLR_R_POS),
		.INC_R_POS(INC_R_POS),
		.R_POS(R_POS));

time CLOCK_PERIOD=100ns;
time RUN_TIME=16000ns;

initial
	begin: CLOCK_GENERATOR 
	SYS_CLK='b0;
	forever
	begin  
	
	#(CLOCK_PERIOD/2);
	SYS_CLK=~SYS_CLK;
	
	end
	end	:CLOCK_GENERATOR 

						  
	
initial 
	begin: DAC_GENERATOR 
	DAC='b0;
	forever
	begin  
	
	#200ns;
	DAC=~DAC;
	
	end
	end	:DAC_GENERATOR 
	
initial 
	begin: INPUT_GENERATOR 
	SEED=4'b0001;
	UI=4'b0111;
	end:   INPUT_GENERATOR

initial
	begin: CONTROL
	A_RESET=1'b1;
	#50ns;
	A_RESET=1'b0;
	
	end: CONTROL	 
	
initial 
	begin: SYSTEM_RUN_TIME
	#RUN_TIME;
	$finish;
	end: SYSTEM_RUN_TIME

endmodule
