library ieee;
use ieee.std_logic_1164.all;
entity FSM is 
   port (
    sl_reset                  : in    std_logic; 
	 sl_start                  : in    std_logic; 
    sl_clock                  : in    std_logic;
    slv_index_location: in std_logic_vector(2 downto 0);
    sl_value_is_equal : in std_logic;
    sl_load_values: out std_logic;
    sl_won: out std_logic;
    sl_move_next: out std_logic
    ); -- needs to be instatiated to key 0 in the mother entity for reset
end entity FSM;

architecture a_winning_FSM of e_winning_FSM is 
 
signal sl_reset   : std_logic;

type t_fsm_states is (S_WAIT_START, S_LOOP_CONDITION, S_WAIT_FOR_READ, S_CHECK_NUMBER, S_DONE);
signal fsm_state, fsm_nextstate : t_fsm_states;
   
begin 
 
 p_FSM_transitions: process (fsm_state, sl_start , sl_value_is_equal) -- state table
   begin
      case fsm_state IS
         when S_WAIT_START =>    
				if (sl_start = '1') then -- wait for program to be started
					fsm_nextstate <= S_LOOP_CONDITION;
				else
					fsm_nextstate <= S_WAIT_START;
				end if;     
         when S_LOOP_CONDITION => -- program started and we checking for going for done which is finished or wait for another read
				if (unsigned(slv_index_location) > 4) then -- change it to when index of last item equal to 5 in our case
					fsm_nextstate <= S_DONE;
				else
					fsm_nextstate <= S_WAIT_FOR_READ;
				end if;
				
         when S_WAIT_FOR_READ => fsm_nextstate <= S_CHECK_NUMBER;
         
         when S_CHECK_NUMBER => -- with every input we check to need another input or going to done state
				if (sl_value_is_equal = '1') then
					fsm_nextstate <= S_LOOP_CONDITION;
				else
					fsm_nextstate <= S_DONE;
				end if;
				
         when S_DONE =>
				if (sl_start = '1') then
					fsm_nextstate <= S_DONE;
				else
					fsm_nextstate <= S_WAIT_START;
				end if;
                     
         when others => fsm_nextstate <= S_WAIT_START;
      end case;
   end process p_FSM_transitions; -- state_table
   
p_FSM_nextstate: process (sl_clock)
   begin
      if  (rising_edge(sl_clock)) then
         if (sl_reset = '0') then   -- synchronous clear
            fsm_state <= S_WAIT_START;
         else
            fsm_state <= fsm_nextstate;
         end if;
      end if;
   end process p_FSM_nextstate;

   sl_load_values <= '1' when (fsm_state S_WAIT_START) and (sl_start = '0') else '0';
   sl_won <= '1' when (fsm_state = S_CHECK_NUMBER) and 0; -- win codition still questionable based on signals ??
   sl_move_next <= '1' when (fsm_state = S_CHECK_NUMBER) and (unsigned(slv_index_location) < 5) else '0';

end architecture a_winning_FSM;

 


