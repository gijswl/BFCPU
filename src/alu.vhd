library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
use work.constants.all;

entity alu is
	generic(
		WIDTH : natural
	);
	port(
		I_OP : in std_logic;
		I_D  : in std_logic_vector(WIDTH - 1 downto 0);
		Q_D  : out std_logic_vector(WIDTH - 1 downto 0);
		Q_F  : out std_logic
	);
end entity alu;

architecture RTL of alu is
	signal L_INCR : std_logic_vector(WIDTH - 1 downto 0);
	signal L_DECR : std_logic_vector(WIDTH - 1 downto 0);
begin
	L_INCR <= I_D + "1";
	L_DECR <= I_D - "1";
	
	Q_D <= L_INCR when I_OP = '0' else L_DECR;
	Q_F <= '1' when I_D = (WIDTH - 1 downto 0 => '0') else '0';
end architecture RTL;
