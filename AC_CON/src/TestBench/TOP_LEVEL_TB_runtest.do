setactivelib -work
#Compiling UUT module design files

comp -include "$dsn\src\TestBench\TOP_LEVEL_TB.v"
asim +access +r TOP_LEVEL_tb

wave
wave -noreg SEED
wave -noreg UI
wave -noreg DAC
wave -noreg SYS_CLK
wave -noreg A_RESET
wave -noreg PRNG
wave -noreg M_ON
wave -noreg ZC
wave -noreg MOTOR_DRIVE

run

#End simulation macro
