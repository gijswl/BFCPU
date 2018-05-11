library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
use work.constants.all;

entity cpu_top is
	port(
		I_CLK : in  std_logic;
		I_RST : in  std_logic;
		I_DAT : in  std_logic_vector(CELL_LEN - 1 downto 0);
		Q_ADR : out std_logic_vector(ADR_LEN downto 0);
		Q_DAT : out std_logic_vector(CELL_LEN - 1 downto 0);
		Q_RW  : out std_logic
	);
end entity cpu_top;

architecture RTL of cpu_top is
	component reg is
		generic(
			WIDTH : natural
		);
		port(
			I_CLK : in  std_logic;
			I_D   : in  std_logic_vector(WIDTH - 1 downto 0);
			I_W   : in  std_logic;
			Q_D   : out std_logic_vector(WIDTH - 1 downto 0)
		);
	end component reg;
	
	component reg_inc is
		generic(
			WIDTH : natural
		);
		port(
			I_CLK : in  std_logic;
			I_D   : in  std_logic_vector(WIDTH - 1 downto 0);
			I_INC : in  std_logic;
			I_W   : in  std_logic;
			Q_D   : out std_logic_vector(WIDTH - 1 downto 0)
		);
	end component reg_inc;
	
	signal DP_W    : std_logic;
	signal DP_DOUT : std_logic_vector(DP_LEN - 1 downto 0);
	
	signal ALUT_W   : std_logic;
	signal ALUT_DIN : std_logic_vector(DP_LEN - 1 downto 0);
	
	signal ALUR_W    : std_logic;
	signal ALUR_DOUT : std_logic_vector(DP_LEN - 1 downto 0);
	
	signal IP_W    : std_logic;
	signal IP_INC  : std_logic;
	signal IP_DIN  : std_logic_vector(ADR_LEN - 1 downto 0);
	signal IP_DOUT : std_logic_vector(ADR_LEN - 1 downto 0);
	
	signal IR_W    : std_logic;
	signal IR_DOUT : std_logic_vector(CELL_LEN - 1 downto 0);
	
	component alu is
		generic(
			WIDTH : natural
		);
		port(
			I_OP : in std_logic;
			I_D  : in std_logic_vector(WIDTH - 1 downto 0);
			Q_D  : out std_logic_vector(WIDTH - 1 downto 0)
		);
	end component alu;
	
	signal ALU_OP  : std_logic;
	signal ALU_IN  : std_logic_vector(ALU_LEN - 1 downto 0);
	signal ALU_OUT : std_logic_vector(ALU_LEN - 1 downto 0);
	
	component control_unit is
		port(
			I_CLK   : in std_logic;
			I_RST   : in std_logic;
			I_INSTR : in std_logic_vector(CELL_LEN - 1 downto 0);
			Q_CS    : out std_logic_vector(CS_LEN - 1 downto 0)
		);
	end component control_unit;
	
	signal L_CS : std_logic_vector(CS_LEN - 1 downto 0);
begin
	reset : process(I_RST)
	begin
		
	end process reset;

	data_pointer : reg
		generic map(
			WIDTH => DP_LEN
		)
		port map(
			I_CLK => I_CLK,
			I_D   => ALUR_DOUT,
			I_W   => DP_W,
			Q_D   => DP_DOUT
		);
		
	instruction_pointer : reg_inc
		generic map(
			WIDTH => ADR_LEN
		)
		port map(
			I_CLK => I_CLK,
			I_D   => IP_DIN,
			I_INC => IP_INC,
			I_W   => IP_W,
			Q_D   => IP_DOUT
		);
	
	instruction_reg : reg
		generic map(
			WIDTH => CELL_LEN
		)
		port map(
			I_CLK => I_CLK,
			I_D   => I_DAT,
			I_W   => IR_W,
			Q_D   => IR_DOUT
		);
	
	alu_tmp : reg
		generic map(
			WIDTH => ALU_LEN
		)
		port map(
			I_CLK => I_CLK,
			I_D   => ALUT_DIN,
			I_W   => ALUT_W,
			Q_D   => ALU_IN
		);
	
	alu_res : reg
		generic map(
			WIDTH => ALU_LEN
		)
		port map(
			I_CLK => I_CLK,
			I_D   => ALU_OUT,
			I_W   => ALUR_W,
			Q_D   => ALUR_DOUT
		);
		
	alu_t : alu
		generic map(
			WIDTH => ALU_LEN
		)
		port map(
			I_OP => ALU_OP,
			I_D  => ALU_IN,
			Q_D  => ALU_OUT
		);
		
	cu : control_unit
		port map(
			I_CLK => I_CLK,
			I_RST => I_RST,
			I_INSTR => IR_DOUT,
			Q_CS => L_CS
		);
		
	ALUT_DIN <= DP_DOUT when L_CS(CS_ALUTSRC'range) = "0" else (14 downto CELL_LEN => '0') & I_DAT;
		
	ALU_OP <= '1' when L_CS(CS_ALUOP'range) = "1" else '0';
	DP_W   <= '1' when L_CS(CS_DPW'range) = "1" else '0';
	ALUT_W <= '1' when L_CS(CS_ALUTW'range) = "1" else '0';
	ALUR_W <= '1' when L_CS(CS_ALURW'range) = "1" else '0';
	IR_W   <= '1' when L_CS(CS_IRW'range) = "1" else '0';
	IP_INC <= '1' when L_CS(CS_IPINC'range) = "1" else '0';
	
	Q_RW  <= '1' when L_CS(CS_MEMW'range) = "1" else '0';
	Q_ADR <= ((ADR_LEN downto DP_LEN => '1') & DP_DOUT) when L_CS(CS_ADRSRC'range) = "0" else ('0' & IP_DOUT);
	Q_DAT <= ALUR_DOUT(CELL_LEN - 1 downto 0);
end architecture RTL;
