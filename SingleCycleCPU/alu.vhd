library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.all;
use work.eecs361_gates.all;

-- VALUES OF THE INPUT CONTROL SIGNAL ctrl:
-- arithmetic: add 0010, sub 0110
-- logical: and 0000, or 0001, sll 1000
-- conditional: slt 0111, sltu 1111

entity alu is
  port (
    ctrl  : in std_logic_vector (3 downto 0);
    A     : in std_logic_vector (31 downto 0);
    B     : in std_logic_vector (31 downto 0);
    shamt : in std_logic_vector (4 downto 0);
    cout  : out std_logic;                      -- '1' -> Carry out
    ovf   : out std_logic;                      -- '1' -> Overflow
    ze    : out std_logic;                      -- '1' -> Zero
    R     : out std_logic_vector (31 downto 0)  -- Result
  );
end alu;

architecture structural_ALU of alu is
component alu_unit
  port (
    op       : in  std_logic_vector (1 downto 0);
    a        : in  std_logic;
    b        : in  std_logic;
    cin      : in  std_logic;  -- '1' -> Carry in
    inv      : in  std_logic;  -- '1' -> bInvert: invert b when doing subtraction
    less     : in  std_logic;  -- '1' -> Compare
    r        : out std_logic;  -- '1' -> Result
    cout     : out std_logic   -- '1' -> Carry out
  );
end component alu_unit;
signal R0    : std_logic_vector (31 downto 0);
signal C     : std_logic_vector (31 downto 0);
signal ov    : std_logic;
signal xor0  : std_logic;
signal xor1  : std_logic;
signal set   : std_logic;
signal le0   : std_logic;
signal le1   : std_logic;
signal le    : std_logic;
signal R1    : std_logic_vector (31 downto 0);
signal R2    : std_logic_vector (31 downto 0);
signal R3    : std_logic_vector (31 downto 0);
signal R4    : std_logic_vector (31 downto 0);
signal R5    : std_logic_vector (31 downto 0);
signal not0  : std_logic;
signal R_sel : std_logic;
signal R6    : std_logic_vector (31 downto 0);
signal or_R  : std_logic_vector (30 downto 0);
begin
  unit_first  : alu_unit port map (op => ctrl(1 downto 0), a => A(0), b => B(0), cin => ctrl(2), inv => ctrl(2), less => le, r => R0(0), cout => C(0));
  unit_others : for i in 1 to 31 generate
  begin
    unit_map  : alu_unit port map (op => ctrl(1 downto 0), a => A(i), b => B(i), cin => C(i-1), inv => ctrl(2), less => '0', r => R0(i), cout => C(i));
  end generate unit_others;
  cout <= C(31);
  ovfdt    : xor_gate port map (x => C(30), y => C(31), z => ov);
  ovf <= ov;
  xor0_map : xor_gate port map (x => C(30), y => A(31), z => xor0);
  xor1_map : xor_gate port map (x => ctrl(2), y => B(31), z => xor1);
  xor2_map : xor_gate port map (x => xor0, y => xor1, z => set);
  le0dt    : xor_gate port map (x => set, y => ov, z => le0);
  le1dt    : not_gate port map (x => C(31), z => le1);
  le2dt    : mux port map (sel => ctrl(3), src0 => le0, src1 => le1, z => le);

  shifter_level_0_first  : mux port map (sel => shamt(0), src0 => A(0), src1 => '0', z => R1(0));
  shifter_level_0_others : for i in 1 to 31 generate
  begin
    mux0_others_map : mux port map (sel => shamt(0), src0 => A(i), src1 => A(i-1), z => R1(i));
  end generate shifter_level_0_others;
  shifter_level_1_first  : for i in 0 to 1 generate
  begin
    mux1_first_map  : mux port map (sel => shamt(1), src0 => R1(i), src1 => '0', z => R2(i));
  end generate shifter_level_1_first;
  shifter_level_1_others : for i in 2 to 31 generate
  begin
    mux1_others_map : mux port map (sel => shamt(1), src0 => R1(i), src1 => R1(i-2), z => R2(i));
  end generate shifter_level_1_others;
  shifter_level_2_first  : for i in 0 to 3 generate
  begin
    mux2_first_map  : mux port map (sel => shamt(2), src0 => R2(i), src1 => '0', z => R3(i));
  end generate shifter_level_2_first;
  shifter_level_2_others : for i in 4 to 31 generate
  begin
    mux2_others_map : mux port map (sel => shamt(2), src0 => R2(i), src1 => R2(i-4), z => R3(i));
  end generate shifter_level_2_others;
  shifter_level_3_first  : for i in 0 to 7 generate
  begin
    mux3_first_map  : mux port map (sel => shamt(3), src0 => R3(i), src1 => '0', z => R4(i));
  end generate shifter_level_3_first;
  shifter_level_3_others : for i in 8 to 31 generate
  begin
    mux3_others_map : mux port map (sel => shamt(3), src0 => R3(i), src1 => R3(i-8), z => R4(i));
  end generate shifter_level_3_others;
  shifter_level_4_first  : for i in 0 to 15 generate
  begin
    mux4_first_map  : mux port map (sel => shamt(4), src0 => R4(i), src1 => '0', z => R5(i));
  end generate shifter_level_4_first;
  shifter_level_4_others : for i in 16 to 31 generate
  begin
    mux4_others_map : mux port map (sel => shamt(4), src0 => R4(i), src1 => R4(i-16), z => R5(i));
  end generate shifter_level_4_others;
  
  not0_map : not_gate port map (x => ctrl(2), z => not0);
  and0_map : and_gate port map (x => not0, y => ctrl(3), z => R_sel);
  R_map    : mux_32 port map (sel => R_sel, src0 => R0, src1 => R5, z => R6);
  R <= R6;

  or_32to1_level_0 : for i in 0 to 15 generate
  begin
    or0_map : or_gate port map (x => R6(i), y => R6(31-i), z => or_R(i));
  end generate or_32to1_level_0;
  or_32to1_level_1 : for i in 0 to 7 generate
  begin
    or1_map : or_gate port map (x => or_R(i), y => or_R(15-i), z => or_R(i+16));
  end generate or_32to1_level_1;
  or_32to1_level_2 : for i in 0 to 3 generate
  begin
    or2_map : or_gate port map (x => or_R(i+16), y => or_R(23-i), z => or_R(i+24));
  end generate or_32to1_level_2;
  or_32to1_level_3 : for i in 0 to 1 generate
  begin
    or3_map : or_gate port map (x => or_R(i+24), y => or_R(27-i), z => or_R(i+28));
  end generate or_32to1_level_3;
  or_32to1_level_4 : or_gate port map (x => or_R(28), y => or_R(29), z => or_R(30));
  zedt      : not_gate port map (x => or_R(30), z => ze);
end architecture structural_ALU;
