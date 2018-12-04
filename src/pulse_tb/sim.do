proc c {} {   
	vlib pulse
	vcom -2008 -work pulse ../pulse/pulse.vhd
	vcom -2008 -work pulse pulse_tb.vhd
}

proc s {} {
	vsim pulse.pulse_tb
	
	add wave -position insertpoint sim:/pulse_tb/u_pulse/*
	run 10 us
}

proc clr {} {
    .main clear
}

