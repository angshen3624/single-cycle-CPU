library ieee;
use ieee.std_logic_1164.all;

entity adder_demo is
  port (
    R     : out std_logic_vector (31 downto 0)
  );
end adder_demo;

architecture structural_adderDemo of adder_demo is
component adder is
  port (
    A     : in std_logic_vector (31 downto 0);
    B     : in std_logic_vector (31 downto 0);
    R     : out std_logic_vector (31 downto 0)
  );
end component adder;
signal A  : std_logic_vector (31 downto 0);
signal B  : std_logic_vector (31 downto 0);
begin
  adder_map  : adder port map (A, B, R);

  test_proc  : process
  begin
    A <= x"0000ffff";
    B <= x"00000001";
    wait for 10 ns;  
    A <= x"00000004";
    B <= x"00000007";
    wait for 10 ns;
    A <= x"00100000";
    B <= x"00000100";
    wait for 10 ns;
    A <= x"ffffffff";
    B <= x"00000002";
    wait for 10 ns;
    wait;
  end process;
end architecture structural_adderDemo;
