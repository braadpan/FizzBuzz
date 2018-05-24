library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Drive a HD44780 chip to drive a liquid cristal display

entity lcd is
	port(
		clk      : in std_logic;
		char 	 : in std_logic_vector(7 downto 0);
		send     : in std_logic;
		newline  : in std_logic;
		busy     : out std_logic := '0';
		lcd_e    : out std_logic := '0';
		lcd_rs   : out std_logic := '0';
		lcd_rw   : out std_logic := '0';
		lcd_data : out std_logic_vector(7 downto 0) := (others => '0'));
end lcd;

architecture rtl of lcd is

	type state_type is (INIT0, INIT1, IDLE, NL_E, DATA_E, WRITE);
	signal state   : state_type := INIT0;
	
	constant CLK_PERIOD : time := 20 ns;
	constant MAX_DELAY  : time := 11 ms;
	subtype delay_type is natural range 0 to MAX_DELAY / CLK_PERIOD;

	--constant INIT_DELAY : delay_type := 11 ms  / CLK_PERIOD - 1;
	constant INIT_DELAY : delay_type := 200 ns  / CLK_PERIOD - 1;
    constant E_DELAY    : delay_type := 300 ns / CLK_PERIOD - 1;
	--constant CMD_DELAY  : delay_type := 2 ms   / CLK_PERIOD - 1;
	constant CMD_DELAY  : delay_type := 200 ns   / CLK_PERIOD - 1;
    constant CHAR_DELAY : delay_type := 50 us  / CLK_PERIOD - 1;
	signal   delay      : delay_type := INIT_DELAY;

begin
	
	p_fsm : process(clk)
	begin
		if rising_edge(clk) then
            busy <= '1';
		    if (delay > 0) then
				delay <= delay - 1;
			end if;
			
			case (state) is
			when INIT0 => -- Wait 11 ms for LCD reset
				if (delay = 0) then
					delay <= E_DELAY;
					state <= INIT1;
				else 
					state <= INIT0;
				end if;
			
			when INIT1 => -- Turn on display enable
				lcd_e		<= '1';
				lcd_data <= "00001100";
				
				if (delay = 0) then
					delay <= CMD_DELAY;
					state <= WRITE;
				else 
					state <= INIT1;
				end if;
				
			when IDLE => -- Wait for new character
				if (newline = '1') then
					delay    <= E_DELAY;
                    lcd_e		<= '1';
                    lcd_data <= "00000001";
					state    <= NL_E;
				elsif (send = '1') then
					delay    <= E_DELAY;
					lcd_data <= char;
                    lcd_e		<= '1';
                    state    <= DATA_E;
				else 
					state <= IDLE;
                    busy <= '0';
				end if;
			
			when NL_E => -- New line enable
				if (delay = 0) then
					delay <= CMD_DELAY;
					state <= WRITE;
				else 
					state <= NL_E;
				end if;
				
			when DATA_E => -- Send data enable
				if (delay = 0) then
					delay <= CHAR_DELAY;
					state <= WRITE;
				else 
					state <= DATA_E;
				end if;
				
			when WRITE => -- Send data
				lcd_e		<= '0';
				
				if (delay = 0) then
					state <= IDLE;
				else 
					state <= WRITE;
				end if;
				
			end case;
		end if;
	end process;

end rtl;
