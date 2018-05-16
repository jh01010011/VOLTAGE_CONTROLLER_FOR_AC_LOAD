timeunit 1ns;
timeprecision 1ps;

module PRNG_tb;

logic SCLR;
logic LOAD;
logic EN;
logic [9:0]SEED;
logic SYS_CLK;
logic [9:0]PRN;



// Unit Under Test port map
	PRNG UUT (
		.SCLR(SCLR),
		.LOAD(LOAD),
		.EN(EN),
		.SEED(SEED),
		.SYS_CLK(SYS_CLK2),
		.PRN(PRN));

time CLOCK_PERIOD=100ns;
time RUN_TIME=10000ns;

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
	begin: INPUT_GENERATOR
	SEED=10'b0000000101;
	
	fork 
	forever
	begin
	#5000ns;
	SEED=SEED+3;
	end	 
	join
	end: INPUT_GENERATOR

initial
	begin: CONTROL
	SCLR=1'b1;
	LOAD=1'b0;
	EN=1'b0;
	#100ns;
	SCLR=1'b0;
	LOAD='b1;
	EN=1'b0;
	#100ns;
	LOAD='b0;
	EN='b1;
	#4400ns;
	SCLR='b1;
	#4600ns;
	SCLR='b0;
	EN='b1;
	
	end: CONTROL	 
	
initial 
	begin: SYSTEM_RUN_TIME
	#RUN_TIME;
	$finish;
	end: SYSTEM_RUN_TIME

endmodule
