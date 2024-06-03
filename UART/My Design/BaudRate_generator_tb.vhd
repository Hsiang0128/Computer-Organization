LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY BaudRate_generator_tb IS
END BaudRate_generator_tb;

ARCHITECTURE behavior OF BaudRate_generator_tb IS

	COMPONENT BaudRate_generator
	port(
		clk	: in std_logic;
		tick	: out std_logic
	);
	END COMPONENT;

	SIGNAL clk	: std_logic;
	SIGNAL tick	: std_logic;
BEGIN
	uut: entity work.BaudRate_generator(behavior)

		GENERIC MAP(
			CLK_INPUT	=> 50000000,
 			BAUD_RATE	=> 19200
		)
		PORT MAP(
			clk => clk,
			tick => tick
		);
  tb : PROCESS
  BEGIN
	  clk <= '0';
	  wait for 12.5 ps;
	  clk <= '1';
	  wait for 12.5 ps;
  END PROCESS tb;
--  End Test Bench 

END behavior;
