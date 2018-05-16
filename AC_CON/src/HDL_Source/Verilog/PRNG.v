timeunit 1ns;
timeprecision 1ps;


extern module PRNG (
	input logic SCLR_PRNG,
	logic LOAD_PRNG,
	logic EN_PRNG,
	logic [3:0] SEED,
	logic SYS_CLK,
	output logic[3:0] PRNG
);


module PRNG(.*); 

always_ff@(posedge SYS_CLK)
begin
	if(SCLR_PRNG)
	PRNG<=4'b0001; 
	else if(LOAD_PRNG) 
	PRNG<=SEED;
	else if(EN_PRNG) PRNG<={PRNG[2:0],(PRNG[3]^PRNG[0])};
end

endmodule :PRNG
