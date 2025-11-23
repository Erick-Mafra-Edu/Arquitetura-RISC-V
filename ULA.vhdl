--ULA incompleta, faltando instucao
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity ULA is

	port(
    	i_A  		: in  std_logic_vector(31 downto 0); --std_logic_vector esimilar a bit_vector
        i_B  		: in  std_logic_vector(31 downto 0);
        i_OPCODE    : in  std_logic_vector(6 downto 0); -- 7 bits do campo opcode
        i_F3 		: in  std_logic_vector(2 downto 0); -- 3 bits do campo funct3
        i_INST30	: in std_logic;
        i_ALUOP     : in std_logic_vector(1 downto 0); -- 2 bits do campo ALUOp
        o_ZERO		: in std_logic;
        o_ULA  		: out std_logic_vector(31 downto 0)
    );

end ULA;

architecture a1 of ULA is
begin process(i_A, i_B, i_F3, i_INST30)
    begin
    	if (i_F3 = "000") then
            if(i_INST30 = '0') then
        		o_ULA <= i_A + i_B;
            else
            	o_ULA <= i_A - i_B;
            end if;
        elsif (i_F3 = "100") then
        	o_ULA <= i_A xor i_B;
        elsif(i_F3 = "111") then
            o_ULA <= i_A and i_B;
        elsif(i_F3 = "110") then
            o_ULA <= i_A or i_B;
        elsif(i_F3 = "010") then
            if i_A < i_B then
                o_ULA <= "00000000000000000000000000000001"; -- set less than
            else
                o_ULA <= "00000000000000000000000000000000";
            end if;
        else
            o_ULA <= (others => '0');
        end if;
    -- https://lists.riscv.org/g/tech-unprivileged/attachment/535/0/unpriv-isa-asciidoc.pdf 
    end process;
end a1;
