library ieee;
use ieee.std_logic_1164.all;

entity and_6to1_demo is
  port (
    oq : out std_logic
  );
end and_6to1_demo;

architecture structural_andDemo of and_6to1_demo is
component and_6to1 is
  port (
    op : in  std_logic_vector(5 downto 0);      
    oq : out std_logic
  );
end component and_6to1;
signal op : std_logic_vector (5 downto 0);
begin
  and_6to1_map : and_6to1 port map (op, oq);

  test_proc  : process
  begin
    op <= "000000";
    wait for 10 ns;  
    op <= "001110";
    wait for 10 ns;
    op <= "010010";
    wait for 10 ns;
    op <= "111111";
    wait for 10 ns;
    wait;
  end process;
end architecture structural_andDemo;
