--slv_index is the digit highlighted in lottery number (0-4: index, 5: input complete)
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

entity e_manualinput is
	port (	slv_SW   : in  std_logic_vector(9 downto 0);
			slv_playerinput : out std_logic_vector(0 to 4);
			slv_index : out std_logic_vector (0 to 4) );

end entity e_manualinput;

architecture a_manualinput of e_manualinput is

	constant n: positive := 5;
	
	type t_lotterynumber is array (3 downto 0) of std_logic_vector; --(xxxx)
	type lotteryinput is array (0 to 4) of t_lotterynumber; --(xxxx xxxx xxxx xxxx xxxx)
		
	--variable v_lotteryinput: lotteryinput;
	
	signal slv_lotteryinput : lotteryinput ;
	signal slv_index : natural range 0 to n-1;

begin
	-- set slv_index
	slv_index <= 0;
	slv_lotteryinput <= ("1010","1010","1010","1010","1010");
	
	p_manualinput: process(slv_SW, slv_lotteryinput)

		begin
			-- set non slv_indexed values arbitrarily

			--  if i = slv_index then
			if slv_SW(0) = '1' then -- up

				if(slv_lotteryinput(slv_index) = "1010") 		then					slv_lotteryinput(slv_index) <= "0000";
				elsif( slv_lotteryinput(slv_index) = "1001") 	then					slv_lotteryinput(slv_index) <= "0000";
				else				slv_lotteryinput(slv_index) <= std_logic_vector(unsigned(slv_lotteryinput(slv_index)) + 1);
				end if;
				
			end if;

			if slv_SW(1) = '1' then -- down
				
				if(slv_lotteryinput(slv_index) = "1010") 		then			slv_lotteryinput(slv_index) <= "1001";
				elsif( slv_lotteryinput(slv_index) = "0000")	then			slv_lotteryinput(slv_index) <= "1001";
				else		slv_lotteryinput(slv_index) <= std_logic_vector(unsigned(slv_lotteryinput(slv_index)) - 1);
				end if;
				

			end if;

			if slv_SW(2) = '1' then -- right
				
				if(slv_index = 4) 	then	slv_index <= 0;
				else			slv_index <= slv_index + 1;
				end if;

			end if;

			if slv_SW(3) = '1' then -- left
			
				if(slv_index = 0) 	then	slv_index <= 4;
				else			slv_index <= slv_index - 1;
				end if;
			end if;

			if slv_SW(4) = '1' then -- enter
				slv_index <= 5; --To let know that the input is complete
			end if;
				    
	end process p_manualinput;
	slv_lotteryinput <= slv_playerinput;
end architecture a_manualinput;
	
