library ieee;
use ieee.std_logic_1164.all;

entity extender_demo is
  port (
    data_out : out std_logic_vector (31 downto 0)
  );
end extender_demo;

architecture structural_extenderDemo of extender_demo is
component sign_extender is
  port (
    data_in  : in  std_logic_vector (15 downto 0);
    data_out : out std_logic_vector (31 downto 0)
  );
end component sign_extender;
signal data_in  : std_logic_vector (15 downto 0);
begin
  extender_map : sign_extender port map (data_in, data_out);

  test_proc  : process
  begin
    data_in <= x"7fff";
    wait for 10 ns;  
    data_in <= x"8000";
    wait for 10 ns;
    data_in <= x"ffff";
    wait for 10 ns;
    data_in <= x"0000";
    wait for 10 ns;
    wait;
  end process;
end architecture structural_extenderDemo;
