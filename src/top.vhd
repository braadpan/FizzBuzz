library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
	port(
		FPGA_CLK1_50 : in  std_logic;
		KEY          : in  std_logic_vector(1 downto 0);
		LED          : out std_logic_vector(7 downto 0);
		GPIO_0       : out std_logic_vector(35 downto 0));
end top;

architecture structure of top is

	component fizzbuzz
		port(
			clk    : in  std_logic;
			led    : out std_logic_vector(7 downto 0);
			output : out std_logic);
	end component;

begin

	c_fizzbuzz : fizzbuzz
		port map(
			clk    => FPGA_CLK1_50,
			led    => LED,
			output => GPIO_0(0));

end structure;
