----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/26/2020 05:31:32 PM
-- Design Name: 
-- Module Name: SPI_Core - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SPI_Core is
    Port ( PL_clk : in STD_LOGIC;
           ssn: in STD_LOGIC;
           sclk : in STD_LOGIC;
           mosi : in STD_LOGIC;
           rdata: in STD_LOGIC_VECTOR(15 downto 0);
           miso : out STD_LOGIC;
           wstrobe : out STD_LOGIC;
           wdata : out STD_LOGIC_VECTOR (15 downto 0);
           addr : out STD_LOGIC_VECTOR (6 downto 0));
end SPI_Core;

architecture Behavioral of SPI_Core is

signal int_reg: STD_LOGIC_VECTOR (23 downto 0);
signal counter: integer range 0 to 23;
signal max_pulse: STD_LOGIC;
signal rdata_int: STD_LOGIC_VECTOR (15 downto 0);
signal sclk_reg: STD_LOGIC_VECTOR(2 downto 0);
signal FF_out: STD_LOGIC;
signal FF_in: STD_LOGIC;
signal rising_edge_det, falling_edge_det: STD_LOGIC;
begin

EDGE_DETECTION_REGS : process(PL_clk) --Used to detect rising and falling edges of slower clocks and signals that are not the on-board clock
begin
    if(rising_edge(PL_clk)) then
        FF_out <= FF_in;
        FF_in <= sclk;
    end if;
end process;
rising_edge_det <= (not FF_out) and FF_in;
falling_edge_det <= (not FF_in) and FF_out;

process(max_pulse, PL_clk)
begin
    if (rising_edge(PL_clk)) then
        if (max_pulse = '1') then
            addr <= int_reg(23 downto 17);
            wstrobe <= int_reg(16); --This needs to move
            if(int_reg(16) = '1') then
                wdata <= int_reg(15 downto 0); --data goes to write bus
            end if;                     --shifted out via the miso
        else wstrobe <= '0';
        end if;
     end if;
end process;
                
mosi_shifter: process(PL_clk, ssn)
begin
    --sclk_buffer <= sclk_buffer(1 downto 0) & sclk;
if (rising_edge(PL_clk)) then
    max_pulse <= '0';
    if (counter = 23 and rising_edge_det = '1') then
        max_pulse <= '1';
    end if;
    if (rising_edge_det = '1' and ssn ='0') then
        counter <= counter + 1;
        int_reg <= int_reg(22 downto 0) & mosi; --24-bit reg constantly shifting in
        --max_pulse <= '0';
        if (counter = 23) then
            counter <= 0;
            --max_pulse <= '1';
        end if;
    end if;
end if;
end process mosi_shifter;

miso_shifter: process(PL_clk, ssn)
begin
if (rising_edge(PL_clk)) then
    if (falling_edge_det = '1' and ssn = '0') then
        if (counter > 7) then
            miso <= rdata(23 - counter);
            --rdata_int <= '0' & rdata(15 downto 1);
        else 
            miso <= '0';
        end if;
    end if;
end if;
end process miso_shifter;
        

end Behavioral;
