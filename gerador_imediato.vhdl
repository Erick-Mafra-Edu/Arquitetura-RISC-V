library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity gerador_imediato is
    port (
        i_INST	: in  std_logic_vector(31 downto 0);
        o_IMM   : out std_logic_vector(31 downto 0)
    );
end entity gerador_imediato;

architecture arch_gerador_imediato of gerador_imediato is

    signal w_OPCODE : std_logic_vector(6 downto 0);
    signal w_TEMP: std_logic_vector(31 downto 0);
    signal w_TYPE_I, w_TYPE_S, w_TYPE_B, w_TYPE_J : std_logic_vector(31 downto 0);
begin
    process( i_INST, w_OPCODE, w_TYPE_I, w_TYPE_S, w_TYPE_B, w_TYPE_J)
    begin
        case w_OPCODE is
            when ("0010011") => w_TEMP <= w_TYPE_I; -- LW, I aritimético
            when ("0000011") => w_TEMP <= w_TYPE_I;
            when ("0100011") => w_TEMP <= w_TYPE_S; --SW
            when ("1100011") => w_TEMP <= w_TYPE_B; --BRANCH
            when ("1100111") => w_TEMP <= w_TYPE_I; --JALR
            when ("1101111") => w_TEMP <= w_TYPE_J;	--JAL
            when others => w_TEMP <= (others => '0');
        end case;       
    end process ; 
    
    -- formato i (inclui JALR)
    w_TYPE_I <= X"00000" & i_INST(31 downto 20) when i_INST(31) = '0' else (X"FFFFF" & i_INST(31 downto 20));
    
    -- formato s
    w_TYPE_S <= X"00000" & ( i_INST(31 downto 25) & i_INST(11 downto 7) ) when i_INST(31) = '0' else
               (X"FFFFF" & ( i_INST(31 downto 25) & i_INST(11 downto 7) ));
    
    -- formato b
    w_TYPE_B <= X"00000" & ( i_INST(31) & i_INST(7) & i_INST(30 downto 25) & i_INST(11 downto 8) ) when i_INST(31) = '0' else
               (X"FFFFF" & (i_INST(31) & i_INST(7) & i_INST(30 downto 25) & i_INST(11 downto 8))); 
    -- formato U (revisar)
    --UtypeImmediate  <= X"000" & instruction(31 downto 12) when instruction(31) = '0' else X"FFF" & instruction(31 downto 12);
    -- formato J do JAL
    
    w_TYPE_J <= X"000" & ( i_INST(31) & i_INST(19 downto 12) & i_INST(20) & i_INST(30 downto 21) ) when i_INST(31) = '0' else
               (X"FFF" & ( i_INST(31) & i_INST(19 downto 12) & i_INST(20) & i_INST(30 downto 21)) );

    w_OPCODE <= i_INST(6 downto 0);
    o_IMM <= w_TEMP;
end architecture arch_gerador_imediato;