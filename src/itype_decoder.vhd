library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
use work.constants.all;

entity itype_decoder is
	port(
		I_INSTR : in  std_logic_vector(CELL_LEN - 1 downto 0);
		Q_TYPE  : out std_logic_vector(8 downto 0)
	);
end entity itype_decoder;

architecture RTL of itype_decoder is
	signal L_TYPE : std_logic_vector(8 downto 0);
begin
	L_TYPE(0)  <= '1' when I_INSTR = X"2b" else '0'; -- +
	L_TYPE(1)  <= '1' when I_INSTR = X"2d" else '0'; -- -
	L_TYPE(2)  <= '1' when I_INSTR = X"3e" else '0'; -- >
	L_TYPE(3)  <= '1' when I_INSTR = X"3c" else '0'; -- <
	L_TYPE(4)  <= '1' when I_INSTR = X"2e" else '0'; -- .
	L_TYPE(5)  <= '1' when I_INSTR = X"2c" else '0'; -- ,
	L_TYPE(6)  <= '1' when I_INSTR = X"5b" else '0'; -- [
	L_TYPE(7)  <= '1' when I_INSTR = X"5d" else '0'; -- ]
	L_TYPE(8)  <= L_TYPE(0) or L_TYPE(1) or L_TYPE(2) or L_TYPE(3) or L_TYPE(4) or L_TYPE(5) or L_TYPE(6) or L_TYPE(7);
	
	Q_TYPE <= L_TYPE;
end architecture RTL;
