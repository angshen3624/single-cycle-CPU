library ieee;
use ieee.std_logic_1164.all;

entity sign_extender is
  port (
    data_in  : in  std_logic_vector (15 downto 0);
    data_out : out std_logic_vector (31 downto 0)
  );
end sign_extender;

architecture structural_ext of sign_extender is
begin
  upperbits : for i in 16 to 31 generate
  begin
    data_out(i) <= data_in(15);
  end generate upperbits;
  data_out (15 downto 0) <= data_in;
end architecture structural_ext;
