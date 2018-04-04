library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
	port(
		FPGA_CLK1_50 : in  std_logic;
		KEY          : in  std_logic_vector(1 downto 0);
		LED          : out std_logic_vector(7 downto 0);
		GPIO_0_0     : out std_logic;
		
      HDMI_I2C_SCL : inout std_logic;
      HDMI_I2C_SDA : inout std_logic;
      HDMI_I2S 	 : inout std_logic;
      HDMI_LRCLK 	 : inout std_logic;
      HDMI_MCLK 	 : inout std_logic;
      HDMI_SCLK    : inout std_logic;
      HDMI_TX_CLK  : out std_logic;
      HDMI_TX_D	 : out std_logic_vector(23 downto 0);
      HDMI_TX_DE   : out std_logic;
      HDMI_TX_HS   : out std_logic;
      HDMI_TX_INT  : in std_logic;
      HDMI_TX_VS 	 : out std_logic);
end top;

architecture structure of top is

	component fizzbuzz
		port(
			clk    : in  std_logic;
			led    : out std_logic_vector(7 downto 0);
			output : out std_logic);
	end component;
	
	component i2c_hdmi_config
		port(
			iCLK   		: in std_logic;
			iRST_N 		: in std_logic;
			I2C_SCLK 	: out std_logic;
		   I2C_SDAT 	: inout std_logic;
		   HDMI_TX_INT : in std_logic;
			READY			: out std_logic);
	end component;
		
	component sfl is
		port (
			noe_in : in std_logic := 'X'  -- noe
		);
	end component sfl;

begin

	c_fizzbuzz : component fizzbuzz
		port map(
			clk    => FPGA_CLK1_50,
			led    => LED,
			output => GPIO_0_0);
			
	c_i2c_hdmi_config : component i2c_hdmi_config
	port map(
		iCLK   		=> FPGA_CLK1_50,
		iRST_N 		=> '1',
		I2C_SCLK 	=> HDMI_I2C_SCL,
		I2C_SDAT 	=> HDMI_I2C_SDA,
		HDMI_TX_INT => HDMI_TX_INT,
		READY       => open);

			
	c_sfl : component sfl
		port map(
			noe_in => '0'); -- Enable the Serial Flash Loader IP

end structure;
