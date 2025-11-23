-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity banco_registradores is

	Port (	i_CLK  	: in std_logic;
    		i_RSTn	: in std_logic;
            i_WRena	: in std_logic;
        i_WRaddr: in std_logic_vector(4 downto 0);
    		i_RS1 	: in std_logic_vector(4 downto 0);
            i_RS2 	: in std_logic_vector(4 downto 0);
                i_DATA 	: in std_logic_vector(31 downto 0);
                o_RS1 	: out std_logic_vector(31 downto 0);
                o_RS2 	: out std_logic_vector(31 downto 0);
                o_WR   : out std_logic_vector(31 downto 0)
         );
end banco_registradores;

architecture arch_1 of banco_registradores is

    type t_MEMORIA is array(0 to 31) of std_logic_vector(31 downto 0);    -- t_MEMORIA é um vetor de 32 registradores de 32 bits
    signal w_REG : t_MEMORIA := (others => (others => '0'));          -- é um sinal do tipo t_MEMORIA

begin
    process( i_CLK, i_RSTn, i_WRena, i_RS1, i_RS2, i_WRaddr, i_DATA, W_REG )
    begin
        if i_RSTn = '0' then
            w_REG <= (others => (others => '0'));
        elsif rising_edge(i_CLK) then               
            if i_WRena = '1' and i_WRaddr /= "00000" then         -- verifica se a escrita está ativa e o registrador é diferente de zero.
                w_REG(conv_integer(i_WRaddr)) <= i_DATA;       -- escreve i_DATA no registrador apontado por i_WRaddr
            end if;
        end if;
    end process;

    o_RS1 <= w_REG(conv_integer(i_RS1)) when i_RS1 /= "00000" else (others => '0');   -- mostra conteúdo do registrador apontado por i_RS1 ou zero
    o_RS2 <= w_REG(conv_integer(i_RS2)) when i_RS2 /= "00000" else (others => '0');   -- mostra conteúdo do registrador apontado por i_RS2
    o_WR  <= w_REG(conv_integer(i_WRaddr)) when i_WRaddr /= "00000" else (others => '0'); -- debug: conteúdo do registrador apontado por i_WRaddr

end arch_1;