proc c {} {
	vlib fizzbuzz
	vcom -2008 -work fizzbuzz ../fizzbuzz/bcd_counter.vhd
	vcom -2008 -work fizzbuzz ../fizzbuzz/fizzbuzz.vhd
	vcom -2008 -work fizzbuzz fizzbuzz_tb.vhd
}

proc s {} {
	vsim fizzbuzz.fizzbuzz_tb
	add wave -position insertpoint sim:/fizzbuzz_tb/c_fizzbuzz/*
	radix signal sim:/fizzbuzz_tb/c_fizzbuzz/char ASCII
	run 100us
}

proc clr {} {
    .main clear
}