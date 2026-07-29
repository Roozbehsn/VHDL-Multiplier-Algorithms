SetActiveLib -work
comp -include "$dsn\src\Main2.vhd" 
comp -include "$dsn\src\TestBench\multiplierentity_TB.vhd" 
asim +access +r TESTBENCH_FOR_multiplierentity 
wave 
wave -noreg answer_out
wave -noreg ans_ready_out
wave -noreg a_in
wave -noreg b_in
wave -noreg start_calc_in
wave -noreg clk
wave -noreg rst
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\multiplierentity_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_multiplierentity 
