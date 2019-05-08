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
		lcd_e    : out std_logic := '0'; -- Start read/write 
		lcd_rs   : out std_logic := '0'; -- Register select: 0 instruction, 1 data
		lcd_rw   : out std_logic := '0'; -- Always in write mode
		lcd_data : out std_logic_vector(7 downto 0) := (others => '0'));
end lcd;

architecture rtl of lcd is

	type state_type is (INIT_PU, INIT_FU, INIT_EM, IDLE, NL_E, DATA_E, WRITE);
	signal state   : state_type := INIT_PU;
	
	constant CLK_PERIOD : time := 20 ns;
	constant MAX_DELAY  : time := 30 ms;
	subtype delay_type is natural range 0 to MAX_DELAY / CLK_PERIOD;

	constant INIT_DELAY : delay_type := 30 ms  / CLK_PERIOD - 1;
    constant E_DELAY    : delay_type := 300 ns / CLK_PERIOD - 1;
	constant CMD_DELAY  : delay_type := 2 ms   / CLK_PERIOD - 1;
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
			when INIT_PU => -- Wait 30 ms for LCD power up
				if (delay = 0) then
					delay <= E_DELAY;
					state <= INIT_FU;
				else 
					state <= INIT_PU;
				end if;

			when INIT_FU => -- Turn on display enable, cursor on, blinking on
				lcd_e		<= '1';
				lcd_data <= "00001111";
				
				if (delay = 0) then
					delay <= CMD_DELAY;
					state <= WRITE;
				else 
					state <= INIT_FU;
				end if;
				
			when INIT_EM => -- Set Entry mode
			
				
			when IDLE => -- Wait for new character
				if (newline = '1') then
					delay    <= E_DELAY;
                    lcd_e		<= '1';
                    lcd_data <= "00000001"; -- Clears display
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
