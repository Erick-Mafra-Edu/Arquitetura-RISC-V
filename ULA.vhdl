--ULA incompleta, faltando várias operações.
--by Felski.
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity ULA is

	port(
    	i_A  		: in  std_logic_vector(31 downto 0); --std_logic_vector é similar a bit_vector
        i_B  		: in  std_logic_vector(31 downto 0);
        i_F3 		: in  std_logic_vector(2 downto 0); -- 3 bits do campo funct3
        i_INST30	: in std_logic;
        o_ZERO		: in std_logic;
        o_ULA  		: out std_logic_vector(31 downto 0)
    );

end ULA;


architecture a1 of ULA is

begin
	process(i_A, i_B, i_F3, i_INST30)
    begin
    	if (i_F3 = "000") then
            if(i_INST30 = '0') then
        		o_ULA <= i_A + i_B;
            else
            	o_ULA <= i_A - i_B;
            end if;
        elsif (i_F3 = "100") then
        	o_ULA <= i_A xor i_B;
        end if;
    end process;
    
    --process(i_A, i_B, i_F3)
    --begin
    --	case i_F3 is
    --    	when "000" => 
    --        	if(i_INST30 = '0') then
    --    			o_ULA <= i_A + i_B;
    --       	else
    --        		o_ULA <= i_A - i_B;
    --        	end if;
    --       when "100" => o_ULA <= i_A xor i_B;
    --       
    --       when OTHERS => o_ULA <= (others => '0');    
    --	end case;
    --end process;
    
    --o_ULA <= 	i_A+i_B 	when i_F3 = "000" and i_INST30 = '0' else
    --			i_A-i_B 	when i_F3 = "000" and i_INST30 = '1' else
    --            i_A xor i_B when i_F3 = "100" else (others => '0'); 
    

end a1;