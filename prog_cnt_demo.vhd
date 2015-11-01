library ieee;
use ieee.std_logic_1164.all;

entity prog_cnt_demo is
  port (
    pc_out	: out std_logic_vector (31 downto 0)
  );
end prog_cnt_demo;

architecture structural_PCDemo of prog_cnt_demo is
component prog_cnt is
  port (
    clk		: in  std_logic;
    pc_in	: in  std_logic_vector (31 downto 0);
    pc_out	: out std_logic_vector (31 downto 0)
  );
end component prog_cnt;
signal clk 	: std_logic := '1'; 			-- initialize signals
signal pc_in 	: std_logic_vector (31 downto 0);
begin
  PC_map : prog_cnt port map (clk, pc_in, pc_out);

  -- Clock process definitions
  clk_50M_proc : process
  begin	 
    for i in 1 to 10
    loop
      -- creates periodic waveform on signal clk
      -- with a period of 20ns
      clk <= not clk after 10 ns;
      wait for 10 ns;
    end loop;
    wait;
  end process;

  -- Stimulus process
  test_proc : process
  begin
    pc_in <= x"00400020";
    wait for 20 ns;
    pc_in <= x"00400024";
    wait for 20 ns;
    pc_in <= x"00400028";
    wait for 20 ns;
    pc_in <= x"0040002c";
    wait for 20 ns;
    wait;
  end process;
end architecture structural_PCDemo;
