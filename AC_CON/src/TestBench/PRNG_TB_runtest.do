setactivelib -work
#Compiling UUT module design files

comp -include "$dsn\src\TestBench\PRNG_TB.v"
asim +access +r PRNG_tb

wave
wave -noreg SCLR
wave -noreg LOAD
wave -noreg EN
wave -noreg SEED
wave -noreg SYS_CLK
wave -noreg PRN

run

#End simulation macro
