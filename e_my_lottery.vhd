library ieee; 
use ieee.std_logic_1164.all; 
entity e_my_lotto is 
port(   CLOCK_50 :in std_logic; 
	SW : in std_logic_vector (9 downto 0);
	KEY: in std_logic_vector(3 downto 0); 
	LEDR: out std_logic_vector(9 downto 0); 
	HEX0:		out				std_logic_vector(0 to 6);
	HEX1:		out				std_logic_vector(0 to 6);
	HEX2:		out				std_logic_vector(0 to 6);
	HEX3:		out				std_logic_vector(0 to 6);
	HEX4:		out				std_logic_vector(0 to 6);
	HEX5:		out				std_logic_vector(0 to 6)
);
end entity e_my_lotto; 

architecture a_my_lotto of e_my_lotto is 
-- all signal assignments and component assignments 
-- declare the process signals and vriables slv_input_number

component e_winning_FSM is 
   port (   slv_input_number   : in    std_logic_vector(4 downto 0);
            KEY_signal         : in    std_logic_vector(3 downto 0);
            LEDR_Sginal        : out   std_logic_vector(9 downto 0));  
end component e_winning_FSM;

component e_modulo_counter_er is
	generic( n: natural := 4; k: integer := 15);
	port (	        sl_clock, sl_reset_n:	in std_logic;
			sl_enable:  in	std_logic;
			slv_Q:	    out     std_logic_vector(n-1 downto 0);
			sl_rollover: out std_logic );
end component e_modulo_counter_er;







begin 
   p_welcome: process (sl_Clock_int, slv_input_signal)-- this process calls the components to disply input entering 
   begin
   -- call the welcome component outside the clock 
      
	    if  (rising_edge(sl_Clock_int)) then
	  
            
        
      end if;
   end process p_shiftregFSM;
