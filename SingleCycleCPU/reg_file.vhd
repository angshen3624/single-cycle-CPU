library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.all;

entity file_unit is
  port (
	clk	 : in  std_logic;
        arst     : in  std_logic;
        enable   : in  std_logic;
	data_in	 : in  std_logic_vector (31 downto 0);
	data_out : out std_logic_vector (31 downto 0)
  );
end file_unit;

architecture structural_regFileUnit of file_unit is
begin
  reg : for i in 0 to 31 generate
  begin
    dffr_a_map : dffr_a port map (clk => clk, arst => arst, aload => '0', adata => '0', d => data_in(i), enable => enable, q => data_out(i));
  end generate reg;
end architecture structural_regFileUnit;

library ieee;
use ieee.std_logic_1164.all;
use work.eecs361.all;
use work.eecs361_gates.all;

entity reg_file is
  port (
	clk	  : in  std_logic;
        arst      : in  std_logic;
        Wr_enable : in  std_logic;
        Ra        : in  std_logic_vector (4 downto 0);
        Rb        : in  std_logic_vector (4 downto 0);
        Rw        : in  std_logic_vector (4 downto 0);
	data_in	  : in  std_logic_vector (31 downto 0);
	data_out1 : out std_logic_vector (31 downto 0);
	data_out2 : out std_logic_vector (31 downto 0)
  );
end reg_file;

architecture structural_regFile of reg_file is
component file_unit
  port (
    clk	     : in  std_logic;
    arst     : in  std_logic;
    enable   : in  std_logic;
    data_in  : in  std_logic_vector (31 downto 0);
    data_out : out std_logic_vector (31 downto 0)
  );
end component file_unit;
signal Wr_sel  : std_logic_vector (31 downto 0);
signal enables : std_logic_vector (31 downto 0);
signal reg_res : std_logic_vector (1023 downto 0);
signal mux0_0  : std_logic_vector (511 downto 0);
signal mux0_1  : std_logic_vector (255 downto 0);
signal mux0_2  : std_logic_vector (127 downto 0);
signal mux0_3  : std_logic_vector (63 downto 0);
signal mux1_0  : std_logic_vector (511 downto 0);
signal mux1_1  : std_logic_vector (255 downto 0);
signal mux1_2  : std_logic_vector (127 downto 0);
signal mux1_3  : std_logic_vector (63 downto 0);

signal r00, r01, r02, r03, r04, r05, r06, r07, r08, r09, r10,
 r11, r12, r13, r14, r15, r16, r17, r18, r19, r20,
 r21, r22, r23, r24, r25, r26, r27, r28, r29, r30,
 r31 : std_logic_vector (31 downto 0);

