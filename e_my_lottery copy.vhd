library ieee; 
use ieee.std_logic_1164.all; 
entity e_my_lotto is 
port( SW : in std_logic_vector (9 downto 0);
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

component FSM is 
   port (slv_player_input   : in    std_logic_vector(4 downto 0);
		slv_winning_number_Mem    : in    std_logic_vector(4 downto 0); 
		sl_reset                  : in    std_logic; 
		sl_CLK                    : in    std_logic;
		sl_value_is_equal : in std_logic; 
		sl_result                 : out   std_logic;
		sl_load_values: out std_logic;
		sl_won: out std_logic;
		sl_move_next: out std_logic
	); -- needs to be instatiated to key 0 in the mother entity for reset
end component FSM;

component e_memory_block is
	port ( address    : in  std_logic_vector (4 downto 0);
			clock      : in  std_logic ;
			data       : in  std_logic_vector (7 downto 0);
			wren       : in  std_logic ;
			q          : out std_logic_vector (7 downto 0) );
end component;


signal slv_data_from_memory_int: std_logic_vector(4 downto 0);
signal slv_address_int: std_logic_vector(4 downto 0);




begin 
	I_MEM: e_memory_block port map(
		address => slv_address_int,
		data => "00000000",
		clock => CLOCK_50,
		wren => '0',
		q => slv_data_from_memory_int);


   p_welcome: process (sl_Clock_int, slv_input_signal)-- this process calls the components to disply input entering 
   begin
   -- call the welcome component outside the clock 
      
   end process p_shiftregFSM;
