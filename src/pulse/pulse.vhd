library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generate pulse signal

entity pulse is
	generic(
      DELAY : time := 1000 ms
	);
	port(
		clk 		: in std_logic;
		pulse		: out std_logic := '0');
end pulse;

architecture rtl of pulse is
	
	constant CLK_PERIOD : time := 20 ns;
	subtype delay_type is natural range 0 to DELAY / CLK_PERIOD;

	constant DELAY_CYCLES	: delay_type := DELAY / CLK_PERIOD - 1;
	signal   counter			: delay_type := DELAY_CYCLES;

begin
	
	p_main : process(clk)
	begin
		if rising_edge(clk) then
			 
			if (counter = 0) then
				pulse 	<= '1'; 
				counter 	<= DELAY_CYCLES;
			else
				pulse 	<= '0';
				counter 	<= counter - 1;
			end if;

		end if;
	end process;

end rtl;
