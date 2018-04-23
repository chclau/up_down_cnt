------------------------------------------------------------------
-- Name		     : counter_ud.vhd
-- Description : Up/down counter with enable, sclr and load
-- Designed by : Claudio Avi Chami - FPGA'er website
--               fpgaer.wordpress.com
-- Date        : 07/04/2016
-- Version     : 01
------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_ud is
  generic (
    DATA_W : natural := 32
  );
  port (
    clk       : in std_logic;
    rst       : in std_logic;
 
    -- inputs
    data_in   : in std_logic_vector (DATA_W - 1 downto 0);
    load      : in std_logic;
    sclr      : in std_logic;
    en        : in std_logic;
    up_ndown  : in std_logic;
 
    -- outputs
    data_out  : out std_logic_vector (DATA_W - 1 downto 0)
  );
end counter_ud;
architecture rtl of counter_ud is
  signal counter_reg : unsigned (DATA_W - 1 downto 0);

begin
  counter_pr : process (clk, rst)
  begin
    if (rst = '1') then
      counter_reg <= (others => '0');
    elsif (rising_edge(clk)) then
      if (sclr = '1') then -- synchronous clear
        counter_reg <= (others => '0'); 
      elsif (load = '1') then -- load counter
        counter_reg <= unsigned(data_in);
      elsif (en = '1') then -- is counting enabled?
        if (up_ndown = '1') then -- count up
          counter_reg <= counter_reg + 1; 
        else -- count down
          counter_reg <= counter_reg - 1; 
        end if; 
      end if; 
    end if;
  end process;

  data_out <= std_logic_vector(counter_reg);

end rtl;