library ieee;
use ieee.std_logic_1164.all;

entity alu_demo is
  port (
    cout  : out std_logic;                      -- '1' -> Carry out
    ovf   : out std_logic;                      -- '1' -> Overflow
    ze    : out std_logic;                      -- '1' -> Zero
    R     : out std_logic_vector (31 downto 0)  -- Result
  );
end alu_demo;

architecture structural_aluDemo of alu_demo is
component alu is
  port (
    ctrl  : in std_logic_vector (3 downto 0);
    A     : in std_logic_vector (31 downto 0);
    B     : in std_logic_vector (31 downto 0);
    cout  : out std_logic;                      -- '1' -> Carry out
    ovf   : out std_logic;                      -- '1' -> Overflow
    ze    : out std_logic;                      -- '1' -> Zero
    R     : out std_logic_vector (31 downto 0)  -- Result
  );
end component alu;
signal ctrl  : std_logic_vector (3 downto 0);
signal A     : std_logic_vector (31 downto 0);
signal B     : std_logic_vector (31 downto 0);
begin
  alu_map    : alu port map (ctrl, A, B, cout, ovf, ze, R);

  test_proc  : process
  begin
    -- sll
    ctrl <= "1000";
    A <= x"0000a54b";
    B <= x"0000001f";
    wait for 10 ns;
    -- slt
    ctrl <= "0111";
    A <= x"00100456";
    B <= x"01000010";
    wait for 10 ns;    
    A <= x"80000000";
    B <= x"ffffffff";
    wait for 10 ns;
    A <= x"7fffffff";
    B <= x"80000000";
    wait for 10 ns;
    A <= x"80000000";
    B <= x"7fffffff";
    wait for 10 ns;
    -- sltu
    ctrl <= "1111";
    A <= x"80000000";
    B <= x"7fffffff";
    wait for 10 ns;
    A <= x"70000000";
    B <= x"ffffffff";
    wait for 10 ns;      
    -- add
    ctrl <= "0010";
    A <= x"00000001";
    B <= x"7fffffff";
    wait for 10 ns;  
    A <= x"ffffffff";
    B <= x"80000000";
    wait for 10 ns;
    A <= x"04d32657";
    B <= x"c5723455";
    wait for 10 ns;
    -- sub
    ctrl <= "0110";
    A <= x"0085ce11";
    B <= x"0085ce11";
    wait for 10 ns;  
    A <= x"80000000";
    B <= x"7fffffff";
    wait for 10 ns;
    A <= x"04d32657";
    B <= x"05723455";
    wait for 10 ns;
    -- and
    ctrl <= "0000";
    A <= x"fff9d000";
    B <= x"0005ffff";
    wait for 10 ns;
    -- or
    ctrl <= "0001";
    A <= x"fff9d000";
    B <= x"00052fff";
    wait for 10 ns;
    wait;
  end process;
end architecture structural_aluDemo;
 
