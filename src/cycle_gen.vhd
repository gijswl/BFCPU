library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity cycle_gen is
	port(
		I_CLK   : in  std_logic;
		I_INC   : in  std_logic;
		I_RST   : in  std_logic;
		Q_CYCLE : out std_logic_vector(2 downto 0)
	);
end entity cycle_gen;

architecture RTL of cycle_gen is
	signal L_CYCLE : std_logic_vector(2 downto 0) := "001";
begin
	process(I_CLK)
	begin
		if (rising_edge(I_CLK)) then
			if (I_RST = '1') then
				L_CYCLE <= "001";
			elsif (I_INC = '1') then
				case L_CYCLE is
					when "001" => L_CYCLE <= "010";
					when "010" => L_CYCLE <= "100";
					when others     => report "C2 overflowed" severity failure;
				end case;
			end if;
		end if;
	end process;

	Q_CYCLE <= L_CYCLE;
end architecture RTL;
