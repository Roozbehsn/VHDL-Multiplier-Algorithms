SetActiveLib -work
comp -include "$dsn\src\Main.vhd" 
comp -include "$dsn\src\TestBench\multiplier4bit_TB.vhd" 
asim +access +r TESTBENCH_FOR_multiplier4bit 
wave 
wave -noreg A
wave -noreg B
wave -noreg S
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\multiplier4bit_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_multiplier4bit 
