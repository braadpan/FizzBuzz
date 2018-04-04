library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fizzbuzz is
	port(
		clk    : in  std_logic;
		led    : out std_logic_vector(7 downto 0);
		output : out std_logic);
end fizzbuzz;

architecture rtl of fizzbuzz is

	constant START : std_logic_vector(3 downto 0) := (others => '0');
	constant DONE  : std_logic_vector(3 downto 0) := (others => '1');
	signal state   : std_logic_vector(3 downto 0) := START;

	signal mod3        : std_logic_vector(1 downto 0) := (others => '0');
	signal mod5        : std_logic_vector(2 downto 0) := (others => '0');
	signal char        : std_logic_vector(7 downto 0) := (others => '0');
	signal serial_send : std_logic;
	signal serial_busy : std_logic;

	signal increment : std_logic;
	signal digit0    : std_logic_vector(3 downto 0) := (others => '0');
	signal digit1    : std_logic_vector(3 downto 0) := (others => '0');
	signal digit2    : std_logic_vector(3 downto 0) := (others => '0');

	component serial
		port(
			clk    : in  std_logic;
			char   : in  std_logic_vector(7 downto 0);
			send   : in  std_logic;
			output : out std_logic;
			busy   : out std_logic);
	end component;

	component bcd_counter
		port(
			clk       : in  std_logic;
			increment : in  std_logic;
			digit0    : out std_logic_vector(3 downto 0) := (others => '0');
			digit1    : out std_logic_vector(3 downto 0) := (others => '0');
			digit2    : out std_logic_vector(3 downto 0) := (others => '0'));
	end component;

begin

	c_serial : serial
		port map(
			clk    => clk,
			char   => char,
			send   => serial_send,
			output => output,
			busy   => serial_busy);

	c_bcd_counter : bcd_counter
		port map(
			clk       => clk,
			increment => increment,
			digit0    => digit0,
			digit1    => digit1,
			digit2    => digit2);

	increment       <= '1' when (state = START) else '0';
	led(3 downto 0) <= state;
	led(7 downto 4) <= digit1;

	p_main : process(clk)
	begin
		if rising_edge(clk) then
			serial_send <= '0';
			if (state = DONE) then
				mod3  <= (others => '0');
				mod5  <= (others => '0');
				state <= START;
			elsif (state = START) then
				if (digit2 = "0001" and digit1 = "0000" and digit0 = "0000") then
					state <= DONE;
				else
					if (mod3 = "10") then
						mod3 <= "00";
					else
						mod3 <= std_logic_vector(unsigned(mod3) + 1);
					end if;
					if (mod5 = "100") then
						mod5 <= "000";
					else
						mod5 <= std_logic_vector(unsigned(mod5) + 1);
					end if;
					state <= "0001";    -- Start output with state 1
				end if;
			elsif (serial_busy /= '1' and serial_send /= '1') then
				state       <= std_logic_vector(unsigned(state) + 1);
				serial_send <= '1';
				if (mod3 = "00" and mod5 = "000") then
					case (state) is
						when "0001" =>
							char <= X"46"; -- F
						when "0010" =>
							char <= X"69"; -- i
						when "0011" =>
							char <= X"7a"; -- z
						when "0100" =>
							char <= X"7a"; -- z
						when "0101" =>
							char <= X"42"; -- B
						when "0110" =>
							char <= X"75"; -- u
						when "0111" =>
							char <= X"7a"; -- z
						when "1000" =>
							char <= X"7a"; -- z
						when "1001" =>
							char <= X"0d"; -- \r = carriage return 
						when "1010" =>
							char  <= X"0a"; -- \n = new line
							state <= START;
						when others => state <= START;
					end case;
				elsif (mod3 = "00") then
					case (state) is
						when "0001" =>
							char <= X"42"; -- B
						when "0010" =>
							char <= X"75"; -- u
						when "0011" =>
							char <= X"7a"; -- z
						when "0100" =>
							char <= X"7a"; -- z
						when "0101" =>
							char <= X"0d"; -- \r = carriage return 
						when "0110" =>
							char  <= X"0a"; -- \n = new line
							state <= START;
						when others => state <= START;
					end case;
				elsif (mod5 = "000") then
					case (state) is
						when "0001" =>
							char <= X"42"; -- B
						when "0010" =>
							char <= X"75"; -- u
						when "0011" =>
							char <= X"7a"; -- z
						when "0100" =>
							char <= X"7a"; -- z
						when "0101" =>
							char <= X"0d"; -- \r = carriage return 
						when "0110" =>
							char  <= X"0a"; -- \n = new line
							state <= START;
						when others => state <= START;
					end case;
				else
					case (state) is
						when "0001" =>
							if (digit2 = "0000") then
								serial_send <= '0'; -- suppress leading zero
							else
								char <= "0011" & digit2;
							end if;
						when "0010" =>
							if (digit2 = "0000" and digit1 = "0000") then
								serial_send <= '0'; -- suppress leading zero
							else
								char <= "0011" & digit1;
							end if;
						when "0011" =>
							char <= "0011" & digit0;
						when "0100" =>
							char <= X"0d"; -- \r = carriage return 
						when "0101" =>
							char  <= X"0a"; -- \n = new line
							state <= START;
						when others => state <= START;
					end case;
				end if;
			end if;
		end if;
	end process;
end rtl;
