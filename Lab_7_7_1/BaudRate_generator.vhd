library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BaudRate_generator is
	generic(
		CLK_INPUT 	: integer :=40000000
	);
	port(
		clk		: in std_logic;
		bd_rate	: in std_logic_vector(1 downto 0);
		tick		: out std_logic
	);
end BaudRate_generator;
architecture behavior of BaudRate_generator is
	signal tmp : std_logic := '0';
	signal counter : integer := 0;
	signal BAUD_RATE : integer;
begin
	BAUD_RATE	<= 1200 when(bd_rate = "00")else
						2400 when(bd_rate = "01")else
						4800 when(bd_rate = "10")else
						9600;
	process(clk)begin
		if(clk = '1')then
			tick <= tmp;
			if(counter = (CLK_INPUT/BAUD_RATE)/2)then
				 tmp	<= not tmp;
				counter <= 0;
			else
				counter <= counter + 1; 
			end if;
		end if;
	end process;
end behavior;

