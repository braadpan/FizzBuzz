proc c {} {   
	vlib work
	vcom -2008 -work work ../pulse/pulse.vhd
	vcom -2008 -work work pulse_tb.vhd
}

proc s {} {
	vsim work.pulse_tb
	
	add wave -position insertpoint sim:/pulse_tb/u_pulse/*
	run 20 us
}

proc clr {} {
    .main clear
}

c
s