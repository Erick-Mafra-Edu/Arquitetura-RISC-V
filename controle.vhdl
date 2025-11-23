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
        case i_OPCODE is
            when "0010011" => -- I-type (addi, etc.)
                o_ALU_SRC   <= '1'; -- use immediate
                o_MEM2REG   <= '0'; -- use ALU result
                o_REG_WRITE <= '1'; -- write to register
                o_MEM_READ  <= '0';
                o_MEM_WRITE <= '0';
                o_ALUOP     <= "00"; -- ADD operation
            when "0110011" => -- R-type (add, sub, etc.)
                o_ALU_SRC   <= '0'; -- use register
                o_MEM2REG   <= '0'; -- use ALU result
                o_REG_WRITE <= '1'; -- write to register
                o_MEM_READ  <= '0';
                o_MEM_WRITE <= '0';
                o_ALUOP     <= "10"; -- R-type operations
            when "0000011" => -- Load (lw)
                o_ALU_SRC   <= '1'; -- use immediate
                o_MEM2REG   <= '1'; -- use memory data
                o_REG_WRITE <= '1'; -- write to register
                o_MEM_READ  <= '1'; -- read from memory
                o_MEM_WRITE <= '0';
                o_ALUOP     <= "00"; -- ADD operation for address calculation
            when "0100011" => -- Store (sw)
                o_ALU_SRC   <= '1'; -- use immediate
                o_MEM2REG   <= '0'; -- not used
                o_REG_WRITE <= '0'; -- no write to register
                o_MEM_READ  <= '0';
                o_MEM_WRITE <= '1'; -- write to memory
                o_ALUOP     <= "00"; -- ADD operation for address calculation
            when others =>
                o_ALU_SRC   <= '0';
                o_MEM2REG   <= '0';
                o_REG_WRITE <= '0';
                o_MEM_READ  <= '0';
                o_MEM_WRITE <= '0';
                o_ALUOP     <= "00";
        end case;
    end process;

end arch_controle;