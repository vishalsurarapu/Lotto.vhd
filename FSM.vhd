library ieee;
use ieee.std_logic_1164.all;
entity e_winning_FSM is 
   port (   slv_player_input   : in    std_logic_vector(4 downto 0);
	 slv_winning_number_Mem    : in    std_logic_vector(4 downto 0); 
	 sl_reset                  : in    std_logic; 
	 sl_CLK                    : in    std_logic; 
	 sl_result                 : out   std_logic ); -- needs to be instatiated to key 0 in the mother entity for reset
	 
end entity e_winning_FSM;

architecture a_winning_FSM of e_winning_FSM is 

signal sl_Clock_int : std_logic ;  
signal sl_Resetn_int   : std_logic;
signal slv_Memref_int : std_logic_vector(4 downto 0); 
signal slv_Regref_int : std_logic_vector(4 downto 0); 
type t_fsm_states is (S_0, S_1, S_2, S_3, S_4, S_5, S_won, S_fail);
signal fsm_state, fsm_nextstate : t_fsm_states;
   
begin 
;
 sl_Resetn_int <= sl_reset ;
 slv_Memref_int <= slv_winning_number_Mem;
 slv_Regref_int <= slv_player_input ; 
 sl_Clock_int <= sl_CLK;
 
 
 p_FSM_transitions: process (slv_Memref_int, fsm_state, slv_Regref_int) -- state table
   begin
      case fsm_state is
         when S_0 =>	if (slv_Memref_int[0] = slv_Regref_int[0]) then -- comparison between numbers indexed with i between 0 to 4 in both of memory and register 
								fsm_nextstate <= S_1;
							else 
								fsm_nextstate <= S_fail;
                     end if;
         when S_1 =>	if (sl_Memref_int[1] = slv_Regref_int[1]) then
								fsm_nextstate <= S_2; 
                     else
								fsm_nextstate <= S_fail;
                     end if;
         when S_2 =>	if (sl_Memref_int[2] = slv_Regref_int[2]) then
								fsm_nextstate <= S_3; 
                     else
								fsm_nextstate <= S_fail;
                     end if;
         when S_3 =>	if (sl_Memref_int[3] = slv_Regref_int[3]) then
								fsm_nextstate <= S_4; 
                     else
								fsm_nextstate <= S_fail;
								
                     end if;
         when S_4 =>	if (sl_Memref_int[4] = slv_Regref_int[4]) then
								fsm_nextstate <= S_5;
                                sl_result <= '1';								
                     else
								fsm_nextstate <= S_fail;
							
                     end if;
         when S_5 =>	
								fsm_nextstate <= S_won; -- not neccessary just define the winning acion 
                     
when S_fail =>	
sl_result <= '0';
       
                  
         when others   => fsm_nextstate <= S_fail;
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

 


