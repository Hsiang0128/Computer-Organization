LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
ENTITY main_tb IS
END main_tb;
 
ARCHITECTURE behavior OF main_tb IS 
 
    COMPONENT main
    PORT(
			clk		: IN  std_logic;
			reset		: IN  std_logic;
			rx			: IN  std_logic;
			tx			: out std_logic;
			clock		: OUT  std_logic_vector(7 downto 0)
			);
    END COMPONENT;

		signal clk : std_logic := '0';
		signal reset : std_logic := '1';
		signal rx : std_logic;
		signal tx : std_logic;
		signal clock : std_logic_vector(7 downto 0);

   constant clk_period : time := 25 ns;
	
	signal key : std_logic_vector(7 downto 0):= (others => '0');
	signal s_tick : std_logic;
	signal send: std_logic:='0';
BEGIN
	-- Instantiate the Unit Under Test (UUT)
   uut: entity work.main(behavior)
		GENERIC MAP(
			CLK_INPUT 	=> 40000000,
			BAUD_RATE	=> 19200
		)
		PORT MAP (
			clk => clk,
			reset => reset,
			rx => rx,
			tx => tx,
			clock => clock
		);
	
	uut_BaudRate_generator: entity work.BaudRate_generator(behavior)
		GENERIC MAP(
			CLK_INPUT 	=> 40000000,
			BAUD_RATE	=> 19200
		)
		PORT MAP(
			clk	=> clk,
			tick	=> s_tick
		);
	uut_transmitter: entity work.transmitter(behavior)
		PORT MAP(
			clk				=> clk,
			reset				=> reset,
			tx_start			=> send,
			s_tick			=> s_tick,
			din				=> key,
			tx					=> rx
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
	sim: process
   begin
		key <= "00000000";
		wait for 1 ms;
		key <= "01010010";--R
		send <= '1';
		wait for clk_period;
		send <= '0';
		wait for 1 ms;
		key <= "01100111";--g
		send <= '1';
		wait for clk_period;
		send <= '0';
		wait for 1 ms;
		key <= "00000000";
		wait for 4 ms;
		key <= "01110101";--u
		send <= '1';
		wait for clk_period;
		send <= '0';
		wait for 1 ms;
		key <= "00000000";
		wait for 1 ms;
		key <= "01010011";--S
		send <= '1';
		wait for clk_period;
		send <= '0';
		wait for 1 ms;
		key <= "00000000";
		wait for 2 ms;
		key <= "01000111";--G
		send <= '1';
		wait for clk_period;
		send <= '0';
		wait for 1 ms;
		key <= "00000000";
		wait for 1 ms;
		key <= "01110101";--U
		send <= '1';
		wait for clk_period;
		send <= '0';
		wait for 1 ms;
		key <= "00000000";
		wait for 1 ms;
		key <= "01110011";--s
		send <= '1';
		wait for clk_period;
		send <= '0';
		wait for 1 ms;
		key <= "01110010";--r
		send <= '1';
		wait for clk_period;
		send <= '0';
		wait;
   end process;
END;
