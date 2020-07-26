--slv_index_int is the digit highlighted in lottery number (0-4: index, 5: input complete)
--lotteryinput is the number displayed in the digit  --- should be passed on to the HEX display
--slv_lotteryinput_int is the number counter 0-10 -> 0000-1001:to display numbers -->1010:to display a '-'

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
	port (	slv_SW   : in  std_logic_vector(4 downto 0);
			slv_lotteryinput : out std_logic_vector(3 downto 0);
			slv_index : out std_logic_vector(2 downto 0);
			slv_whole_lotteryinput: out std_logic_vector(0 to 19);
			sl_start : in std_logic;
			sl_resetn : in std_logic;
			sl_clock : in std_logic );

end entity e_manualinput;

architecture a_manualinput of e_manualinput is

	signal slv_lotteryinput_int : std_logic_vector(3 downto 0) ;
	signal slv_index_int : std_logic_vector(2 downto 0) ;
	signal slv_whole_lotteryinput_int : std_logic_vector(0 to 19);

begin

	p_manualinput: process(slv_SW, sl_start, sl_resetn, sl_clock)
	
	begin
		if(sl_resetn ='0') then
            --reset all vauels to initials
            slv_whole_lotteryinput_int <= "10101010101010101010";
            slv_index_int <= "000";
            slv_lotteryinput_int <=  "1010";
        elsif (rising_edge(sl_clock)) then
			
			if (sl_start = '1') then

				if slv_SW(0) = '1' then -- switch up: raise detection
					if slv_index_int = "000" then slv_index_int <= "001"; end if;
					if slv_lotteryinput_int = "1010" 		then					slv_lotteryinput_int <= "0000";
					elsif( slv_lotteryinput_int = "1001") 	then					slv_lotteryinput_int <= "0000";
					else			
						slv_lotteryinput_int <= std_logic_vector(unsigned(slv_lotteryinput_int) + 1);
						--if((slv_index_int /= "000") and (slv_index_int /= "110")) then slv_whole_lotteryinput_int(unsigned(slv_index_int)) <= unsigned(slv_lotteryinput_int); end if;
						--slv_whole_lotteryinput_int(slv_index_int) <= slv_lotteryinput_int when ((unsigned(slv_index_int) > 0) and (unsigned(slv_index_int) < 6)) else "1010";
					end if;
					case slv_index_int is
						when "001" => slv_whole_lotteryinput_int(0 to 3) <= slv_lotteryinput_int;
						when "010" => slv_whole_lotteryinput_int(4 to 7) <= slv_lotteryinput_int;
						when "011" => slv_whole_lotteryinput_int(8 to 11) <= slv_lotteryinput_int;
						when "100" => slv_whole_lotteryinput_int(12 to 15) <= slv_lotteryinput_int;
						when "101" => slv_whole_lotteryinput_int(16 to 19) <= slv_lotteryinput_int;
						when others => slv_whole_lotteryinput_int <= slv_whole_lotteryinput_int;
					end case;
				elsif slv_SW(0) = '0' then 
					slv_whole_lotteryinput_int <= "10101010101010101010";
					
				end if;

				if slv_SW(1) = '1' then -- switch down: raise detection
					if slv_index_int = "000" then slv_index_int <= "001"; end if;
					
					if(slv_lotteryinput_int = "1010") 		then			slv_lotteryinput_int <= "1001";
					elsif( slv_lotteryinput_int = "0000")	then			slv_lotteryinput_int <= "1001";
					else		
						slv_lotteryinput_int <= std_logic_vector(unsigned(slv_lotteryinput_int) - 1);
						--if((slv_index_in /= "000") and (slv_index_int /= "110")) then slv_whole_lotteryinput_int(unsigned(slv_index_int)) <= unsigned(slv_lotteryinput_int); end if;
						--slv_whole_lotteryinput_int(slv_index_int) <= slv_lotteryinput_int when ((unsigned(slv_index_int) > 0) and (unsigned(slv_index_int)) < 6) else "1010";
					end if;
					case slv_index_int is
						when "001" => slv_whole_lotteryinput_int(0 to 3) <= slv_lotteryinput_int;
						when "010" => slv_whole_lotteryinput_int(4 to 7) <= slv_lotteryinput_int;
						when "011" => slv_whole_lotteryinput_int(8 to 11) <= slv_lotteryinput_int;
						when "100" => slv_whole_lotteryinput_int(12 to 15) <= slv_lotteryinput_int;
						when "101" => slv_whole_lotteryinput_int(16 to 19) <= slv_lotteryinput_int;
						when others => slv_whole_lotteryinput_int <= slv_whole_lotteryinput_int;
					end case;
					
				end if;

				if slv_SW(2) = '1' then -- switch right: raise detection
					if slv_index_int = "000" then slv_index_int <= "001"; end if;
					
					if(slv_index_int = "101") 	then	slv_index_int <= "001";
					else			slv_index_int <= std_logic_vector(unsigned(slv_index_int ) + 1);
					end if;

				end if;

				if slv_SW(3) = '1' then -- switch left: raise detection
					if slv_index_int = "000" then slv_index_int <= "001"; end if;  --jumps to index 5
				
					if(slv_index_int = "001") 	then	slv_index_int <= "101"; 
					else			slv_index_int <= std_logic_vector(unsigned(slv_index_int ) - 1);
					end if;
				end if;

				if slv_SW(4) = '1' then -- enter
					if slv_index_int = "000" then 
						slv_index_int <= "001"; 
					else
						slv_index_int <= "110"; --To let know that the input is complete
					end if;
				end if;
						
			else
				slv_whole_lotteryinput_int <= "10101010101010101010";	
				slv_index_int <= "000";
				slv_lotteryinput_int <= "1010";
			end if;	
		end if;
		slv_lotteryinput <= slv_lotteryinput_int;
		slv_index	 <= slv_index_int ;
		slv_whole_lotteryinput <= slv_whole_lotteryinput_int;
		
	end process p_manualinput;
end architecture a_manualinput;
	
