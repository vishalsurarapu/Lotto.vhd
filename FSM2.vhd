library ieee;
use ieee.std_logic_1164.all;
entity FSM is 
   port (   slv_player_input   : in    std_logic_vector(4 downto 0);
	 slv_winning_number_Mem    : in    std_logic_vector(4 downto 0); 
	 sl_reset                  : in    std_logic; 
    sl_CLK                    : in    std_logic;
    sl_value_is_equal : in std_logic; 
    sl_result                 : out   std_logic;
    sl_load_values: out std_logic;
    sl_won: out std_logic;
    sl_move_next: out std_logic); -- needs to be instatiated to key 0 in the mother entity for reset
end entity FSM;

architecture a_winning_FSM of e_winning_FSM is 

signal sl_Clock_int : std_logic ;  
signal sl_Resetn_int   : std_logic;
signal slv_Memref_int : std_logic_vector(4 downto 0); 
signal slv_Regref_int : std_logic_vector(4 downto 0); 
type t_fsm_states is (S_0, S_1, S_2, S_3, S_4, S_5, S_won, S_fail);
type t_fsm_states is (S_WAIT_START, S_LOOP_CONDITION, S_WAIT_FOR_READ, S_PROCESS_DATA, S_DONE);
signal fsm_state, fsm_nextstate : t_fsm_states;
   
begin 
 sl_Resetn_int <= sl_reset ;
 slv_Memref_int <= slv_winning_number_Mem;
 slv_Regref_int <= slv_player_input ; 
 sl_Clock_int <= sl_CLK;
 
 
 p_FSM_transitions: process (fsm_state, sl_start , sl_value_is_equal) -- state table
   begin
      case fsm_state IS
         when S_WAIT_START =>    
				if (sl_start = '1') then
					fsm_nextstate <= S_LOOP_CONDITION;
				else
					fsm_nextstate <= S_WAIT_START;
				end if;     
         when S_LOOP_CONDITION =>
				if (sl_left_gt_right  = '1') then -- change it to when index of last item equal to 5 in our case
					fsm_nextstate <= S_DONE;
				else
					fsm_nextstate <= S_WAIT_FOR_READ;
				end if;
				
         when S_WAIT_FOR_READ => fsm_nextstate <= S_PROCESS_DATA;
         
         when S_PROCESS_DATA =>
				if (sl_value_is_equal = '1') then
					fsm_nextstate <= S_DONE;
				else
					fsm_nextstate <= S_LOOP_CONDITION;
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
   
p_FSM_nextstate: process (sl_Clock_int)
   begin
      if  (rising_edge(sl_Clock_int)) then
         if (sl_Resetn_int = '0') then   -- synchronous clear
            fsm_state <= S_0;
         else
            fsm_state <= fsm_nextstate;
         end if;
      end if;
   end process p_FSM_nextstate;

   sl_load_values <= '1' when (fsm_state S_WAIT_START) and (sl_start = '0') else '0';
   sl_won <= '1' when (fsm_state = S_CHECK_NUMBER) and (sl_value_is_equal = '1') else '0'; -- when value from memory and also value from input is equal
   sl_move_next <= '1' when (fsm_state = S_CHECK_NUMBER);
   
end architecture a_winning_FSM;

 


