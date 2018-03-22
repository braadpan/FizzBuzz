library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

enitity serial is
	port (
	clk 		: in std_logic;
	rst			: in std_logic;
	increment 	: in std_logic;
	digit0 		: out std_logic_vector(3 downto 0) := (others => '0');
	digit1		: out std_logic_vector(3 downto 0) := (others => '0');
	digit2 		: out std_logic_vector(3 downto 0) := (others => '0'));
end serial;

architecture rtl of serial is
	
begin
	
	p_counter : process (clk)
	begin
		if rising_edge(clk) then
			if (increment = '1') then
				if (digit0 /= "1001") then
					digit0 <= digit0 + 1; 
				else
					digit0 <= (others => '0');
		
					if (digit1 /= "1001") then
						digit1 <= std_logic_vector(unsigned(digit1) + 1);
					else
						digit1 <= (others => '0');
						
						if (digit2 /= "1001") then
							digit2 <= std_logic_vector(unsigned(digit2) + 1);
						else
							digit2 <= (others => '0');
						end if;
					end if;
				end if;
			end if;
		end if;
	end process;
	
end rtl;