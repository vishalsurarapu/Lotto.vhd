library ieee;
use ieee.std_logic_1164.all;

entity e_flipflop is
   port ( sl_D, sl_Resetn, sl_Clock   : in   std_logic;
          sl_Q                 		  : out  std_logic);
end entity e_flipflop;
   
architecture a_flipflop of e_flipflop is


begin

   p_ff: process (sl_Clock)
   begin
      if (rising_edge(sl_Clock)) then
         if (sl_Resetn = '0') then
            sl_Q <= '0';
         else
            sl_Q <= sl_D;
         end if;
      end if;
   end process p_ff;
	
end architecture a_flipflop;