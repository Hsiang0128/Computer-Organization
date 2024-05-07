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
			CLK_INPUT	=> 500,
 			BAUD_RATE	=> 11
		)
		PORT MAP(
			clk => clk,
			tick => tick
		);
  tb : PROCESS
  BEGIN
	  clk <= '0';
	  wait for 1ns;
	  clk <= '1';
	  wait for 1ns;
  END PROCESS tb;
--  End Test Bench 

END behavior;
