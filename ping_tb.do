vlib work

vlog clock_divider.v
vlog pulse_timer.v
vlog ping_driver.v
vlog ping.v
vlog ping_tb.v

vsim ping_tb

add wave -position end sim:/ping_tb/DUT/*

run -all
