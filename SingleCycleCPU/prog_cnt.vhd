library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.all;

entity prog_cnt is
  port (
	clk	: in  std_logic;
        aload   : in  std_logic;
        adata   : in  std_logic_vector (31 downto 0);
	pc_in	: in  std_logic_vector (31 downto 0);
	pc_out	: out std_logic_vector (31 downto 0)
  );
end prog_cnt;

architecture structural_PC of prog_cnt is
begin
  reg : for i in 0 to 31 generate
  begin
    dff_map : dffr_a port map (clk => clk, arst => '0', aload => aload, adata => adata(i), d => pc_in(i), enable => '1', q => pc_out(i));
  end generate reg;
end architecture structural_PC;
