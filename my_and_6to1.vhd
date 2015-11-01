library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

entity and_6to1 is
  port (
    op      : in  std_logic_vector (5 downto 0);      
    oq      : out std_logic
);
end and_6to1;

architecture structure of and_6to1 is
signal wi   : std_logic_vector (3 downto 0);
begin
    G0: and_gate port map(op(0), op(1), wi(0));
    G1: and_gate port map(op(2), op(3), wi(1));
    G2: and_gate port map(op(4), op(5), wi(2));
    G3: and_gate port map(wi(0), wi(1), wi(3));
    G4: and_gate port map(wi(2), wi(3), oq);
end architecture;
