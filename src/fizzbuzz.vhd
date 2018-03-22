library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fizzbuzz is
	port(
		clk 	: in std_logic;
		led 	: out std_logic_vector(7 downto 0);
		output  : out std_logic);
end fizzbuzz;

architecture rtl of fizzbuzz is

	constant NEXT  : std_logic_vector(3 downto 0) := (others => '0');
	constant DONE  : std_logic_vector(3 downto 0) := (others => '1');
	signal state   : std_logic_vector(3 downto 0) := NEXT;
	
	signal mod3 		: std_logic_vector(1 downto 0) := (others => '0');
	signal mod5 		: std_logic_vector(2 downto 0) := (others => '0');
	signal char 		: std_logic_vector(7 downto 0) := (others => '0');
	signal serial_send 	: std_logic;
	
	signal increment : std_logic;
	signal digit0 	 : std_logic_vector(3 downto 0) := (others => '0');
	signal digit1 	 : std_logic_vector(3 downto 0) := (others => '0');
	signal digit2 	 : std_logic_vector(3 downto 0) := (others => '0');
	
begin

	c_serial : serial
	port map(
		clk		<= clk,
		char 	<= led,
		send 	<= serial_send,
		output	<= output,
		busy 	<= serial_busy);
	
	c_bcd_counter : bcd_counter
	port map(
		clk			<= clk,
		increment 	<= increment,
		digit0 		<= digit0,
		digit1		<= digit1,
		digit2		<= digit2);
		
	increment <= '1' when (state = NEXT) else '0';
	led(3 downto 0) <= state;
	led(7 downto 4) <= digit1;
	
	p_main : process (clk)
	begin
		if rising_edge(clk) then
			serial_send <= '0';
			if (state = DONE) then
				mod3  <= (others => '0');
				mod5  <= (others => '0');
				state <= NEXT;
			elsif (state = NEXT) then
				if (digit2 == "0001" && digit1 == "0000" && digit0 == "0000") then
					state <= DONE;
				else
					mod3 <= '0' when (mod3 = 2) else std_logic_vector(unsigned(mod3) + 1);
					mod5 <= '0' when (mod5 = 2) else std_logic_vector(unsigned(mod5) + 1);
					state <= "0001"; -- Start output with state 1
				end if;
			elsif (serial_busy /= '1' && serial_send /= '1') then
				state <= std_logic_vector(unsigned(state) + 1);
				serial_send <= '1';
				if (mod3 = "00" && mod5 = "000") then
					case (state) is
					when "0001" =>
						char <= "F";
					when "0010" =>
						char <= "i";
					when "0011" =>
						char <= "z";
					when "0100" =>
						char <= "z";
					when "0101" =>
						char <= "b";
					when "0110" =>
						char <= "u";
					when "0111" =>
						char <= "z";
					when "1000" =>
						char <= "z";
					when "1001" =>
						char <= "\r";
					when "1010" =>
						char <= "\n";
						state <= NEXT;
					end case;
				elsif (mod3 = "00") then
					case (state) is
					when "0001" =>
						char <= "F";
					when "0010" =>
						char <= "i";
					when "0011" =>
						char <= "z";
					when "0100" =>
						char <= "z";
					when "0101" =>
						char <= "\r";
					when "0110" =>
						char <= "\n";
						state <= NEXT;
					end case;
				elsif (mod5 = "000") then
					case (state) is
					when "0001" =>
						char <= "B";
					when "0010" =>
						char <= "u";
					when "0011" =>
						char <= "z";
					when "0100" =>
						char <= "z";
					when "0101" =>
						char <= "\r";
					when "0110" =>
						char <= "\n";
						state <= NEXT;
					end case;
				else
					case (state) is
					when "0001" =>
						if (digit2 = "0000") then
							serial_send <= '0'; -- suppress leading zero
						else
							char <= "11" & digit2;
						end if;
					when "0010" =>
						if (digit2 = "0000" && digit1 = "0000") then
							serial_send <= '0'; -- suppress leading zero
						else
							char <= "11" & digit1;
						end if;
					when "0011" =>
						char <= "11" & digit0;
					when "0100" =>
						char <= "\r";
					when "0101" =>
						char <= "\n";
						state <= NEXT;
					end case;
end rtl;