library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
	port(
		clk_50 	: in std_logic;
		rst 	: in std_logic;
		led 	: out std_logic_vector(7 downto 0);
		output  : out std_logic);
end top;

architecture structure of top is 
	
begin

	c_fizzbuzz : fizzbuzz
	port map(
		clk		<= clk_50,
		led		<= led,
		output	<= output);
	
end structure;