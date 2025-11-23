library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity controle is

    Port (	
            i_OPCODE  	: in std_logic_vector(6 downto 0); --- Entrada, 7 bits separados da memoria de instrucoes
            o_ALU_SRC   : out std_logic; -- sinal de controle para o mux da ULA
            o_MEM2REG    : out std_logic; -- sinal de controle para o mux de escrita no banco
            o_REG_WRITE : out std_logic; -- sinal de controle para escrita no banco de registradores
            o_MEM_READ  : out std_logic; -- sinal de controle para leitura na memoria de dados
            o_MEM_WRITE : out std_logic; -- sinal de controle para escrita na memoria de dados
            o_ALUOP    : out std_logic_vector(1 downto 0) -- sinal de controle para a ULA
            --o_MEM_WRITE : out std_logic -- sinal de controle para escrita na memoria            o_ALUOP    : out std_logic_vector(1 downto 0) -- sinal de controle para a ULA
         );
end controle;

architecture arch_controle of controle is
begin

    process (i_OPCODE)
    begin
        o_ALU_SRC   <= i_OPCODE(2); -- bit 3 do opcode
        o_MEM2REG   <= i_OPCODE(4); -- bit 5 do opcode
        o_REG_WRITE <= i_OPCODE(3); -- bit 4 do opcode
        o_MEM_READ  <= i_OPCODE(5); -- bit 6 do opcode
        o_MEM_WRITE <= i_OPCODE(6); -- bit 7 do opcode
        o_ALUOP     <= i_OPCODE(1 downto 0); -- bits 1 e 0 do opcode
    end process;

end arch_controle;