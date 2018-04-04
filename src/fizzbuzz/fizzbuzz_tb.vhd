library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fizzbuzz_tb is
end fizzbuzz_tb;

architecture test of fizzbuzz_tb is

	component fizzbuzz
		port(
			clk    : in  std_logic;
			led    : out std_logic_vector(7 downto 0);
			output : out std_logic);
	end component;

	constant CLK_PERIOD : time := 20 ns;
	
	signal clk    : std_logic;
	signal led    : std_logic_vector(7 downto 0);
	signal output : std_logic;
	
begin

	-- DUT
	c_fizzbuzz : fizzbuzz
		port map(
			clk    => clk,
			led    => led,
			output => output);
			
	-- Test process
	test : process
	begin
		wait for 1000 * CLK_PERIOD;
	end process test;
	
	-- Generate CLK signal
	generate_clk : process
	begin
		clk <= '1';
		wait for CLK_PERIOD / 2;
		clk <= '0';
		wait for CLK_PERIOD / 2;
	end process generate_clk;


end test;
