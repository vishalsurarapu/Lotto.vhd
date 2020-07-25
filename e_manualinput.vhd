--slv_index_int is the digit highlighted in lottery number (0-4: index, 5: input complete)
--lotteryinput is the number displayed in the digit  --- should be passed on to the HEX display
--slv_lotteryinput is the number counter 0-10 -> 0000-1001:to display numbers -->1010:to display a '-'

--Switches 0-4 are used to edit input number :up, down, left, right and enter respectively.
--switch(0)--up switch: every raise in the switch cause this sequence -> "-01234567890123..."
--switch(1)--down switch: every raise in the switch cause this sequence -> "-9876543210987..."
--switch(2) & switch(2)-- left and right swithces: every raise in the switch cause the change in index number by one position
--switch(3)-- enter switch: sets index to 5: states input procedure complete


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use ieee.numeric_std.all;

entity e_manualinput is
	port (	slv_SW   : in  std_logic_vector(9 downto 0);
			slv_playerinput : out std_logic_vector(3 downto 0);
			slv_index : out std_logic_vector(2 downto 0) );

end entity e_manualinput;

architecture a_manualinput of e_manualinput is

	signal slv_lotteryinput : std_logic_vector(3 downto 0) ;
	signal slv_index_int : std_logic_vector(2 downto 0) ;

begin
	-- set slv_index_int
	
	p_manualinput: process(slv_SW, slv_lotteryinput,slv_index_int)
	
	begin
		
		slv_index_int <= "001";
		slv_lotteryinput <=  "1010";
			-- set non slv_index_inted values arbitrarily

			if slv_SW(0) = '1' then -- switch up: raise detection

				if slv_lotteryinput = "1010" 		then					slv_lotteryinput <= "0000";
				elsif( slv_lotteryinput = "1001") 	then					slv_lotteryinput <= "0000";
				else			slv_lotteryinput <= std_logic_vector(unsigned(slv_lotteryinput) + 1);
				end if;
				
			end if;

			if slv_SW(1) = '1' then -- switch down: raise detection
				
				if(slv_lotteryinput = "1010") 		then			slv_lotteryinput <= "1001";
				elsif( slv_lotteryinput = "0000")	then			slv_lotteryinput <= "1001";
				else		slv_lotteryinput <= std_logic_vector(unsigned(slv_lotteryinput) - 1);
				end if;
				
			end if;

			if slv_SW(2) = '1' then -- switch right: raise detection
				
				if(slv_index_int = "101") 	then	slv_index_int <= "001";
				else			slv_index_int <= std_logic_vector(unsigned(slv_index_int ) + 1);
				end if;

			end if;

			if slv_SW(3) = '1' then -- switch left: raise detection
			
				if(slv_index_int = "001") 	then	slv_index_int <= "101";
				else			slv_index_int <= std_logic_vector(unsigned(slv_index_int ) - 1);
				end if;
			end if;

			if slv_SW(4) = '1' then -- enter
				slv_index_int <= "110"; --To let know that the input is complete
			end if;
				    
					 
		slv_playerinput <= slv_lotteryinput;
		slv_index	 <= slv_index_int ;
		
	end process p_manualinput;
end architecture a_manualinput;
	
