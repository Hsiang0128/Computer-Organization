library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity transmitter is
	generic(
		DBIT		: integer := 8;	-- data bits
		SB_TICK	: integer := 16 	-- ticks for stop bits 1
	);
	port(
		clk				: in std_logic;
		reset				: in std_logic;
		tx_start			: in std_logic;
		s_tick			: in std_logic;
		din				: in std_logic_vector ( 7 downto 0 );
		tx_done_tick	: out std_logic;
		tx					: out std_logic
	);
end transmitter ;

architecture behavior of transmitter is
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
	signal b_reg		: std_logic_vector(7 downto 0 );
	signal b_next		: std_logic_vector(7 downto 0 );
	signal tx_reg		: std_logic;
	signal tx_next		: std_logic;
begin
	tx <= tx_reg;
	process(clk,reset)begin
		if(reset = '1')then
			state_reg <= IDLE;
			s_reg <= (others=> '0');
			n_reg <= (others=> '0');
			b_reg	<= (others=> '0');
			tx_reg <= '1';
		elsif(clk'event and clk = '1')then
			state_reg <= state_next;
			s_reg <= s_next;
			n_reg <= n_next;
			b_reg	<= b_next;
			tx_reg <= tx_next;
		end if;
	end process;
	
	process(state_reg ,s_reg,n_reg,b_reg,s_tick,tx_reg,tx_start,din)begin
		state_next <= state_reg;
		s_next <= s_reg;
		n_next <= n_reg;
		b_next <= b_reg;
		tx_next <= tx_reg;
		tx_done_tick <= '0';
		case state_reg is
			when IDLE =>
				tx_next <= '1';
				if(tx_start = '1')then
					state_next <= START;
					s_next <= (others => '0');
					b_next <= din;
				end if;
			when START =>
				tx_next <= '0';
				if(s_tick = '1')then
					if(s_reg = 15)then
						state_next <= data;
						s_next <= (others=> '0');
						n_next <= (others=> '0');
					else
						s_next <= s_reg + 1;
						end if;
				end if; 
			when DATA =>
				tx_next <= b_reg(0);
				if (s_tick = '1')then
					if(s_reg = 15)then
						s_next <= (others=> '0');
						b_next <= '0' & b_reg(7 downto 1);
						if(n_reg = (DBIT - 1))then
							state_next <= STOP ; 
						else
							n_next <= n_reg + 1; 
						end if;
					else
						s_next <= s_reg + 1;
					end if;
				end if;
			when STOP =>
				tx_next <= '1';
				if(s_tick = '1')then
					if (s_reg =(SB_TICK-1))then
						state_next <= IDLE;
						tx_done_tick <= '1';
					else
						s_next <= s_reg + 1;
					end if;
				end if;
		end case; 
	end process;
end behavior;