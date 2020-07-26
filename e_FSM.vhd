library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity e_FSM is 
   port (
      sl_reset: in std_logic; 
      sl_clock: in std_logic;
      sl_start: in std_logic;
      slv_index_location: in std_logic_vector(2 downto 0);
      sl_value_is_equal: in std_logic;
      sl_load_values: out std_logic;
      sl_won: out std_logic;
      sl_move_next: out std_logic
   ); -- needs to be instatiated to key 0 in the mother entity for reset
end entity e_FSM;

architecture a_FSM of e_FSM is 
 
type t_fsm_states is (S_WAIT_START, S_LOOP_CONDITION, S_WAIT_FOR_READ, S_CHECK_NUMBER, S_FAIL , S_WON);
signal fsm_state, fsm_nextstate : t_fsm_states;
signal slv_situation : std_logic_vector(4 downto 0);

begin 
 
 p_FSM_transitions: process (fsm_state, sl_start , sl_value_is_equal , slv_index_location, slv_situation) -- state table
   begin
      case fsm_state is
         when S_WAIT_START =>    
            if (sl_start = '1' and (unsigned(slv_index_location) > 0)) then -- user started to edit first number
					fsm_nextstate <= S_LOOP_CONDITION;
				else -- it's still on index 0 which means user did not input a value
					fsm_nextstate <= S_WAIT_START;
				end if;     
         when S_LOOP_CONDITION => 
            if (unsigned(slv_index_location) > 5 ) then 
               if(unsigned(slv_situation) = 0) then
                  fsm_nextstate <= S_WON;
               else
                  fsm_nextstate <= S_FAIL;
               end if;
				else
               fsm_nextstate <= S_WAIT_FOR_READ;
				end if;
				
         when S_WAIT_FOR_READ => fsm_nextstate <= S_CHECK_NUMBER;
         
         when S_CHECK_NUMBER => --removed slv_situation because it was creating a latch
				if (sl_value_is_equal = '1') then
               fsm_nextstate <= S_LOOP_CONDITION;
               --slv_situation(to_integer(to_unsigned(4,3) - (unsigned(slv_index_location) - to_unsigned(1,3)))) <= '0' ;
            else
               fsm_nextstate <= S_LOOP_CONDITION;
               --slv_situation(to_integer(to_unsigned(4,3) - (unsigned(slv_index_location) - to_unsigned(1,3)))) <= '1' ;
				end if;
         when others => 
            if (sl_start = '1') then
               fsm_nextstate <= fsm_state;
            else    
               fsm_nextstate <= S_WAIT_START;
            end if;
      end case;
   end process p_FSM_transitions; -- state_table
   
p_FSM_nextstate: process (sl_clock, sl_reset)
   begin
      if  (rising_edge(sl_clock)) then
         if (sl_reset = '0') then   -- synchronous clear
            fsm_state <= S_WAIT_START;
         else
            fsm_state <= fsm_nextstate;
         end if;
      end if;
   end process p_FSM_nextstate;

   sl_load_values <= '1' when (fsm_state = S_WAIT_FOR_READ) else '0';
   -- sl_won <= '1' when (fsm_state = S_CHECK_NUMBER) and '0'; -- win codition still questionable based on signals ??
   sl_won <= '1' when (fsm_state = S_WON) else '0'; 
   slv_situation(to_integer(to_unsigned(3,3) - (unsigned(slv_index_location) - to_unsigned(1,3)))) <= '0' when sl_value_is_equal = '1' else '0';
   --sl_move_next <= '1' when (fsm_state = S_CHECK_NUMBER) and (unsigned(slv_index_location) < 5) else '0';

end architecture a_FSM;

 


