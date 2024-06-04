
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Auto_BaudRate is
	generic(
		CLK_INPUT 	: integer :=  40000000 --40M
	);
	port(
		clk, tx_auto  : in std_logic;
		reset 		  : in std_logic;
        test,ok_flag,check_flag			: out std_logic ;
        BAUD_RATE_auto	: out std_logic_vector(64 downto 0)
	);
end Auto_BaudRate;
architecture behavior of Auto_BaudRate is
	signal high_count,low_count,clk_time,auto_temp,chick_low_count,count,chick_high_count : integer := 0;
   	SIGNAL stop_flag,start_flag,up_flag,down_flag,chick_stop_flag,chick_start_flag : std_logic := '0';
	signal ok_flag_tmp :std_logic:= '0';
	signal test_tmp	:std_logic:='0'; 
	signal check_flag_tmp : std_logic:= '0';
begin
	ok_flag <= ok_flag_tmp;
	check_flag <= check_flag_tmp;
	test <= test_tmp;
	process(clk)begin
		if(clk = '1' )then
        
          if( ok_flag_tmp= '1' )then
            	if(tx_auto = '0' and chick_start_flag= '0')then
                	count <= count + 1;
                    if(count > CLK_INPUT/auto_temp)then
                		chick_start_flag <='1';
                    end if;
                elsif(tx_auto = '1'  and chick_start_flag='1'and chick_stop_flag='0')then
                	chick_high_count <=  chick_high_count+1;
                    
                elsif(tx_auto = '0'  and chick_start_flag='1'and chick_stop_flag='0')then
                	chick_low_count <=  chick_low_count+1;
                end if;

               if(chick_high_count > CLK_INPUT/auto_temp*8)then
                  chick_stop_flag<='1';
                  check_flag_tmp<='0';
               end if;

               if(chick_low_count > CLK_INPUT/auto_temp*8)then
                  chick_stop_flag<='1';
                  check_flag_tmp<='1';
               end if;
            end if;
            
        	if( reset = '1')then
            	start_flag	<=	'0';
            	stop_flag	<=	'0';
                high_count	<=	0 ;
                auto_temp 	<= 0 ;
                ok_flag_tmp		<= '0';
                count <= 0;
                chick_low_count	<= 0;
                chick_high_count <= 0;
                chick_stop_flag <='0';
                chick_start_flag <= '0';
             end if;    
			if(tx_auto = '1' and ok_flag_tmp ='0')then
            	
                up_flag <= '1';
                
                if( start_flag='1')then
               	 	test_tmp<= '1';
	                high_count <= high_count +1;
                end if;
                
            elsif(tx_auto = '0' and ok_flag_tmp ='0')then 
                
                down_flag <= '1';
                if(up_flag = '1' and stop_flag = '0')then
                	start_flag <= '1'; 
                end if;
                if( down_flag='1'	and start_flag ='1')then 
	            	stop_flag <= '1';
                    test_tmp <= '0';
                    if high_count /= 0 then
                        auto_temp <= CLK_INPUT / (high_count / 7);
                    end if;
				end if;
                
            end if; 
		end if;
        
        if(stop_flag = '1' and ok_flag_tmp ='0')then
            if(auto_temp-2000 < 19200 and auto_temp+2000 > 19200)then
    	        
                BAUD_RATE_auto <=std_logic_vector(to_unsigned(19200,BAUD_RATE_auto'length ));

				ok_flag_tmp <= '1';
			elsif(auto_temp + 2000 > 4800 and auto_temp - 2000 < 4800)then
    	       
               BAUD_RATE_auto <=std_logic_vector(to_unsigned(4800,BAUD_RATE_auto'length ));
				ok_flag_tmp <= '1';

            elsif(auto_temp + 2000 > 9600 and auto_temp - 2000 < 9600)then
    	        
                BAUD_RATE_auto <=std_logic_vector(to_unsigned(9600,BAUD_RATE_auto'length ));
                
				ok_flag_tmp <= '1';
			else
           		BAUD_RATE_auto <=std_logic_vector(to_unsigned(0,BAUD_RATE_auto'length ));
			
            end if;
            
            
            ------------
          
          end if;
	end process;
end behavior;