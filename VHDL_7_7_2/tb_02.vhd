LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Auto_BaudRate_tb IS
END Auto_BaudRate_tb;

ARCHITECTURE behavior OF Auto_BaudRate_tb IS

    COMPONENT Auto_BaudRate
        PORT(
            clk           : in std_logic;
            tx_auto       : in std_logic;
            reset 		  : in std_logic;
        	test,check_flag,ok_flag	: out std_logic;
			BAUD_RATE_auto,test_count		: out std_logic_vector(64 downto 0)
        );
    END COMPONENT;

    SIGNAL clk,test,reset,check_flag,ok_flag          : std_logic := '0';
    SIGNAL BAUD_RATE_auto,test_count : std_logic_vector(64 downto 0) := (others => '0');
    SIGNAL tx_auto      : std_logic := '1';
    constant test_baud1  : time := 	 208333 ns;--4800
    constant test_baud2  : time := 	 104166 ns;--9600
    constant test_baud3  : time :=   52083  ns;--19200
    constant clk_time  : time := 25 ns;
    SIGNAL end_flag     : std_logic := '0';

BEGIN
    uut: entity work.Auto_BaudRate
      	generic map(
            CLK_INPUT => 40000000 --400K
        )
        PORT MAP(
            clk           	=>	clk,
            BAUD_RATE_auto 	=>	BAUD_RATE_auto,
            tx_auto       	=>	tx_auto,
            test 			=> test,
            reset			=> reset,
            ok_flag			=> ok_flag,
            check_flag		=> check_flag
        );

   clk_process :process
   begin
		clk <= '0';
		wait for 12500 ps;
		clk <= '1';
		wait for 12500 ps;
        if (end_flag='1')then wait;
        end if;
   end process;

    data : PROCESS
    BEGIN
    	wait for 2*test_baud1 ;
        tx_auto <= '0'; -- start bit
        wait for test_baud1;

        tx_auto <= '1'; -- bit 1
        wait for test_baud1;
        tx_auto <= '1'; -- bit 2
        wait for test_baud1;
        tx_auto <= '1'; -- bit 3
        wait for test_baud1;
        tx_auto <= '1'; -- bit 4
        wait for test_baud1;
        tx_auto <= '1'; -- bit 5
        wait for test_baud1;
        tx_auto <= '1'; -- bit 6
        wait for test_baud1;
        tx_auto <= '1'; -- bit 7
        wait for test_baud1;
        tx_auto <= '0'; -- bit 8
        wait for test_baud1;
        tx_auto <= '1'; -- stop bit

        
        wait for 2*test_baud2 ;
        reset <= '1';
        wait for 2*test_baud2 ;
        reset <= '0';
        wait for 2*test_baud2 ;
        tx_auto <= '0'; -- start bit
        wait for test_baud2;

        tx_auto <= '1'; -- bit 1
        wait for test_baud2;
        tx_auto <= '1'; -- bit 2
        wait for test_baud2;
        tx_auto <= '1'; -- bit 3
        wait for test_baud2;
        tx_auto <= '1'; -- bit 4
        wait for test_baud2;
        tx_auto <= '1'; -- bit 5
        wait for test_baud2;
        tx_auto <= '1'; -- bit 6
        wait for test_baud2;
        tx_auto <= '1'; -- bit 7
        wait for test_baud2;
        tx_auto <= '0'; -- bit 8
        wait for test_baud2 ;
        tx_auto <= '1'; -- stop bit

        wait for 2*test_baud3 ;
        reset <= '1';
        wait for 2*test_baud3 ;
        reset <= '0';
        wait for 2*test_baud3 ;
        
        tx_auto <= '0'; -- start bit
        wait for test_baud3;

        tx_auto <= '1'; -- bit 1
        wait for test_baud3;
        tx_auto <= '1'; -- bit 2
        wait for test_baud3;
        tx_auto <= '1'; -- bit 3
        wait for test_baud3;
        tx_auto <= '1'; -- bit 4
        wait for test_baud3;
        tx_auto <= '1'; -- bit 5
        wait for test_baud3;
        tx_auto <= '1'; -- bit 6
        wait for test_baud3;
        tx_auto <= '1'; -- bit 7
        wait for test_baud3;
        tx_auto <= '0'; -- bit 8
        wait for test_baud3 ;
        tx_auto <= '1'; -- stop bit
		
        end_flag <= '1';
        wait;

    END PROCESS data;

END behavior;
