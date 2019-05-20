library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Drive a HD44780 chip to drive a liquid cristal display

entity lcd is
    port(
        clk      : in std_logic;
        char     : in std_logic_vector(7 downto 0);
        send     : in std_logic;
        newline  : in std_logic;
        busy     : out std_logic := '0';
        lcd_e    : out std_logic := '0'; -- Start read/write 
        lcd_rs   : out std_logic := '0'; -- Register select: 0 instruction, 1 data
        lcd_rw   : out std_logic := '0'; -- Always in write mode
        lcd_data : out std_logic_vector(7 downto 0) := (others => '0'));
end lcd;

architecture rtl of lcd is

    type state_type is (INIT_PU, INIT_FU, INIT_EM, INIT_DSP, CLEAR, IDLE, NL_E, DATA_E, WRITE);
    signal state   : state_type := INIT_PU;
    
    constant CLK_PERIOD : time := 20 ns;
    constant MAX_DELAY  : time := 30 ms;
    subtype delay_type is natural range 0 to MAX_DELAY / CLK_PERIOD;

    constant INIT_DELAY : delay_type := 30 ms  / CLK_PERIOD - 1; -- Boot delay
    constant SET_DELAY  : delay_type := 39 us / CLK_PERIOD - 1; -- Settings delay
    constant E_DELAY    : delay_type := 8 us / CLK_PERIOD - 1; -- Enable delay
    constant CMD_DELAY  : delay_type := 2 ms   / CLK_PERIOD - 1; -- Command delay
    --constant CHAR_DELAY : delay_type := 50 us  / CLK_PERIOD - 1; -- Character delay
    signal   delay      : delay_type := 0; -- Start with boot delay

begin
    
    p_fsm : process(clk)
    begin
        if rising_edge(clk) then
            
            case (state) is

            when INIT_PU => -- Wait 30 ms for LCD power up
                busy    <= '1';
                lcd_rs  <= '1';
                lcd_e   <= '0';
                if (delay = INIT_DELAY) then
                    delay <= SET_DELAY;
                    state <= INIT_FU;
                else 
                    state <= INIT_PU;
                    delay <= delay + 1;
                end if;

            when INIT_FU => -- Set function & mode
                busy        <= '1';
                lcd_data    <= "00110000"; -- 001 DL N F xx
                lcd_rs      <= '0';
                
                if (delay = 1) then
                    lcd_e  <= '1';
                elsif (delay = E_DELAY) then
                    lcd_e  <= '0';
                elsif (delay = SET_DELAY) then
                    delay <= 0;
                    state <= INIT_EM;
                else 
                    state <= INIT_FU;
                    delay <= delay + 1;
                end if;
                
            when INIT_EM => -- Set entry mode: direction and shift
                busy        <= '1';
                lcd_data    <= "00000110"; -- 00000 1 I/D S
                lcd_rs      <= '0';

                if (delay = 1) then
                    lcd_e  <= '1';
                elsif (delay = E_DELAY) then
                    lcd_e  <= '0';
                elsif (delay = SET_DELAY) then
                    delay <= 0;
                    state <= INIT_DSP;
                else 
                    state <= INIT_EM;
                    delay <= delay + 1;
                end if;

            when INIT_DSP => -- Set display on, cursor on, blinking on
                busy        <= '1';
                lcd_data    <= "00001111"; -- 0000 1 D C B
                lcd_rs      <= '0';
                
                if (delay = 1) then
                    lcd_e  <= '1';
                elsif (delay = E_DELAY) then
                    lcd_e  <= '0';
                elsif (delay = SET_DELAY) then
                    delay <= 0;
                    state <= IDLE;
                else 
                    state <= INIT_DSP;
                    delay <= delay + 1;
                end if;

            when CLEAR =>
                busy        <= '1';
                delay       <= 0;
                lcd_e       <= '1';
                lcd_data    <= "00000001"; -- Clears display
                state       <= NL_E;
                
            when IDLE => -- Wait for new character
                if (newline = '1') then
                    busy     <= '1';
                    delay    <= 0;
                    lcd_e    <= '1';
                    lcd_rs   <= '1';
                    lcd_data <= "00000001"; -- Clears display
                    state    <= NL_E;
                elsif (send = '1') then
                    busy     <= '1';
                    delay    <= 0;
                    lcd_e    <= '1';
                    lcd_rs   <= '1';
                    lcd_data <= char;
                    state    <= DATA_E;
                else 
                    lcd_rs  <= '0';
                    busy    <= '0';
                    state   <= IDLE;
                end if;
            
            when NL_E => -- New line enable
                busy <= '1';
                if (delay = E_DELAY) then
                    delay <= 0;
                    state <= WRITE;
                else 
                    state <= NL_E;
                    delay <= delay + 1;
                end if;
                
            when DATA_E => -- Send data enable
                busy <= '1';
                if (delay = E_DELAY) then
                    delay <= 0;
                    state <= WRITE;
                else 
                    state <= DATA_E;
                    delay <= delay + 1;
                end if;
                
            when WRITE => -- Send data
                busy    <= '1';
                lcd_e   <= '0';
                
                if (delay = SET_DELAY) then
                    state <= IDLE;
                else 
                    state <= WRITE;
                    delay <= delay + 1;
                end if;
                
            end case;
        end if;
    end process;

end rtl;
