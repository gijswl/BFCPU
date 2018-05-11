library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
	generic(
		ADR_BITS : natural := 7;
		DATA_LEN : natural := 8
	);
	port(
		I_CLK : in  std_logic;
		I_RW  : in  std_logic;
		I_ADR : in  std_logic_vector(ADR_BITS - 1 downto 0);
		I_DAT : in  std_logic_vector(DATA_LEN - 1 downto 0);
		Q_DAT : out std_logic_vector(DATA_LEN - 1 downto 0)
	);
end entity ram;

architecture RTL of ram is
	type ram_t is array (0 to (2**ADR_BITS - 1)) of std_logic_vector(DATA_LEN - 1 downto 0);
	signal ram : ram_t := (
		others => (others => '0')
	);
begin
	Q_DAT <= ram(to_integer(unsigned(I_ADR)));

	process(I_CLK)
	begin
		if (falling_edge(I_CLK)) then
			if (I_RW = '1') then
				ram(to_integer(unsigned(I_ADR))) <= I_DAT;
			end if;
		end if;
	end process;
end architecture RTL;
