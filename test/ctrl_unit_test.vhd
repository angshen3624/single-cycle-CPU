library ieee;
use ieee.std_logic_1164.all;

entity ctrl_unit_test is
end ctrl_unit_test;

architecture mix of ctrl_unit_test is
  
signal op_t        : std_logic_vector(5 downto 0);      
signal RegDst_t    : std_logic;
signal ALUsrc_t    : std_logic;
signal MemtoReg_t  : std_logic;
signal RegWrite_t  : std_logic;
signal MemWrite_t  : std_logic;
signal NotBranch_t : std_logic;
signal Branch_t    : std_logic;
signal ALUop_t     : std_logic_vector(1 downto 0);

component ctrl_unit is
  port (
    op        : in std_logic_vector(5 downto 0);      
    RegDst    : out std_logic;
    ALUsrc    : out std_logic;
    MemtoReg  : out std_logic;
    RegWrite  : out std_logic;
    MemWrite  : out std_logic;
    NotBranch : out std_logic;
    Branch    : out std_logic;
    ALUop     : out std_logic_vector(1 downto 0)
);
end component;

begin
  test_port : 
    ctrl_unit port map(op => op_t,
                      RegDst => RegDst_t,
                      ALUsrc => ALUsrc_t,
                      MemtoReg => MemtoReg_t,
                      RegWrite => RegWrite_t,
                      MemWrite => MemWrite_t,
                      NotBranch => NotBranch_t,
                      Branch => Branch_t,
                      ALUop => ALUop_t);
                      
  test_bench : process
  begin
    -- 1
    op_t <= "001000";    
    wait for 10 ns;
    
    -- 2
    op_t <= "100011";    
    wait for 10 ns;
    
    -- 3
    op_t <= "101011";    
    wait for 10 ns;
    
    --4
    op_t <= "000100";    
    wait for 10 ns;
    
    --5
    op_t <= "000101";    
    wait for 10 ns;
    
    --6
    op_t <= "000000";    
    wait for 10 ns;
    
    end process;
  
end architecture;


