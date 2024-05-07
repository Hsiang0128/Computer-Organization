library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity receiver is
	generic(
		DBIT 		: integer := 8 ; 	-- # data bits
		SB_TICK	: integer := 16 	-- #tick for stop bits
	) ;
	port(
		clk 				: in std_logic;
		reset				: in std_logic;
		rx 				: in std_logic;
		s_tick 			: in std_logic;
		rx_done_tick	: out std_logic;
		dout 				: out std_logic_vector( 7 downto 0 )
	);
end receiver;
architecture behavior of receiver is
	type state_type is (
		IDLE,
		START,
		DATA,
		STOP
	);
	signal state_reg	: state_type;
	signal state_next	: state_type;
	signal s_reg		: unsigned(3 downto 0);
	signal s_next		: unsigned(3 downto 0);
	signal n_reg		: unsigned(2 downto 0);
	signal n_next 		: unsigned(2 downto 0);
	signal b_reg		: std_logic_vector(7 downto 0);
	signal b_next		: std_logic_vector(7 downto 0);
begin

	dout <= b_reg;
	process(clk,reset) begin
		if(reset = '1')then
			state_reg <= IDLE ;
			s_reg <= (others => '0');
			n_reg <= (others => '0');
			b_reg <= (others => '0');
		elsif(clk'event and clk = '1')then
			state_reg <= state_next ;
			s_reg <= s_next ;
			n_reg <= n_next ;
			b_reg <= b_next ;
		end if ;
	end process;
	
	process(state_reg,s_reg,n_reg,b_reg,s_tick,rx) begin
		state_next <= state_reg;
		s_next <= s_reg;
		n_next <= n_reg;
		b_next <= b_reg;
		rx_done_tick <= '0';
		case state_reg is
			when IDLE =>
				if(rx = '0')then
					state_next 	<= START;
					s_next 		<= (others => '0');
				end if;
			when START =>
				if(s_tick = '1')then
					if(s_reg = 7) then
						state_next <= DATA;
						s_next <= (others => '0');
						n_next <= (others => '0');
					else
						s_next <= s_reg + 1;
					end if;
				end if;
			when DATA =>
				if(s_tick = '1')then
					if(s_reg = 15)then
						s_next <= (others => '0');
						b_next <= rx & b_reg(7 downto 1);
						if(n_reg = (DBIT-1))then
							state_next <= STOP;
						else 
							n_next <= n_reg + 1;
						end if;
					else 
						s_next <= s_reg + 1;
					end if;
				end if;
			when STOP =>
				if(s_tick = '1') then
					if(s_reg = SB_TICK - 1) then
						state_next <= IDLE;
						rx_done_tick <= '1';
					else
						s_next <= s_reg + 1;
					end if;
				end if;
		end case ;
	end process;
end behavior;
