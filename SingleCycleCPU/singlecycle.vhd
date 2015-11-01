library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.all;
use work.eecs361_gates.all;

entity singlecycle is
  generic (
    mem_file : string
  );
  port (
    clk    : in std_logic;
    ainit  : in std_logic
  );
end singlecycle;

architecture structural of singlecycle is
component alu
  port(
    ctrl  : in  std_logic_vector (3 downto 0);
    A     : in  std_logic_vector (31 downto 0);
    B     : in  std_logic_vector (31 downto 0);
    shamt : in  std_logic_vector (4 downto 0);
    cout  : out std_logic;                      -- '1' -> Carry out
    ovf   : out std_logic;                      -- '1' -> Overflow
    ze    : out std_logic;                      -- '1' -> Zero
    R     : out std_logic_vector (31 downto 0)  -- Result
  );
end component alu;

component ctrl_unit
  port (
    op        : in  std_logic_vector (5 downto 0);      
    RegDst    : out std_logic;
    ALUsrc    : out std_logic;
    MemtoReg  : out std_logic;
    RegWrite  : out std_logic;
    MemWrite  : out std_logic;
    NotBranch : out std_logic;
    Branch    : out std_logic;
    ALUop     : out std_logic_vector (1 downto 0)
);
end component ctrl_unit; 

component alu_ctrl
  port (
    ALUop     : in  std_logic_vector (1 downto 0);      
    func      : in  std_logic_vector (5 downto 0);
    ALUctr    : out std_logic_vector (3 downto 0)
);
end component alu_ctrl;

component reg_file
  port (
    clk	      : in  std_logic;
    arst      : in  std_logic;
    Wr_enable : in  std_logic;
    Ra        : in  std_logic_vector (4 downto 0);
    Rb        : in  std_logic_vector (4 downto 0);
    Rw        : in  std_logic_vector (4 downto 0);
    data_in   : in  std_logic_vector (31 downto 0);
    data_out1 : out std_logic_vector (31 downto 0);
    data_out2 : out std_logic_vector (31 downto 0)
  );
end component reg_file;

component prog_cnt
  port (
    clk    : in  std_logic;
    aload  : in  std_logic;
    adata  : in  std_logic_vector (31 downto 0);
    pc_in  : in  std_logic_vector (31 downto 0);
    pc_out : out std_logic_vector (31 downto 0)
  );
end component prog_cnt;

component adder
  port (
    A     : in  std_logic_vector (31 downto 0);
    B     : in  std_logic_vector (31 downto 0);
    R     : out std_logic_vector (31 downto 0)
  );
end component adder;

component sign_extender
  port (
    data_in  : in  std_logic_vector (15 downto 0);
    data_out : out std_logic_vector (31 downto 0)
  );
end component sign_extender;
signal in_clk : std_logic;
signal PC     : std_logic_vector (31 downto 0);
signal newPC  : std_logic_vector (31 downto 0);
signal inst   : std_logic_vector (31 downto 0);
signal op     : std_logic_vector (5 downto 0);
signal rs     : std_logic_vector (4 downto 0);
signal rt     : std_logic_vector (4 downto 0);
signal rd     : std_logic_vector (4 downto 0);
signal shamt  : std_logic_vector (4 downto 0);
signal func   : std_logic_vector (5 downto 0);
signal imm16  : std_logic_vector (15 downto 0);
signal RegDst, ALUsrc, MemtoReg, RegWrite, MemWrite, NotBranch, Branch : std_logic;
signal ALUop  : std_logic_vector (1 downto 0);
signal ALUctr : std_logic_vector (3 downto 0);
signal dstreg : std_logic_vector (4 downto 0);
signal busA   : std_logic_vector (31 downto 0);
signal busB   : std_logic_vector (31 downto 0);
signal busW   : std_logic_vector (31 downto 0);
signal imm32  : std_logic_vector (31 downto 0);
signal aluopB : std_logic_vector (31 downto 0);
signal cout   : std_logic;
signal ovf    : std_logic;
signal zero   : std_logic;
signal result : std_logic_vector (31 downto 0);
signal synMemWrite1 : std_logic;
signal synMemWrite2 : std_logic;
signal memdata : std_logic_vector (31 downto 0);
signal reladdr : std_logic_vector (31 downto 0);
signal PC_1   : std_logic_vector (31 downto 0);
signal PC_2   : std_logic_vector (31 downto 0);
signal nonzero: std_logic;
signal PCsel_1: std_logic;
signal PCsel_2: std_logic;
signal PCsel : std_logic;
begin
  clk_map : not_gate port map (x => clk, z => in_clk);
  pc_map  : prog_cnt port map (clk => in_clk, aload => ainit, adata => x"00400020", pc_in => newPC, pc_out => PC);
  I_mem   : sram generic map (mem_file => mem_file) port map (cs => '1', oe => '1', we => '0', addr => PC, din => x"00000000", dout => inst);
  op    <= inst (31 downto 26);
  rs    <= inst (25 downto 21);
  rt    <= inst (20 downto 16);
  rd    <= inst (15 downto 11);
  shamt <= inst (10 downto 6);
  func  <= inst (5 downto 0);
  imm16 <= inst (15 downto 0);
  ctr_map : ctrl_unit port map (op => op, RegDst => RegDst, ALUsrc => ALUsrc, MemtoReg => MemtoReg, RegWrite => RegWrite, 
				MemWrite => MemWrite, NotBranch => NotBranch, Branch => Branch, ALUop => ALUop);
  aluctr_map : alu_ctrl port map (ALUop => ALUop, func => func, ALUctr => ALUctr);
  regdst_map : mux_n generic map (n => 5) port map (sel => RegDst, src0 => rt, src1 => rd, z => dstreg);
  regs_map : reg_file port map (clk => clk, arst => ainit, Wr_enable => RegWrite, Ra => rs, Rb => rt, Rw => dstreg, data_in => busW, data_out1 => busA, data_out2 => busB);
  ext_map : sign_extender port map (data_in => imm16, data_out => imm32);
  alusrc_map : mux_32 port map (sel => ALUsrc, src0 => busB, src1 => imm32, z => aluopB);
  alu_map : alu port map (ctrl => ALUctr, A => busA, B => aluopB, shamt => shamt, cout => cout, ovf => ovf, ze => zero, R => result);
  -- synwrite1 : dffr port map (clk => clk, d => MemWrite, q =>synMemWrite1);
  synwrite2 : and_gate port map (x => clk, y => MemWrite, z =>synMemWrite2);
  D_mem  : sram generic map (mem_file => mem_file) port map (cs => '1', oe => '1', we => synMemWrite2, addr => result, din => busB, dout => memdata);
  memtoreg_map : mux_32 port map (sel => MemtoReg, src0 => result, src1 => memdata, z => busW);
  reladdr (31 downto 2) <= imm32 (29 downto 0);
  reladdr (1 downto 0) <= "00";
  adder1_map : adder port map (A => PC, B => x"00000004", R => PC_1);
  adder2_map : adder port map (A => PC_1, B => reladdr, R => PC_2);
  beq_map : and_gate port map (x => Branch, y => zero, z => PCsel_1);
  not_map : not_gate port map (x => zero, z => nonzero);
  bne_map : and_gate port map (x => NotBranch, y => nonzero, z => PCsel_2);
  or_map  : or_gate port map (x => PCsel_1, y => PCsel_2, z => PCsel);
  branch_map : mux_32 port map (sel => PCsel, src0 => PC_1, src1 => PC_2, z => newPC);

end structural;