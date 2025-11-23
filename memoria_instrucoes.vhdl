library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity memoria_instrucoes is
    port (
        i_ADDR     :in std_logic_vector(31 downto 0);
        o_INST :out std_logic_vector(31 downto 0) 
    );
end entity memoria_instrucoes;

architecture arch_memoria_instrucoes of memoria_instrucoes is
    
    type t_ROM_ARRAY is array (0 to 65535) of std_logic_vector(7 downto 0);      
    constant ROM : t_ROM_ARRAY := (
    	"00000000","00010000","00000010","10010011", -- addi t0, zero, 1 
		"00000000","00100000","00000011","00010011", -- addi t1, zero, 2
		"00000000","00110000","00000011","10010011", -- addi t2, zero, 3
		"00000000","01000000","00001110","00010011", -- addi t3, zero, 4
		"00000000","01010000","00001110","10010011", -- addi t4, zero, 5
		"00000000","01100000","00001111","00010011", -- addi t5, zero, 6
		"00000000","01110000","00001111","10010011", -- addi t6, zero, 7
		"00000001","11111111","00000100","00110011", -- add  s0, t5, t6 # s0 = 6+7 = D
		"01000000","01100010","10000100","10110011", -- sub  s1, t0, t1 # s1 = 1-2 = FFFF_FFFF
		"00000001","11100011","11111001","00110011", -- and  s2, t2, t5 # s2 = 3and6 = 2
		"00000001","11010011","01101001","10110011", -- or   s3, t1, t4 # s3 = 2or5 = 7
		"00000001","11010010","11001001","10110011", -- xor  s3, t0, t4 # s3 = 1xor5 = 4
	
        others => X"00"
    );
begin
    o_INST <= ROM(conv_integer(i_ADDR)) & ROM(conv_integer(i_ADDR + 1)) &
                   ROM(conv_integer(i_ADDR + 2)) & ROM(conv_integer(i_ADDR + 3)); 
    
 

end architecture arch_memoria_instrucoes;