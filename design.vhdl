-- Trabalho em trios, mas todos devem saber explicar o projeto inteiro.

-- Consulte o guia praico do RISC-V para entender sobre o formato das instrucoes
---- conecte os campos das instruco no processador
------ exemplo: separando os 7 bits de opcode da instrucaw_INST(6 downto 0)


-- X Crie um moulo controle
---- X A interface do controle estacomentada neste documento.
---- X Gere os sinais de controle de acordo com o coigo de operacao recebido.
---- X Ligue os sinais corretamente.
---- X DICA: Saber como esses sinais funcionam garante uma questao da prova.


-- x Modifique a ULA para receber o sinal de w_ALUOP do controle.
---- x Ele serve, entre outras coisas, para evitar que a ULA tente fazer uma operacao de SUBI incorretamente.
---- x A ULA deve realizar, pelo menos, as operacoes de ADD/SUB, AND, OR, XOR


-- Inclua a memoria de dados e seu caminho de dados.
---- Com esse arquivo sera possivel fazer operacoes de LW e SW.
---- A memoria de dados deve receber: 
------ A saida w_ULA como entrada de endereco.
------ A saioda w_RS2 como entrada de dados.
------ Controlar a operacao com sinais do controle.

-- Inclua um multiplexador no projeto para que o controle possa escolher entre colocar o dado que sai da ULA ou da memoia de dados no banco de registradores

-- Nao e necessario implementar o caminho dos desvios condicionais e incondicionais, mas e desejavel que o controle gere o sinal de desvio

-- OBS: 
---- Seu codigo so vai comecar a compilar quando voce conectar os sinais que estao em aberto no codigo.
---- Voce tera que modificar a memoria de instrucoes para testar operacoes de LW e SW
---- Utilizem o simulador da Cadence em Tools & Simulators, pois ele executa o diagrama de formas de onda corretamente.


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity RISCV32i is

    Port (  
            i_CLK    : in  std_logic;
            i_RSTn    : in  std_logic;
            
            -- sinais para depuração
            o_INST        : out std_logic_vector(31 downto 0);
            o_OPCODE    : out std_logic_vector(6 downto 0); -- não encontro onde está
            o_RD_ADDR    : out std_logic_vector(4 downto 0);
            o_RD_DATA    : out std_logic_vector(31 downto 0);
            o_RS1_ADDR     : out std_logic_vector(4 downto 0);-- endereço do registrador
            o_RS2_ADDR     : out std_logic_vector(4 downto 0);
            o_RS1_DATA     : out std_logic_vector(31 downto 0); -- conteudo do registrador
            o_RS2_DATA     : out std_logic_vector(31 downto 0);
            o_IMM        : out std_logic_vector(31 downto 0); -- imediato
            o_ULA        : out std_logic_vector(31 downto 0); -- saida da ULA
            o_MEM        : out std_logic_vector(31 downto 0); -- saida memoria
            o_REG_WRITE  : out std_logic; -- sinal de controle REG_WRITE
            o_ALU_SRC    : out std_logic; -- sinal de controle ALU_SRC
            o_MEM2REG    : out std_logic  -- sinal de controle MEM2REG
         );

end RISCV32i;

architecture arch_3 of RISCV32i is
    signal w_RS1, w_RS2 : std_logic_vector(31 downto 0); -- liga a saída do banco
    signal w_ULA : std_logic_vector(31 downto 0); -- liga a saída da ULA
    signal w_ULAb: std_logic_vector(31 downto 0); -- liga entrada b da ula
    signal w_ZERO: std_logic; -- register 0
    
    --sinais da memoia de dados
    signal w_MEM: std_logic_vector(31 downto 0); -- saia da memoria de dados
    
    -- sinais do gerador de imediato
    signal w_IMM : std_logic_vector(31 downto 0);
    -- sinais do PC e memória de instrução
    signal w_PC, w_PC4 : std_logic_vector(31 downto 0); -- endereco da instrucao/ proxima instrucao
    signal w_INST : std_logic_vector(31 downto 0); -- instrução lida
    signal w_RD_DATA : std_logic_vector(31 downto 0);
    signal w_REG_DATA : std_logic_vector(31 downto 0); -- dado que vai para o banco de registradores



    
    -- sinais de controle
    signal w_ALU_SRC    : std_logic;
    signal w_MEM2REG    : std_logic;
    signal w_REG_WRITE    : std_logic;
    signal w_MEM_READ    : std_logic;
    signal w_MEM_WRITE    : std_logic;
    signal w_ALUOP        : std_logic_vector(1 downto 0);
    
