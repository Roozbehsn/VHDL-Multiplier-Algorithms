SetActiveLib -work
comp -include "$dsn\src\Main 1.vhd" 
comp -include "$dsn\src\TestBench\multiplier_3x3_TB.vhd" 
asim +access +r TESTBENCH_FOR_multiplier_3x3 
wave 
wave -noreg clk
wave -noreg reset
wave -noreg start
wave -noreg multiplier
wave -noreg multiplicand
wave -noreg product
wave -noreg done
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\multiplier_3x3_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_multiplier_3x3 
