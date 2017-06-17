vlib work

vlog clock_divider.v
vlog pulse_timer.v
vlog ping_driver.v
vlog ping.v
vlog ping_tb.v

vsim ping_tb

add wave -position end sim:/ping_tb/DUT/clk_1MHz
add wave -position end sim:/ping_tb/DUT/reset
add wave -position end sim:/ping_tb/DUT/sensor
add wave -position end sim:/ping_tb/DUT/state
add wave -position end sim:/ping_tb/DUT/data_valid
add wave -position end sim:/ping_tb/DUT/distance_
add wave -position end sim:/ping_tb/DUT/distance_reg
add wave -position end sim:/ping_tb/DUT/listening

run -all