begin

    


    u_CONTROLE: entity work.controle
    port map (    
        i_OPCODE     => w_INST(6 downto 0), -- Opcode correto: bits 6-0
        o_ALU_SRC    => w_ALU_SRC, -- escolhe entre w_RS2 e w_IMED
        o_MEM2REG    => w_MEM2REG, -- escolhe entre w_ALU e w_MEM
        o_REG_WRITE    => w_REG_WRITE, -- permite escrever no BANCO DE REGISTRADORES
        o_MEM_READ    => w_MEM_READ, -- habilita memória para leitura
        o_MEM_WRITE    => w_MEM_WRITE, -- habilita memória para escrita
        o_ALUOP        => w_ALUOP    -- gera sinais para ajudar a escolher a operação da ULA
    );

    u_PC: entity work.ffd -- registra o PC (próxima instrução a ser executada)
    port map (
        i_DATA    => w_PC4, 
        i_CLK     => i_CLK,
        i_RSTn    => i_RSTn,
        o_DATA    => w_PC
    );
    
    u_SOMA4 : entity work.somador -- calcula o endereço da próxima instrução
    port map (    
        i_A        => w_PC, 
        i_B      => "00000000000000000000000000000100",  
        o_DATA  => w_PC4
    );
    
    u_MEM_INST: entity work.memoria_instrucoes
    port map(
        i_ADDR        => w_PC,
        o_INST         => w_INST
    );
    
    u_GERADOR_IMM : entity work.gerador_imediato -- gera o imediato concatenando os bits corretos (ext de sinal)
    port map(
        i_INST    => w_INST,
        o_IMM   => w_IMM
    );

        u_BANCO_REGISTRADORES: entity work.banco_registradores
    port map (    
          i_CLK    => i_CLK, 
          i_RSTn    => i_RSTn, 
          i_WRena    => w_REG_WRITE, -- coloque os campos corretos do controle
          i_WRaddr  => w_INST(11 downto 7), -- coloque os campos corretos da instrução
          i_RS1     => w_INST(19 downto 15), -- separação do campo rs1 da instrução
          i_RS2     => w_INST(24 downto 20), -- separação do campo rs2 da instrução
            i_DATA     => w_REG_DATA, 
            o_RS1     => w_RS1,    
            o_RS2     => w_RS2,
            o_WR      => w_RD_DATA
    );

    u_ULA : entity work.ULA 
    port map(
        i_A    => w_RS1,
        i_B    => w_ULAb,
        i_OPCODE => w_INST(6 downto 0), -- Opcode da instrução
        i_F3    => w_INST(14 downto 12), -- Funct3 da instrução
        i_INST30=> w_INST(30), -- bit 30 da instrução
        i_ALUOP => w_ALUOP, -- sinal do controle
        o_ZERO   => w_ZERO, 
        o_ULA => w_ULA
    );
    
    u_MUX_ULA: entity work.mux21
    port map (
        i_A        => w_RS2, 
        i_B        => w_IMM, -- Instantaneo do gerador de imediato
        i_SEL    => w_ALU_SRC, -- sinal do controle
        o_MUX   => w_ULAb 
    );
    
    u_MUX_MEM2REG: entity work.mux21
    port map (
        i_A        => w_ULA, 
        i_B        => w_MEM, -- saida da memoria de dados
        i_SEL    => w_MEM2REG, -- sinal do controle
        o_MUX   => w_REG_DATA 
    );
    
    -- Memoria de dados
    u_MEM_DADOS: entity work.memoria_dados
    port map (
        i_CLK       => i_CLK,
        i_RSTn      => i_RSTn,
        i_MEM_WRITE => w_MEM_WRITE,
        i_MEM_READ  => w_MEM_READ,
        i_ADDR      => w_ULA, -- endereco calculado pela ULA
        i_DATA      => w_RS2, -- dado do registrador rs2 para escrita
        o_DATA      => w_MEM  -- dado lido da memoria
    );
    
    -- Sinais para depuração com o testbench
    o_INST         <= w_INST; -- depuração do resultado da ULA
    o_OPCODE       <= w_INST(6 downto 0);
    o_RD_ADDR      <= w_INST(11 downto 7);
    o_RS1_ADDR     <= w_INST(19 downto 15);
    o_RS2_ADDR     <= w_INST(24 downto 20);
    o_RS1_DATA     <= w_RS1;
    o_RS2_DATA     <= w_RS2;
    o_IMM          <= w_IMM;
    o_ULA          <= w_ULA; -- depuração do resultado da ULA
    o_MEM          <= w_MEM;
    o_REG_WRITE    <= w_REG_WRITE;
    o_ALU_SRC      <= w_ALU_SRC;
    o_MEM2REG      <= w_MEM2REG;
    o_RD_DATA      <= w_RD_DATA;
    



end arch_3;
