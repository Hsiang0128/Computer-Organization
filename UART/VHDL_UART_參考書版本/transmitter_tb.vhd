LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY transmitter_tb IS
END transmitter_tb;

ARCHITECTURE behavior OF transmitter_tb IS 
	COMPONENT transmitter 
	PORT(
		clk				: in std_logic;
		reset				: in std_logic;
		tx_start			: in std_logic;
		s_tick			: in std_logic;
		din				: in std_logic_vector ( 7 downto 0 );
		tx_done_tick	: out std_logic;
		tx					: out std_logic
	);
	END COMPONENT;
	
	signal clk				: std_logic := '0';
	signal reset			: std_logic := '1';
	signal tx_start		: std_logic := '0';
	signal s_tick			: std_logic := '0';
	signal din				: std_logic_vector ( 7 downto 0 ) := "10010110";
	signal tx_done_tick	: std_logic	;
	signal tx				: std_logic;
	
	constant clk_period		: time := 2 ns;
	constant s_tick_period	: time := 64 ns;
	
BEGIN
	uut: transmitter PORT MAP(
		clk				=> clk,
		reset				=> reset,
		tx_start			=> tx_start,
		s_tick			=> s_tick,
		din				=> din,
		tx_done_tick	=> tx_done_tick,
		tx					=> tx
	);
	
	generate_clk: process 
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;
	
	generate_s_tick: process 
	begin
		s_tick <= '0';
		wait for s_tick_period/2;
		s_tick <= '1';
		wait for s_tick_period/2;
	end process;
	
	stim_proc: PROCESS
	BEGIN
	
		reset <= '1';
		wait for 10ns;
		reset <= '0';
		wait for 10ns;
		tx_start <= '1';
		wait for 10ns;
		tx_start <= '0';
		wait;
	END PROCESS;
END behavior;
