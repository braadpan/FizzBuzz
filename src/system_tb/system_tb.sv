timeunit 1ns/10ps;

module system_tb();

	logic clk = 1;
	always #5 clk = ~clk;

	logic [7:0] LED, LCD_DATA;
	logic LCD_E, LCD_RS, LCD_RW; 

top fizzbuzz_top (
	.FPGA_CLK1_50(clk),
	.*);

endmodule