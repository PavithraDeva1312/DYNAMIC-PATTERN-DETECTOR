vlog dfsm2tb.v
vsim tb_dynamicfsm;
add wave -r sim:/tb_dynamicfsm/dut/*
run -all
