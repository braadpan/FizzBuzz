proc c {} {
	vlib work

	vcom -2008 -work work ../fizzbuzz/bcd_counter.vhd
	vcom -2008 -work work ../fizzbuzz/fizzbuzz.vhd
	vcom -2008 -work work fizzbuzz_tb.vhd
}

proc s {} {
	vsim work.fizzbuzz_tb
	add wave -position insertpoint sim:/fizzbuzz_tb/c_fizzbuzz/*
	radix signal sim:/fizzbuzz_tb/c_fizzbuzz/char ASCII
	run 100us
}

proc clr {} {
    .main clear
}

c 
s 