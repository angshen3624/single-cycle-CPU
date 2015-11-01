library ieee;
use ieee.std_logic_1164.all;

entity alu_unit_demo is
  port (
    r        : out std_logic;
    cout     : out std_logic
  );
end alu_unit_demo;

architecture structural_unitDemo of alu_unit_demo is
component alu_unit is
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
signal op    : std_logic_vector (1 downto 0);
signal a     : std_logic;
signal b     : std_logic;
signal cin   : std_logic;
signal inv   : std_logic;
signal less  : std_logic;
signal inbus : std_logic_vector (6 downto 0);
begin
  unit_map   : alu_unit port map (op, a, b, cin, inv, less, r, cout);
  op   <= inbus(6 downto 5);
  a    <= inbus(4);
  b    <= inbus(3);
  cin  <= inbus(2);
  inv  <= inbus(1);
  less <= inbus(0);

  test_proc  : process
  begin
    -- and
    inbus <= "0010000";
    wait for 5 ns;
    inbus <= "0011000";
    wait for 5 ns;
    -- or
    inbus <= "0100000";
    wait for 5 ns;
    inbus <= "0101000";
    wait for 5 ns;
    -- add
    inbus <= "1011100";
    wait for 5 ns;
    -- sub
    inbus <= "1001110";
    wait for 5 ns;
    -- less for slt & sltu
    inbus <= "1100000";
    wait for 5 ns;
    inbus <= "1100001";
    wait for 5 ns;
    wait;
  end process;
end architecture structural_unitDemo;
