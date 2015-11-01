library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity singlecycle_demo is
end singlecycle_demo;

architecture structural_cpuDemo of singlecycle_demo is
component singlecycle
  generic (
    mem_file : string
  );
  port (
    clk    : in std_logic;
    ainit  : in std_logic
  );
end component singlecycle;
signal clk 	: std_logic := '0'; 			-- initialize signals
signal ainit    : std_logic;
begin
  cpu_map : singlecycle generic map (mem_file => "data/sort_corrected_branch.dat") port map (clk, ainit);

  -- Clock process definitions
  clk_100M_proc : process
  begin	 
    for i in 1 to 1000
    loop
      -- creates periodic waveform on signal clk
      -- with a period of 10ns
      clk <= not clk after 5 ns;
      wait for 5 ns;
    end loop;
    wait;
  end process;

  -- Stimulus process
  test_proc : process
  begin
    ainit <= '1';
    wait for 2 ns;
    ainit <= '0';
    wait;
  end process;
end architecture structural_cpuDemo;
