library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use ieee.std_logic_textio.all;

entity rom is
	generic(
		DATA_FILE : string;
		ADR_BITS : natural := 6;
		DATA_LEN : natural := 8
	);
	port(
		I_CLK : in  std_logic;
		I_ADR : in  std_logic_vector(ADR_BITS - 1 downto 0);
		Q_DAT : out std_logic_vector(DATA_LEN - 1 downto 0)
	);
end entity rom;

architecture RTL of rom is
	type rom_t is array (0 to (2**ADR_BITS - 1)) of std_logic_vector(DATA_LEN - 1 downto 0);
	signal rom : rom_t := (
		others => (others => '0')
	);

	file F_DATA : text open read_mode is DATA_FILE;
begin
	read_file : process(I_CLK)
		variable V_LINE : line;
		variable V_ADR  : natural := 0;
		variable V_DAT  : std_logic_vector(DATA_LEN - 1 downto 0);
		variable V_DONE : std_logic := '0';
	begin
		if (V_DONE = '0') then
			while not endfile(F_DATA) loop
				readline(F_DATA, V_LINE);
				hread(V_LINE, V_DAT);

				rom(V_ADR) <= V_DAT;
				V_ADR      := V_ADR + 1;
			end loop;
			file_close(F_DATA);
			V_DONE := '1';
			report "Read rom data file" severity note;
		end if;
	end process;

	Q_DAT <= rom(to_integer(unsigned(I_ADR)));
end architecture RTL;
