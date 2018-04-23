------------------------------------------------------------------
-- Name : tb_cnt_ud.vhd
-- Description : Testbench for counter_ud.vhd
-- Designed by : Claudio Avi Chami - FPGA'er website
-- fpgaer.wordpress.com
-- Date : 08/04/2016
-- Version : 01
------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use std.textio.all;
 
entity tb_cnt_ud is
end entity;

architecture test of tb_cnt_ud is

  constant PERIOD : time := 20 ns;
  constant DATA_W : natural := 3;
 
  signal clk : std_logic := '0';
  signal rst : std_logic := '1';
  signal load : std_logic := '0';
  signal sclr : std_logic := '0';
  signal en : std_logic := '0';
  signal up_ndown : std_logic := '0';
  signal data_in : std_logic_vector (DATA_W - 1 downto 0);
  signal endSim : boolean := false;

  component counter_ud is
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
  end component;
 

begin
  clk <= not clk after PERIOD/2;
  rst <= '0' after PERIOD * 10;

  -- Main simulation process
  process
  begin
    wait until (rst = '0');
    wait until (rising_edge(clk));

    data_in <= "101";
    load <= '1';
    wait until (rising_edge(clk));
    load <= '0';
    wait until (rising_edge(clk));
    up_ndown <= '1';
    en <= '1';

    for I in 0 to 4 loop
      wait until (rising_edge(clk));
    end loop;
    wait until (rising_edge(clk));
    en <= '0';
    wait until (rising_edge(clk));
    en <= '1';
    wait until (rising_edge(clk));
    sclr <= '1';
    wait until (rising_edge(clk));
    sclr <= '0';
    for I in 0 to 3 loop
      wait until (rising_edge(clk));
    end loop;

    up_ndown <= '0';
    for I in 0 to 6 loop
      wait until (rising_edge(clk));
    end loop;
    endSim <= true;
  end process; 
 
  -- End the simulation
  process
    begin
      if (endSim) then
        assert false
        report "END OF simulation."
          severity failure;
      end if;
      wait until (rising_edge(clk));
    end process; 

    DUT : counter_ud
      generic map(
      DATA_W => DATA_W
      )
      port map(
        clk       => clk, 
        rst       => rst, 
 
        data_in   => data_in, 
        load      => load, 
        en        => en, 
        sclr      => sclr, 
        up_ndown  => up_ndown, 
 
        data_out  => open
      );

end architecture;