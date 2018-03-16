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

	constant NEXT  : std_logic := '0';
	constant DONE  : std_logic := '1';
	signal state   : std_logic := NEXT;
	
	signal mod3 : std_logic_vector(1 downto 0) := (others => '0');
	signal mod5 : std_logic_vector(2 downto 0) := (others => '0');
	signal char : std_logic_vector(7 downto 0) := (others => '0');
	signal send : std_logic;
	
	signal increment : std_logic;
	signal digit0 	 : std_logic_vector(3 downto 0) := (others => '0');
	signal digit1 	 : std_logic_vector(3 downto 0) := (others => '0');
	signal digit2 	 : std_logic_vector(3 downto 0) := (others => '0');
	
begin

	c_serial : serial
	port map(
		clk		<= clk,
		char 	<= led,
		send 	<= send,
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
	
	p_main : process (clk)
	begin
		if rising_edge(clk) then
			if (state = DONE) then
				mod3  <= (others => '0');
				mod5  <= (others => '0');
				state <= NEXT;
			elsif (state = NEXT) then
				if (digit2 == 1 && digit1 == 0 && digit0 == 0) then
					state <= DONE;
				else
				
				
end rtl;