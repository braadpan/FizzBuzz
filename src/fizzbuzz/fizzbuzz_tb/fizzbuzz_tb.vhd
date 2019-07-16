library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fizzbuzz_tb is
end fizzbuzz_tb;

architecture test of fizzbuzz_tb is

	constant CLK_PERIOD : time := 20 ns;
	
	signal clk       : std_logic;
	signal busy      : std_logic;
    signal increment : std_logic;
	
begin

	-- DUT
	c_fizzbuzz : entity work.fizzbuzz
		port map(
			clk       => clk,
			led       => open,
			char      => open,
			send      => open,
			newline   => open,
            increment => increment,
			busy      => busy);
			
	-- Test process
	PBusy : process
	begin
		busy <= '0';
		wait for 20 * CLK_PERIOD;
		busy <= '1';
		wait for 5 * CLK_PERIOD;
	end process;
    
    PIncrement : process
    begin
        increment <= '0';
        wait for 60 * CLK_PERIOD;
		increment <= '1';
		wait for 1 * CLK_PERIOD;
	end process;
	
	-- Generate CLK signal
	generate_clk : process
	begin
		clk <= '1';
		wait for CLK_PERIOD / 2;
		clk <= '0';
		wait for CLK_PERIOD / 2;
	end process generate_clk;


end test;
