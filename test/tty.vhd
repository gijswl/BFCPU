library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.constants.all;

entity tty is
	port(
		I_CLK : in std_logic;
		I_W   : in std_logic;
		I_DAT : in std_logic_vector(XLEN - 1 downto 0)
	);
end entity tty;

architecture RTL of tty is

begin
	process(I_CLK)
	begin
		if (falling_edge(I_CLK)) then
			if (I_W = '1') then
				report character'image(CONV_CHAR(I_DAT)) severity note;
			end if;
		end if;
	end process;
end architecture RTL;
