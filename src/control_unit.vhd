library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.constants.all;

entity control_unit is
	port(
		I_CLK   : in std_logic;
		I_RST	: in std_logic;
		I_INSTR : in std_logic_vector(CELL_LEN - 1 downto 0);
		Q_CS    : out std_logic_vector(CS_LEN - 1 downto 0)
	);
end entity control_unit;

architecture RTL of control_unit is
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
	
	signal L_INSTR : std_logic_vector(CELL_LEN - 1 downto 0) := X"2b";

	component cycle_gen is
		port(
			I_CLK   : in  std_logic;
			I_INC   : in  std_logic;
			I_RST   : in  std_logic;
			Q_CYCLE : out std_logic_vector(2 downto 0)
		);
	end component cycle_gen;
	
	signal C_INC : std_logic;
	signal C_RST : std_logic;

	component itype_decoder is
		port(
			I_INSTR : in  std_logic_vector(CELL_LEN - 1 downto 0);
			Q_TYPE  : out std_logic_vector(8 downto 0)
		);
	end component itype_decoder;

	signal L_C  : std_logic_vector(2 downto 0);
	signal L_I  : std_logic_vector(8 downto 0);
	signal L_CS : std_logic_vector(CS_LEN - 1 downto 0);
begin
	ir : reg
		generic map(
			WIDTH => CELL_LEN
		)
		port map(
			I_CLK => I_CLK,
			I_D => I_INSTR,
			I_W => C_RST,
			Q_D => L_INSTR
		);

	cg : cycle_gen
		port map(
			I_CLK => I_CLK,
			I_INC => C_INC,
			I_RST => C_RST,
			Q_CYCLE => L_C
		);
		
	itd : itype_decoder
		port map(
			I_INSTR => L_INSTR,
			Q_TYPE => L_I
		);

	C_INC <= '1';
	C_RST <= '1' when (L_C(2) = '1' or I_RST = '1' or  L_I(8) = '0') else '0';

	L_CS(CS_ALUTSRC'range) <= "1" when (L_C(0) = '1' and (L_I(0) = '1' or L_I(1) = '1')) else "0";
	L_CS(CS_ADRSRC'range)  <= "1" when (L_C(1) = '1' and (L_I(0) = '1' or L_I(1) = '1' or L_I(2) = '1' or L_I(3) = '1')) or (L_I(8) = '0') else "0";
	L_CS(CS_ALUOP'range)   <= "1" when (L_C(1) = '1' and (L_I(1) = '1' or L_I(3) = '1')) else "0";
	L_CS(CS_DPW'range)     <= "1" when (L_C(2) = '1' and (L_I(2) = '1' or L_I(3) = '1')) else "0";
	L_CS(CS_MEMW'range)    <= "1" when (L_C(2) = '1' and (L_I(0) = '1' or L_I(1) = '1')) else "0";
	L_CS(CS_ALUTW'range)   <= "1" when (L_C(0) = '1' and (L_I(0) = '1' or L_I(1) = '1' or L_I(2) = '1' or L_I(3) = '1')) else "0";
	L_CS(CS_ALURW'range)   <= "1" when (L_C(1) = '1' and (L_I(0) = '1' or L_I(1) = '1' or L_I(2) = '1' or L_I(3) = '1')) else "0";
	L_CS(CS_IRW'range)     <= "1" when (L_C(1) = '1' and (L_I(0) = '1' or L_I(1) = '1' or L_I(2) = '1' or L_I(3) = '1')) or (L_I(8) = '0') else "0";
	L_CS(CS_IPINC'range)   <= "1" when (L_C(0) = '1' and (L_I(0) = '1' or L_I(1) = '1' or L_I(2) = '1' or L_I(3) = '1')) else "0";
	
	Q_CS <= L_CS;
end architecture RTL;