begin
  dec_map : dec_n generic map (n => 5) port map (src => Rw, z => Wr_sel);
  sel : for i in 0 to 31 generate
  begin
    enables_map : and_gate port map (x => Wr_enable, y => Wr_sel(i), z => enables(i));
  end generate sel;
  regs : for i in 0 to 31 generate
  begin
    unit_map : file_unit port map (clk => clk, arst => arst, enable => enables(i), data_in => data_in, data_out => reg_res(((i+1)*32-1) downto (i*32)));
  end generate regs;

  mux0_32to1_level_0 : for i in 0 to 15 generate
  begin
    mux0_0_map : mux_32 port map (sel => Ra(0), src0 => reg_res((((2*i)+1)*32-1) downto ((2*i)*32)), src1 => reg_res((((i*2)+2)*32-1) downto (((i*2)+1)*32)), z => mux0_0(((i+1)*32-1) downto (i*32)));
  end generate mux0_32to1_level_0;
  mux0_32to1_level_1 : for i in 0 to 7 generate
  begin
    mux0_1_map : mux_32 port map (sel => Ra(1), src0 => mux0_0((((2*i)+1)*32-1) downto ((2*i)*32)), src1 => mux0_0((((i*2)+2)*32-1) downto (((i*2)+1)*32)), z => mux0_1(((i+1)*32-1) downto (i*32)));
  end generate mux0_32to1_level_1;
  mux0_32to1_level_2 : for i in 0 to 3 generate
  begin
    mux0_2_map : mux_32 port map (sel => Ra(2), src0 => mux0_1((((2*i)+1)*32-1) downto ((2*i)*32)), src1 => mux0_1((((i*2)+2)*32-1) downto (((i*2)+1)*32)), z => mux0_2(((i+1)*32-1) downto (i*32)));
  end generate mux0_32to1_level_2;
  mux0_32to1_level_3 : for i in 0 to 1 generate
  begin
    mux0_3_map : mux_32 port map (sel => Ra(3), src0 => mux0_2((((2*i)+1)*32-1) downto ((2*i)*32)), src1 => mux0_2((((i*2)+2)*32-1) downto (((i*2)+1)*32)), z => mux0_3(((i+1)*32-1) downto (i*32)));
  end generate mux0_32to1_level_3;
  mux0_32to1_level_4 : mux_32 port map (sel => Ra(4), src0 => mux0_3(31 downto 0), src1 => mux0_3(63 downto 32), z => data_out1);

  mux1_32to1_level_0 : for i in 0 to 15 generate
  begin
    mux1_0_map : mux_32 port map (sel => Rb(0), src0 => reg_res((((2*i)+1)*32-1) downto ((2*i)*32)), src1 => reg_res((((i*2)+2)*32-1) downto (((i*2)+1)*32)), z => mux1_0(((i+1)*32-1) downto (i*32)));
  end generate mux1_32to1_level_0;
  mux1_32to1_level_1 : for i in 0 to 7 generate
  begin
    mux1_1_map : mux_32 port map (sel => Rb(1), src0 => mux1_0((((2*i)+1)*32-1) downto ((2*i)*32)), src1 => mux1_0((((i*2)+2)*32-1) downto (((i*2)+1)*32)), z => mux1_1(((i+1)*32-1) downto (i*32)));
  end generate mux1_32to1_level_1;
  mux1_32to1_level_2 : for i in 0 to 3 generate
  begin
    mux1_2_map : mux_32 port map (sel => Rb(2), src0 => mux1_1((((2*i)+1)*32-1) downto ((2*i)*32)), src1 => mux1_1((((i*2)+2)*32-1) downto (((i*2)+1)*32)), z => mux1_2(((i+1)*32-1) downto (i*32)));
  end generate mux1_32to1_level_2;
  mux1_32to1_level_3 : for i in 0 to 1 generate
  begin
    mux1_3_map : mux_32 port map (sel => Rb(3), src0 => mux1_2((((2*i)+1)*32-1) downto ((2*i)*32)), src1 => mux1_2((((i*2)+2)*32-1) downto (((i*2)+1)*32)), z => mux1_3(((i+1)*32-1) downto (i*32)));
  end generate mux1_32to1_level_3;
  mux1_32to1_level_4 : mux_32 port map (sel => Rb(4), src0 => mux1_3(31 downto 0), src1 => mux1_3(63 downto 32), z => data_out2);

  r00 <= reg_res (31 downto 0);
  r01 <= reg_res (63 downto 32);
  r02 <= reg_res (95 downto 64);
  r03 <= reg_res (127 downto 96);
  r04 <= reg_res (159 downto 128);
  r05 <= reg_res (191 downto 160);
  r06 <= reg_res (223 downto 192);
  r07 <= reg_res (255 downto 224);
  r08 <= reg_res (287 downto 256);
  r09 <= reg_res (319 downto 288);
  r10 <= reg_res (351 downto 320);
  r11 <= reg_res (383 downto 352);
  r12 <= reg_res (415 downto 384);
  r13 <= reg_res (447 downto 416);
  r14 <= reg_res (479 downto 448);
  r15 <= reg_res (511 downto 480);
  r16 <= reg_res (543 downto 512);
  r17 <= reg_res (575 downto 544);
  r18 <= reg_res (607 downto 576);
  r19 <= reg_res (639 downto 608);
  r20 <= reg_res (671 downto 640);
  r21 <= reg_res (703 downto 672);
  r22 <= reg_res (735 downto 704);
  r23 <= reg_res (767 downto 736);
  r24 <= reg_res (799 downto 768);
  r25 <= reg_res (831 downto 800);
  r26 <= reg_res (863 downto 832);
  r27 <= reg_res (895 downto 864);
  r28 <= reg_res (927 downto 896);
  r29 <= reg_res (959 downto 928);
  r30 <= reg_res (991 downto 960);
  r31 <= reg_res (1023 downto 992);

end architecture structural_regFile;