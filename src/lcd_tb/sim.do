proc c {} {   
	vlib lcd
	vcom -2008 -work lcd ../lcd/lcd.vhd
	vcom -2008 -work lcd lcd_tb.vhd
}

proc s {} {
	vsim lcd.lcd_tb
	add wave -position insertpoint sim:/lcd_tb/c_lcd/*
	radix signal sim:/lcd_tb/c_lcd/char ASCII
	run 10us
}

proc clr {} {
    .main clear
}

