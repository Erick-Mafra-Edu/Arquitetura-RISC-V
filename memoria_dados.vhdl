library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity memoria_dados is
  port(
    i_CLK, i_RSTn : std_logic;
    i_ADDR, i_DATA: in std_logic_vector(31 downto 0);
    i_WR, i_RD: in std_logic;
    o_DATA: out std_logic_vector(31 downto 0)
  );
end memoria_dados;

architecture arch_memoria_dados of memoria_dados is
type t_RAM_ARRAY is array(0 to 65535) of std_logic_vector(7 downto 0);
signal RAM: t_RAM_ARRAY;
begin
  process(i_CLK, i_RSTn) is
		begin
            if (i_RSTn = '0') then 
                --RAM <= (others=>'0');
            elsif (falling_edge(i_CLK)) then
            	if(i_WR='1') then
                    RAM(conv_integer(i_ADDR))		<=	i_DATA(31 downto 24);
                    RAM(conv_integer(i_ADDR)+1)	<=	i_DATA(23 downto 16);
                    RAM(conv_integer(i_ADDR)+2)	<=	i_DATA(15 downto 8);
                    RAM(conv_integer(i_ADDR)+3)	<=	i_DATA(7 downto 0);
                elsif (i_RD = '1') then
                    o_DATA <=	RAM(conv_integer(i_ADDR))   &
                    RAM(conv_integer(i_ADDR)+1) &
                    RAM(conv_integer(i_ADDR)+2) &
                    RAM(conv_integer(i_ADDR)+3);            	
                end if;
			end if;
	end process;
	
                
end arch_memoria_dados;