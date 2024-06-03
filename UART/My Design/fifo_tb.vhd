LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fifo_tb IS
END fifo_tb;
 
ARCHITECTURE behavior OF fifo_tb IS 
	COMPONENT fifo
	PORT(
		clk : IN  std_logic;
		reset : IN  std_logic;
		rd : IN  std_logic;
		wr : IN  std_logic;
		w_data : IN  std_logic_vector(7 downto 0);
		empty : OUT  std_logic;
		full : OUT  std_logic;
		r_data : OUT  std_logic_vector(7 downto 0)
	  );
	END COMPONENT;

	signal clk		: std_logic	:= '0';
	signal reset	: std_logic	:= '1';
	signal rd		: std_logic	:= '0';
	signal wr		: std_logic	:= '0';
	signal w_data	: std_logic_vector(7 downto 0) := (others => '0');
	
	signal empty : std_logic;
	signal full : std_logic;
	signal r_data : std_logic_vector(7 downto 0);
 
BEGIN
   uut: entity work.fifo(behavior)
		GENERIC MAP(
			B => 8,
			W => 2
		)
		PORT MAP (
			clk => clk,
			reset => reset,
			rd => rd,
			wr => wr,
			w_data => w_data,
			empty => empty,
			full => full,
			r_data => r_data
		);
   stim_proc: process
   begin
		clk <= '0';
      wait for 10 ns;
		clk <= '1';
      wait for 10 ns;
		clk <= '0';
		reset <= '0';
		wr		 <= '1';
		w_data <= "00000001";
      wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		w_data <= "00000010";
      wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		w_data <= "00000100";
      wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		w_data <= "00001000";
      wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wr	<= '0';
		rd <= '1';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
      wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
      wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
      wait for 10 ns;
		clk <= '1';
		
      wait;
   end process;

END;
