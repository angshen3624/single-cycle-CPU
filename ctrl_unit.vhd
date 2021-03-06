library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

entity ctrl_unit is
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
end ctrl_unit;

architecture structure of ctrl_unit is
  
signal addi_and_in    : std_logic_vector(5 downto 0);
signal lw_and_in      : std_logic_vector(5 downto 0);
signal sw_and_in      : std_logic_vector(5 downto 0);
signal beq_and_in     : std_logic_vector(5 downto 0);
signal bne_and_in     : std_logic_vector(5 downto 0);
signal rtype_and_in   : std_logic_vector(5 downto 0);
signal wire           : std_logic_vector(1 downto 0);
signal addi_and_out, lw_and_out, sw_and_out, beq_and_out, bne_and_out, rtype_and_out : std_logic;


component and_6to1 is
  port (
    op        : in std_logic_vector(5 downto 0);      
    oq        : out std_logic
);
end component;


begin
    rtype_and_0:    not_gate port map(op(0), rtype_and_in(0));
    rtype_and_1:    not_gate port map(op(1), rtype_and_in(1));
    rtype_and_2:    not_gate port map(op(2), rtype_and_in(2));
    rtype_and_3:    not_gate port map(op(3), rtype_and_in(3));
    rtype_and_4:    not_gate port map(op(4), rtype_and_in(4));
    rtype_and_5:    not_gate port map(op(5), rtype_and_in(5));
    rtype_and_6:    and_6to1 port map(rtype_and_in(5 downto 0), rtype_and_out);
      
    addi_and_0:     not_gate port map(op(0), addi_and_in(0));
    addi_and_1:     not_gate port map(op(1), addi_and_in(1));
    addi_and_2:     not_gate port map(op(2), addi_and_in(2));
    addi_and_3:     not_gate port map(op(4), addi_and_in(4));
    addi_and_4:     not_gate port map(op(5), addi_and_in(5)); 
    addi_and_in(3) <= op(3);
    addi_and_5:     and_6to1 port map(addi_and_in(5 downto 0), addi_and_out);
    
    lw_and_0:       not_gate port map(op(2), lw_and_in(2));
    lw_and_1:       not_gate port map(op(3), lw_and_in(3));
    lw_and_2:       not_gate port map(op(4), lw_and_in(4));
    lw_and_in(0) <= op(0);
    lw_and_in(1) <= op(1);
    lw_and_in(5) <= op(5);
    lw_and_3:       and_6to1 port map(lw_and_in(5 downto 0), lw_and_out);
    
    sw_and_0:       not_gate port map(op(2), sw_and_in(2));
    sw_and_1:       not_gate port map(op(4), sw_and_in(4));
    sw_and_in(0) <= op(0);
    sw_and_in(1) <= op(1);
    sw_and_in(3) <= op(3);
    sw_and_in(5) <= op(5);
    sw_and_2:       and_6to1 port map(sw_and_in(5 downto 0), sw_and_out);
    
    beq_and_0:     not_gate port map(op(0), beq_and_in(0));
    beq_and_1:     not_gate port map(op(1), beq_and_in(1));
    beq_and_2:     not_gate port map(op(3), beq_and_in(3));
    beq_and_3:     not_gate port map(op(4), beq_and_in(4));
    beq_and_4:     not_gate port map(op(5), beq_and_in(5)); 
    beq_and_in(2) <= op(2);
    beq_and_5:     and_6to1 port map(beq_and_in(5 downto 0), beq_and_out);
    
    bne_and_0:     not_gate port map(op(1), bne_and_in(1));
    bne_and_1:     not_gate port map(op(3), bne_and_in(3));
    bne_and_2:     not_gate port map(op(4), bne_and_in(4));
    bne_and_3:     not_gate port map(op(5), bne_and_in(5));
    bne_and_in(0) <= op(0);
    bne_and_in(2) <= op(2);
    bne_and_4:     and_6to1 port map(bne_and_in(5 downto 0), bne_and_out);
    
    
    -- RegDst       
    RegDst <= rtype_and_out;
    
    -- ALUsrc
    ALUsrc_or_0:   or_gate port map(addi_and_out, lw_and_out, wire(0));
    ALUsrc_or_1:   or_gate port map(wire(0), sw_and_out, ALUsrc);
      
    -- MemtoReg
    MemtoReg <= lw_and_out;
    
    -- RegWrite
    RegWrite_or_0: or_gate port map(addi_and_out, lw_and_out, wire(1));
    RegWrite_or_1: or_gate port map(wire(1), rtype_and_out, RegWrite);

    -- MemWrite
    MemWrite <= sw_and_out;
    
    -- NotBranch
    NotBranch <= bne_and_out;
    
    -- Branch
    Branch <= beq_and_out;
    
    -- ALUop
    ALUop(1) <= rtype_and_out;
    ALUop_or_0:    or_gate port map(beq_and_out, bne_and_out, ALUop(0));

end architecture;
  
  
  
  
  
