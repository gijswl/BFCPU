library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
use work.constants.all;

entity reg_inc is
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
end entity reg_inc;

architecture RTL of reg_inc is
	signal L_CONTENT : std_logic_vector(WIDTH - 1 downto 0) := (others => '0');
begin
	process(I_CLK)
	begin
		if (rising_edge(I_CLK)) then
			if (I_W = '1') then
				L_CONTENT <= I_D;
			elsif (I_INC = '1') then
				L_CONTENT <= L_CONTENT + ((WIDTH - 1 downto 1 => '0') & "1");
			end if;
		end if;
	end process;

	Q_D <= L_CONTENT;
end architecture RTL;
