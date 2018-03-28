do FizzBuzz_run_msim_rtl_vhdl.do
 if {[file exists rtl_work]} {
 	vdel -lib rtl_work -all
 }
vlib rtl_work
vmap work rtl_work 

vcom -2008 -work work {C:/intelFPGA_lite/projects/FizzBuzz/src/top.vhd}
vcom -2008 -work work {C:/intelFPGA_lite/projects/FizzBuzz/src/serial.vhd}
vcom -2008 -work work {C:/intelFPGA_lite/projects/FizzBuzz/src/fizzbuzz.vhd}
vcom -2008 -work work {C:/intelFPGA_lite/projects/FizzBuzz/src/bcd_counter.vhd}
vcom -2008 -work work {C:/intelFPGA_lite/projects/FizzBuzz/src/fizzbuzz_tb.vhd}

vsim work.fizzbuzz_tb

add wave -position insertpoint sim:/fizzbuzz_tb/c_fizzbuzz/*
add wave -position insertpoint sim:/fizzbuzz_tb/c_fizzbuzz/c_serial/*
run 10us