LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
ENTITY UART_tb IS
END UART_tb;
 
ARCHITECTURE behavior OF UART_tb IS 
 
    COMPONENT UART
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         rx : IN  std_logic;
         rd : IN  std_logic;
         wr : IN  std_logic;
         w_data : IN  std_logic_vector(7 downto 0);
         tx : OUT  std_logic;
         rx_empty : OUT  std_logic;
         rx_full : OUT  std_logic;
         tx_full : OUT  std_logic;
         r_data : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;

   signal clk : std_logic := '0';
   signal reset : std_logic := '1';
   signal rx : std_logic := '0';
   signal rd : std_logic := '0';
   signal wr : std_logic := '0';
   signal w_data : std_logic_vector(7 downto 0) := (others => '0');

   signal tx : std_logic;
   signal rx_empty : std_logic;
   signal rx_full : std_logic;
   signal tx_full : std_logic;
   signal r_data : std_logic_vector(7 downto 0);

   constant clk_period : time := 12.5 ns;
	
	signal flag : std_logic := '0';
BEGIN
	-- Instantiate the Unit Under Test (UUT)
   uut: entity work.UART(behavior)
		GENERIC MAP(
			CLK_INPUT 	=> 40000000,
			BAUD_RATE	=> 9600,
			DATA_BITS	=> 8,	-- number of bits
			ADDR_BIT		=> 4	-- number of address bits
		)
		PORT MAP (
			clk => clk,
			reset => reset,
			rx => rx,
			rd => rd,
			wr => wr,
			w_data => w_data,
			tx => tx,
			rx_empty => rx_empty,
			rx_full => rx_full,
			tx_full => tx_full,
			r_data => r_data
		);

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
		reset 	<= '0';
   end process;
	
	rx <= tx;
   -- Stimulus process
   stim_proc: process
   begin
		wait for clk_period;
		flag		<= '1';
		wait for clk_period;
		flag 		<= '0';
		wait;
   end process;
	process(rx_empty , flag)
   begin
		if(rx_empty = '0')then
			w_data 	<= std_logic_vector(unsigned(r_data)+1);
			wr	<= '1' or flag;
			rd <= '1' or flag;
		else 
			rd <= '0' or flag;
			wr <= '0' or flag;
		end if;
   end process;
END;
