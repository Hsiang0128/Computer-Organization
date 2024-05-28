LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.NUMERIC_STD.ALL;
 
ENTITY UART_err_tb IS
END UART_err_tb;
 
ARCHITECTURE behavior OF UART_err_tb IS 
 
    COMPONENT UART
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         rx : IN  std_logic;
         rd : IN  std_logic;
         wr : IN  std_logic;
         w_data : IN  std_logic_vector(7 downto 0);
			
			dnum		: in std_logic;
			snum		: in std_logic;
			par		: in std_logic_vector(1 downto 0);
			bd_rate	: in std_logic_vector(1 downto 0);
			
         tx : OUT  std_logic;
         rx_empty : OUT  std_logic;
         rx_full : OUT  std_logic;
         tx_full : OUT  std_logic;
			
			err		: out std_logic_vector(2 downto 0);
			
         r_data : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;

   signal clk : std_logic := '0';
   signal reset : std_logic := '1';
   signal rx : std_logic;
   signal rd : std_logic := '0';
   signal wr : std_logic := '0';
   signal w_data : std_logic_vector(7 downto 0) := (others => '0');

   signal tx : std_logic;
   signal rx_empty : std_logic;
   signal rx_full : std_logic;
   signal tx_full : std_logic;
   signal r_data : std_logic_vector(7 downto 0);
	
	signal dnum		:std_logic:= '1';
	signal snum		:std_logic:= '0';
	signal par		:std_logic_vector(1 downto 0):= "00";
	signal bd_rate	: std_logic_vector(1 downto 0):= "11";
	
	signal err : std_logic_vector(2 downto 0);

   constant clk_period : time := 25 ns;
	
	signal s_tick	: std_logic;
	signal send		: std_logic:='0';
	signal send_data :std_logic_vector(7 downto 0):= (others => '0');
	signal send_dnum		:std_logic:= '0';
	signal send_snum		:std_logic:= '0';
	signal send_par		:std_logic_vector(1 downto 0):= "00";
	
BEGIN
	-- Instantiate the Unit Under Test (UUT)
   uut: entity work.UART(behavior)
		GENERIC MAP(
			CLK_INPUT 	=> 40000000,
			DATA_BITS	=> 8,	-- number of bits
			ADDR_BIT		=> 1
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
			r_data => r_data,
			dnum => dnum,
			snum => snum,
			par => par,
			err => err,
			bd_rate => bd_rate
		);
	uut_BaudRate_generator: entity work.BaudRate_generator(behavior)
		GENERIC MAP(
			CLK_INPUT 	=> 40000000
		)
		PORT MAP(
			clk		=> clk,
			bd_rate	=> bd_rate,
			tick		=> s_tick
		);
	uut_transmitter: entity work.transmitter(behavior)
		GENERIC MAP(
			DBIT		=> 8
		)
		PORT MAP(
			clk				=> clk,
			reset				=> reset,
			tx_start			=> send,
			s_tick			=> s_tick,
			din				=> send_data,
			tx					=> rx,
			dnum => send_dnum,
			snum => send_snum,
			par => send_par
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
	
   -- Stimulus process
   stim_proc: process
   begin
		wait for 0.2 ms;
			send_dnum<= '1';
			send_snum<= '0';
			send_par	<= "00";
			send_data<="00111111";
			send <= '1';
		wait for clk_period;
			send <= '0';
		wait for 1 ms;
   end process;
END;
