----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/27/2020 07:29:13 PM
-- Design Name: 
-- Module Name: SPI_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SPI_tb is
--  Port ( );
end SPI_tb;

architecture Behavioral of SPI_tb is
    component SPI_Core is
    Port ( PL_clk : in STD_LOGIC;
           ssn: in STD_LOGIC;
           sclk : in STD_LOGIC;
           mosi : in STD_LOGIC;
           rdata: in STD_LOGIC_VECTOR(15 downto 0);
           miso : out STD_LOGIC;
           wstrobe : out STD_LOGIC;
           wdata : out STD_LOGIC_VECTOR (15 downto 0);
           addr : out STD_LOGIC_VECTOR (6 downto 0));
    end component;
signal PL_clk_test, ssn_test, sclk_test, mosi_test, miso_test, wstrobe_test: STD_LOGIC;
signal rdata_test, wdata_test : STD_LOGIC_VECTOR(15 downto 0);
signal addr_test : STD_LOGIC_VECTOR(6 downto 0);

begin
	UUT: SPI_Core port map (
		PL_clk => PL_clk_test,
		ssn => ssn_test,
		sclk => sclk_test,
		mosi => mosi_test,
		miso => miso_test,
		rdata => rdata_test,
		wdata => wdata_test,
		addr => addr_test);
		
		


FPGA_CLOCK_GEN : process --50Mhz
begin
PL_clk_test <= '0';
wait for 10ns;
PL_clk_test <= '1';
wait for 10ns;
end process;

SCLK_GEN : process --10Mhz
begin
wait for 1us; --to compensate for Slave select being active
for i in 1 to 80 loop
    sclk_test <= '0';
    wait for 50ns;
    sclk_test <= '1';
    wait for 50ns;
end loop;
wait;
end process;

SLAVE_SELECT : process
begin
ssn_test <= '1';
wait for 1us;
ssn_test <= '0';
wait for 2450ns;
ssn_test <= '1';
wait;
end process;

mosi_test_GEN : process --generates 24-bit incoming data
begin
wait for 1us;
mosi_test <= '1'; --addr value here
wait for 100ns;
mosi_test <= '0';
wait for 100ns;
mosi_test <= '1';
wait for 100ns;
mosi_test <= '0';
wait for 100ns;
mosi_test <= '1';
wait for 100ns;
mosi_test <= '0';
wait for 100ns;
mosi_test <= '1';
wait for 100ns;
mosi_test <= '1'; --wstrobe value here
wait for 100ns;
mosi_test <= '0'; --data starts here
wait for 100ns; 
mosi_test <= '1';
wait for 100ns;
mosi_test <= '0';
wait for 100ns;
mosi_test <= '1';
wait for 100ns;
mosi_test <= '1';
wait for 100ns;
mosi_test <= '0';
wait for 100ns;
mosi_test <= '0';
wait for 100ns;
mosi_test <= '1';
wait for 100ns;              
mosi_test <= '1';  
wait for 100ns;
mosi_test <= '0';
wait for 100ns;
mosi_test <= '0';
wait for 100ns;
mosi_test <= '0';
wait for 100ns;
mosi_test <= '0';
wait for 100ns;
mosi_test <= '0';
wait for 100ns;
mosi_test <= '0';
wait for 100ns;
mosi_test <= '1';
wait for 100ns;

mosi_test <= '1'; --addr value here
wait for 100ns;
mosi_test <= '0';
wait for 100ns;
mosi_test <= '0';
wait for 100ns;
mosi_test <= '0';
wait for 100ns;
mosi_test <= '0';
wait for 100ns;
mosi_test <= '0';
wait for 100ns;
mosi_test <= '0';
wait for 100ns;
mosi_test <= '1'; --wstrobe value here
wait for 100ns;
mosi_test <= '1'; --data starts here
wait for 100ns; 
mosi_test <= '0';
wait for 100ns;
mosi_test <= '1';
wait for 100ns;
mosi_test <= '0';
wait for 100ns;
mosi_test <= '1';
wait for 100ns;
mosi_test <= '0';
wait for 100ns;
mosi_test <= '1';
wait for 100ns;
mosi_test <= '0';
wait for 100ns;              
mosi_test <= '1';  
wait for 100ns;
mosi_test <= '0';
wait for 100ns;
mosi_test <= '1';
wait for 100ns;
mosi_test <= '0';
wait for 100ns;
mosi_test <= '1';
wait for 100ns;
mosi_test <= '0';
wait for 100ns;
mosi_test <= '1';
wait for 100ns;
mosi_test <= '0';
wait for 100ns;
wait;
end process;

process
begin
rdata_test <= "1000001100100001"; --Random Data 0xf0f0 assumed to be from memeory
wait;
end process;

end Behavioral;