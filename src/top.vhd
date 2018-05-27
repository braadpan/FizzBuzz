library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
	port(
		FPGA_CLK1_50 : in  std_logic;
		
		--KEY          : in  std_logic_vector(1 downto 0);
		LED          : out std_logic_vector(7 downto 0);
		
		LCD_E        : out std_logic := '0';
		LCD_RS       : out std_logic := '0';
		LCD_RW       : out std_logic := '0';
		LCD_DATA     : out std_logic_vector(7 downto 0) := (others => '0'));
end top;

architecture structure of top is
	
	component sfl is
		port (
			noe_in : in std_logic := 'X'  -- noe
		);
	end component sfl;
	
	signal char		 : std_logic_vector(7 downto 0);
	signal send      : std_logic;
	signal newline   : std_logic;
    signal increment : std_logic;
	signal busy      : std_logic;
	
begin

	c_fizzbuzz : entity work.fizzbuzz
		port map(
			clk       => FPGA_CLK1_50,
			led       => LED,
			char      => char,
			send      => send,
			newline   => newline,
            increment => increment,
			busy      => busy);
			
	c_lcd : entity work.lcd
		port map(
			clk      => FPGA_CLK1_50,
			char     => char,
			send     => send,
			newline  => newline,
			busy     => busy,
			lcd_e    => LCD_E,
			lcd_rs   => LCD_RS,
			lcd_rw   => LCD_RW,
			lcd_data => LCD_DATA);
            
    e_pulse : entity work.pulse
        generic map(
            DELAY => 1000 ms)
        port map(
            clk   => FPGA_CLK1_50,
            pulse => increment);
			
	c_sfl : component sfl
		port map(
			noe_in => '0'); -- Enable the Serial Flash Loader IP

end structure;
