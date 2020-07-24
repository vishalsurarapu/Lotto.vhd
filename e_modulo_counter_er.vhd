library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity e_modulo_counter_er is
	generic( n: natural := 4; k: integer := 15);
	port (	sl_clock, sl_reset_n:	in		std_logic;
			sl_enable:				in		std_logic;
			slv_Q:					out		std_logic_vector(n-1 downto 0);
			sl_rollover:			out		std_logic
	);
end entity e_modulo_counter_er;

architecture a_modulo_counter_er of e_modulo_counter_er is

-- Declarations:

-- Signal Declarations:
	signal slv_counter_int:		std_logic_vector(n-1 downto 0);

begin

-- Assignments:

-- Concurrent Assignments:
	slv_Q <= slv_counter_int;
	
-- Conditional Signal Assignments:
	sl_rollover <= '1' when (slv_counter_int = k-1) else '0';

-- Sequential process with async. low-active reset:
	p_mod_cnt: process(sl_clock, sl_reset_n)
	begin
		if(sl_reset_n = '0') then
			slv_counter_int <= (others => '0');
		elsif(rising_edge(sl_clock)) then
			if(sl_enable = '1') then
				if(slv_counter_int = k-1) then
					slv_counter_int <= (others => '0');
				else
					slv_counter_int <= slv_counter_int + 1;
				end if;
			end if;
		end if;
	end process p_mod_cnt;

end architecture a_modulo_counter_er;
