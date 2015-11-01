library ieee;
use ieee.std_logic_1164.all;

entity alu_ctrl_test is
end alu_ctrl_test;

architecture mix of alu_ctrl_test is
  
signal ALUop_t : std_logic_vector(1 downto 0);
signal func_t : std_logic_vector(5 downto 0);
signal ALUctr_t : std_logic_vector(3 downto 0);

component alu_ctrl is
  port (
    ALUop     : in std_logic_vector(1 downto 0);      
    func      : in std_logic_vector(5 downto 0);
    ALUctr    : out std_logic_vector(3 downto 0)
);
end component;

begin
  test_port : 
    alu_ctrl port map(ALUop => ALUop_t,
                      func => func_t,
                      ALUctr => ALUctr_t);
  test_bench : process
  begin
    -- 1
    ALUop_t <= "00";
    func_t <= "000000";    
    wait for 10 ns;
    
    -- 2
    ALUop_t <= "00";
    func_t <= "111111";    
    wait for 10 ns;
    
    -- 3
    ALUop_t <= "01";
    func_t <= "000000";    
    wait for 10 ns;
    
    --4
    ALUop_t <= "10";
    func_t <= "100000";    
    wait for 10 ns;
    
    --5
    ALUop_t <= "11";
    func_t <= "100001";    
    wait for 10 ns;
    
    --6
    ALUop_t <= "10";
    func_t <= "100010";    
    wait for 10 ns;
    
    --7
    ALUop_t <= "10";
    func_t <= "100011";    
    wait for 10 ns;
    
    --8
    ALUop_t <= "10";
    func_t <= "100100";    
    wait for 10 ns;
     
    --9
    ALUop_t <= "10";
    func_t <= "100101";    
    wait for 10 ns;
    
    --10
    ALUop_t <= "10";
    func_t <= "000000";    
    wait for 10 ns;
    
    --11
    ALUop_t <= "10";
    func_t <= "101010";    
    wait for 10 ns;
    
    --12
    ALUop_t <= "10";
    func_t <= "101011";    
    wait for 10 ns;
    
    end process;
  
end architecture;


