library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lcd_tb is
end lcd_tb;

architecture test of lcd_tb is

	constant CLK_PERIOD : time := 20 ns;
    
	signal clk     : std_logic;
	signal char    : std_logic_vector(7 downto 0);
	signal send    : std_logic;
	signal newline : std_logic;
    signal busy    : std_logic;
	
begin

	-- DUT
	c_lcd : entity work.lcd
		port map(
			clk      => clk,
			char     => char,
			send     => send,
			newline  => newline,
			busy     => busy,
			lcd_e    => open,
			lcd_rs   => open,
			lcd_rw   => open,
			lcd_data => open);

	-- Generate CLK signal
	generate_clk : process
	begin
		clk <= '1';
		wait for CLK_PERIOD / 2;
		clk <= '0';
		wait for CLK_PERIOD / 2;
	end process generate_clk;

	-- Test process
	test : process
	begin
        send    <= '0';
        newline <= '0';
        char    <= (others => '0');
        
        wait until busy = '0';
        wait until rising_edge(clk);
		send    <= '1';
        newline <= '1';
		wait until rising_edge(clk);
        send    <= '0';
        newline <= '0';
        
        wait until busy = '0';
        wait until rising_edge(clk);
        char    <= X"47"; -- G
        send    <= '1';
        wait until rising_edge(clk);
        char    <= (others => '0');
        send    <= '0';
        
	end process test;
	

end test;
