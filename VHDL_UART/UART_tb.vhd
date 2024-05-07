LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
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

   constant clk_period : time := 200 ps;
	
	signal flag : std_logic := '0';
BEGIN
	-- Instantiate the Unit Under Test (UUT)
   uut: entity work.UART(behavior)
		GENERIC MAP(
			CLK_INPUT 	=> 7372800,
			BAUD_RATE	=> 115200,
			DATA_BITS	=> 8,	-- number of bits
			ADDR_BIT		=> 4,	-- number of address bits
			SB_TICK		=> 16
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
	
		wait for 200 ps;
		w_data 	<= r_data(6 downto 0)&(not w_data(7));
		rd			<= '1';
		wr			<= '1';
		wait for 200 ps;
		rd			<= '0';
		wr 		<= '0';
		delay: for i in 0 to (7372800/115200)*6 loop
			wait for 200 ps;
		end loop;
   end process;

END;
