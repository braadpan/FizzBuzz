library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity fizzbuzz is
    port(
        clk       : in  std_logic;
        increment : in  std_logic;
        busy      : in  std_logic;
        led       : out std_logic_vector(7 downto 0) := (others => '0');
        char      : out std_logic_vector(7 downto 0) := (others => '0');
        send      : out std_logic := '0';
        newline   : out std_logic := '0');
end fizzbuzz;

architecture rtl of fizzbuzz is
    
    subtype T4bit is std_logic_vector(3 downto 0);
    
    constant START   : T4bit := "0000";
    constant IDLE    : T4bit := "1110";
    constant DONE    : T4bit := "1111";
    signal state     : T4bit := IDLE;

    signal mod3      : std_logic_vector(1 downto 0) := (others => '0');
    signal mod5      : std_logic_vector(2 downto 0) := (others => '0');

    signal digit0    : T4bit := (others => '0');
    signal digit1    : T4bit := (others => '0');
    signal digit2    : T4bit := (others => '0');
    
    signal incrEn     : std_logic := '0';
    signal rstCounter : std_logic := '0';

    signal ledOn : std_logic := '0'; -- debugging

begin

    incrEn <= increment when busy = '0' else '0';

    bcd : entity work.bcd_counter(rtl)
        port map(
            clk       => clk,
            rst       => rstCounter,
            increment => incrEn,
            digit0    => digit0,
            digit1    => digit1,
            digit2    => digit2);
            
    -- Show signals on the LEDs
    led(3 downto 0) <= state;
    --led(7 downto 4) <= digit1;

    led(7) <= ledOn;
    
    p_blink : process(clk)
    begin
        if rising_edge(clk) then
            if increment then
                ledOn <= not ledOn;
            end if;
        end if;
    end process;

    p_main : process(clk)
    begin
        if rising_edge(clk) then
            send    <= '0';
            newline <= '0';
            char    <= X"00";
            
            -- Restart when state = DONE
            if (state = DONE) then
                mod3        <= (others => '0');
                mod5        <= (others => '0');
                rstCounter  <= '1';
                state       <= START;
                
            -- Wait until increment 
            elsif (state = IDLE) then
                if (incrEn = '1') then
                    state <= START;
                else 
                    state <= IDLE;
                end if;
            
            -- Start new number
            elsif (state = START) then
                rstCounter  <= '0';
                -- Finish when counter = 100?
                if (digit2 = "1001") then
                    state <= DONE;
                else
                    state <= "0001";    -- Start output with state 1
                    if (mod3 = "10") then
                        mod3 <= "00";
                    else
                        mod3 <= mod3 + 1;
                    end if;
                    if (mod5 = "100") then
                        mod5 <= "000";
                    else
                        mod5 <= mod5 + 1;
                    end if;
                end if;
                
            -- Wait until busy is low
            elsif (busy /= '1') then
                state <= state + 1;
                send  <= '1';
                
                if (mod3 = "00" and mod5 = "000") then -- Send FizzBuzz
                    case (state) is
                       when "0001" =>
                            newline <= '1'; -- Start new line 
                        when "0010" =>
                            char <= X"46"; -- F
                        when "0011" =>
                            char <= X"69"; -- i
                        when "0100" =>
                            char <= X"7a"; -- z
                        when "0101" =>
                            char <= X"7a"; -- z
                        when "0110" =>
                            char <= X"42"; -- B
                        when "0111" =>
                            char <= X"75"; -- u
                        when "1000" =>
                            char <= X"7a"; -- z
                        when "1001" =>
                            char <= X"7a"; -- z
                        when others => 
                            state <= IDLE;
                            send  <= '0';
                    end case;
                    
                elsif (mod3 = "00") then -- Send Fizz
                    case (state) is
                        when "0001" =>
                            newline <= '1'; -- Start new line 
                        when "0010" =>
                            char <= X"46"; -- F
                        when "0011" =>
                            char <= X"69"; -- i
                        when "0100" =>
                            char <= X"7a"; -- z
                        when "0101" =>
                            char <= X"7a"; -- z
                        when others => 
                            state <= IDLE;
                            send  <= '0';
                    end case;
                elsif (mod5 = "000") then -- Send Buzz
                    case (state) is
                        when "0001" =>
                            newline <= '1'; -- Start new line 
                        when "0010" =>
                            char <= X"42"; -- B
                        when "0011" =>
                            char <= X"75"; -- u
                        when "0100" =>
                            char <= X"7a"; -- z
                        when "0101" =>
                            char <= X"7a"; -- z
                        when others => 
                            state <= IDLE;
                            send  <= '0';
                    end case;
                else
                    case (state) is
                        when "0001" =>
                            newline <= '1'; -- Start new line 
                        when "0010" =>
                            if (digit2 = "0000") then
                                send <= '0'; -- suppress leading zero
                            else
                                char <= "0011" & digit2;
                            end if;
                        when "0011" =>
                            if (digit2 = "0000" and digit1 = "0000") then
                                send <= '0'; -- suppress leading zero
                            else
                                char <= "0011" & digit1;
                            end if;
                        when "0100" =>
                            char  <= "0011" & digit0;
                        when others => 
                            state <= IDLE;
                            send  <= '0';
                    end case;
                end if;
            end if;
        end if;
    end process;
end rtl;
