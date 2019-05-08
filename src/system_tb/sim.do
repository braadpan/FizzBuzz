proc c {} {
	vlib work

	vcom -work work -2008 ../pulse/pulse.vhd ../lcd/lcd.vhd ../fizzbuzz/bcd_counter.vhd ../fizzbuzz/fizzbuzz.vhd ../top.vhd
	vlog -work work system_tb.sv
}

proc s {} {
	vsim work.system_tb 
	add wave -position insertpoint sim:/system_tb/fizzbuzz_top/*
	radix signal sim:/system_tb/fizzbuzz_top/char ASCII
	run 1us
}

proc clr {} {
    .main clear
}

c 
s 