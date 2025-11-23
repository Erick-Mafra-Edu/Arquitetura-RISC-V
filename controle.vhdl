library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity controle is

    Port (	i_OPCODE  	: in std_logic_vector(6 downto 0);
            o_ALU_SRC   : out std_logic;
            o_MEM_TO_REG: out std_logic;
            o_REG_WRITE : out std_logic;
            o_MEM_READ  : out std_logic;
            o_MEM_WRITE : out std_logic;
            o_BRANCH    : out std_logic;
            o_ALU_OP    : out std_logic_vector(1 downto 0)
         );
end controle;

architecture arch_controle of controle is
begin

    process(i_OPCODE)
    begin
        case i_OPCODE is
            when "0000011" => -- LW
                o_ALU_SRC    <= '1';
                o_MEM_TO_REG <= '1';
                o_REG_WRITE  <= '1';
                o_MEM_READ   <= '1';
                o_MEM_WRITE  <= '0';
                o_BRANCH     <= '0';
                o_ALU_OP     <= "00";
            when "0100011" => -- SW
                o_ALU_SRC    <= '1';
                o_MEM_TO_REG <= '0'; -- don't care
                o_REG_WRITE  <= '0';
                o_MEM_READ   <= '0';
                o_MEM_WRITE  <= '1';
                o_BRANCH     <= '0';
                o_ALU_OP     <= "00";
            when others =>
                o_ALU_SRC    <= '0';
                o_MEM_TO_REG <= '0';
                o_REG_WRITE  <= '0';
                o_MEM_READ   <= '0';
                o_MEM_WRITE  <= '0';
                o_BRANCH     <= '0';
                o_ALU_OP     <= "00";
        end case;
    end process;

end arch_controle;