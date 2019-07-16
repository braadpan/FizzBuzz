library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pulse_tb is
end pulse_tb;

architecture test of pulse_tb is

	constant CLK_PERIOD : time := 20 ns;
    
	signal clk		: std_logic;
	signal pulse	: std_logic;

begin

	-- DUT
	u_pulse : entity work.pulse
		generic map(
			DELAY => 3 us
		)
		port map(
			clk		=> clk,
			pulse	=> pulse);

	-- Generate clock
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
        
        wait until rising_edge(pulse);
		report "This is the time: " & time'image(now);
	
        
	end process test;
	

end test;
