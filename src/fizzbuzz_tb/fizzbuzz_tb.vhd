library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fizzbuzz_tb is
end fizzbuzz_tb;

architecture test of fizzbuzz_tb is

	component fizzbuzz
		port(
			clk     : in  std_logic;
			led     : out std_logic_vector(7 downto 0);
			char    : out std_logic_vector(7 downto 0);
			send    : out std_logic;
			newline : out std_logic;
			busy    : in  std_logic);
	end component;

	constant CLK_PERIOD : time := 20 ns;
	
	signal clk  : std_logic;
	signal busy : std_logic;
	
begin

	-- DUT
	c_fizzbuzz : component fizzbuzz
		port map(
			clk     => clk,
			led     => open,
			char    => open,
			send    => open,
			newline => open,
			busy    => busy);
			
	-- Test process
	test : process
	begin
		busy <= '0';
		wait for 20 * CLK_PERIOD;
		busy <= '1';
		wait for 5 * CLK_PERIOD;
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
