library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity MUX21 is

	port(
    	i_A  		: in  std_logic_vector(31 downto 0); --std_logic_vector é similar a bit_vector
        i_B  		: in  std_logic_vector(31 downto 0);
        i_SEL 		: in  std_logic;
        
        o_MUX  		: out std_logic_vector(31 downto 0)
    );

end MUX21;


architecture a1 of MUX21 is

begin
	process(i_A, i_B, i_SEL)
    begin
    	if (i_SEL = '0') then
            o_MUX <= i_A;
        else
        	o_MUX <= i_B;
        end if;
    end process;
    
   
end a1;