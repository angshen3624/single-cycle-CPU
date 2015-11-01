library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

entity fulladder is
  port (
    x       : in  std_logic;
    y       : in  std_logic;
    c       : in  std_logic;
    z       : out std_logic;
    cout    : out std_logic
  );
end fulladder;

architecture structural_FA of fulladder is
signal xor0 : std_logic;
signal and0 : std_logic;
signal and1 : std_logic;
begin
  xor0_map  : xor_gate port map (x => x, y => y, z => xor0);
  xor1_map  : xor_gate port map (x => xor0, y => c, z => z);
  and0_map  : and_gate port map (x => x, y => y, z => and0);
  and1_map  : and_gate port map (x => xor0, y => c, z => and1);
  or0_map   : or_gate port map (x => and0, y => and1, z => cout);
end architecture structural_FA;

library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.all;
use work.eecs361_gates.all;

entity alu_unit is
  port (
    op      : in  std_logic_vector (1 downto 0);
    a       : in  std_logic;
    b       : in  std_logic;
    cin     : in  std_logic;  -- '1' -> Carry in
    inv     : in  std_logic;  -- '1' -> bInvert: invert b when doing subtraction
    less    : in  std_logic;  -- '1' -> Compare
    r       : out std_logic;  -- '1' -> Result
    cout    : out std_logic   -- '1' -> Carry out
  );
end alu_unit;

architecture structural_ALUunit of alu_unit is
component fulladder
  port (
    x       : in  std_logic;
    y       : in  std_logic;
    c       : in  std_logic;
    z       : out std_logic;
    cout    : out std_logic
  );
end component fulladder;
signal xor0 : std_logic;
signal and0 : std_logic;
signal or0  : std_logic;
signal fa0  : std_logic;  -- 1-bit fulladder result
signal mux0 : std_logic;
signal mux1 : std_logic;
begin
  xor0_map  : xor_gate port map (x => b, y => inv, z => xor0);
  and0_map  : and_gate port map (x => a, y => xor0, z => and0);
  or0_map   : or_gate port map (x => a, y => xor0, z => or0);
  fa0_map   : fulladder port map (x => a, y => xor0, c => cin, z=> fa0, cout => cout);
  mux0_map  : mux port map (sel => op(0), src0 => and0, src1 => or0, z => mux0);
  mux1_map  : mux port map (sel => op(0), src0 => fa0, src1 => less, z => mux1);
  mux2_map  : mux port map (sel => op(1), src0 => mux0, src1 => mux1, z => r);
end architecture structural_ALUunit;
