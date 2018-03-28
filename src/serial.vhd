library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity serial is
	port (
	clk 	 : in std_logic;
	char 	 : in std_logic_vector(7 downto 0);
	send 	 : in std_logic;
	output : out std_logic;
	busy 	 : out std_logic);
end serial;

architecture rtl of serial is

	constant IDLE  : std_logic_vector(3 downto 0) := "0000";
	constant START : std_logic_vector(3 downto 0) := "0001";
	constant BIT0  : std_logic_vector(3 downto 0) := "0010";
	constant BIT1  : std_logic_vector(3 downto 0) := "0011";
   constant BIT2  : std_logic_vector(3 downto 0) := "0100";
	constant BIT3  : std_logic_vector(3 downto 0) := "0101";
	constant BIT4  : std_logic_vector(3 downto 0) := "0110";
	constant BIT5  : std_logic_vector(3 downto 0) := "0111";
	constant BIT6  : std_logic_vector(3 downto 0) := "1000";
	constant BIT7  : std_logic_vector(3 downto 0) := "1001";
	constant STOP  : std_logic_vector(3 downto 0) := "1010";
	
	signal state     : std_logic_vector(3 downto 0);
	signal char_s    : std_logic_vector(7 downto 0);

	constant DIVISOR : natural := 5208;
	--signal counter   : std_logic_vector(12 downto 0) := (others => '0');
	
begin
	busy <= '1' when (state = IDLE) else '0';
	
	p_next_state : process (clk)
		variable counter : integer := 0;
	begin
		if rising_edge(clk) then
			if (state = IDLE) then
				if (send = '1') then
					state <= START;
					counter := 0;
					char_s  <= char;
				end if;
			else
				if (counter < (DIVISOR - 1)) then
					counter := counter + 1;
				else
					counter := 0;
					if (state /= STOP) then
						state <= std_logic_vector(unsigned(state) + 1);
					end if;
				end if;
			end if;
		end if;
	end process;
	
	p_output : process (state)
	begin
		case (state) is
				when IDLE =>
					output <= '1';
				when START =>
					output <= '0';
				when BIT0 =>
					output <= char_s(0);
				when BIT1 =>
					output <= char_s(1);
				when BIT2 =>
					output <= char_s(2);
				when BIT3 =>
					output <= char_s(3);
				when BIT4 =>
					output <= char_s(4);
				when BIT5 =>
					output <= char_s(5);
				when BIT6 =>
					output <= char_s(6);
				when BIT7 =>
					output <= char_s(7);
				when others => output <= '0';
			end case;
	end process;

end rtl;