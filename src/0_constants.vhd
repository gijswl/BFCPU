library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library work;

package constants is
	function CONV_CHAR(SLV8 : std_logic_vector (7 downto 0)) return CHARACTER; -- Utility function for TTY
	function MAX(LEFT, RIGHT: NATURAL) return NATURAL;

	constant CLOCK_PERIOD : time := 20 ns;

	constant DP_LEN   : natural := 15;
	constant CELL_LEN : natural := 8;
	constant ADR_LEN  : natural := 15;
	constant ALU_LEN  : natural := MAX(CELL_LEN, DP_LEN);
	
	constant CS_ALUTSRC : std_logic_vector(0 downto 0) := (others => 'X'); -- ALUT source; 0: DP, 1: MEM[DP]
	constant CS_ADRSRC  : std_logic_vector(1 downto 1) := (others => 'X'); -- ADR source; 0: DP, 1: IP
	constant CS_ALUOP   : std_logic_vector(2 downto 2) := (others => 'X'); -- ALU operation; 0: increment, 1: subtract
	constant CS_DPW     : std_logic_vector(3 downto 3) := (others => 'X'); -- DP write
	constant CS_MEMW    : std_logic_vector(4 downto 4) := (others => 'X'); -- MEM write
	constant CS_ALUTW   : std_logic_vector(5 downto 5) := (others => 'X'); -- ALUT write
	constant CS_ALURW   : std_logic_vector(6 downto 6) := (others => 'X'); -- ALUR write
	constant CS_IRW	    : std_logic_vector(7 downto 7) := (others => 'X'); -- IR write
	constant CS_IPINC   : std_logic_vector(8 downto 8) := (others => 'X'); -- IP increment
	constant CS_LEN     : natural := 9;
end package constants;

package body constants is
	function CONV_CHAR(SLV8 : std_logic_vector (7 downto 0)) return CHARACTER is
		constant XMAP : INTEGER := 0;
		variable TEMP : INTEGER := 0;
	begin
		for i in SLV8'range loop
			TEMP := TEMP*2;
			case SLV8(i) is
				when '0' | 'L' => null;
				when '1' | 'H' => TEMP := TEMP + 1;
				when others    => TEMP := TEMP + XMAP;
			end case;
		end loop;
		return CHARACTER'VAL(TEMP);
	end CONV_CHAR;
	
	function MAX(LEFT, RIGHT: NATURAL) return NATURAL is
	begin
  		if LEFT > RIGHT then return LEFT;
  		else return RIGHT;
    		end if;
  	end;
end package body constants;
