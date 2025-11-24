library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity muxMem is
    Port (	
            i_UALOUT  	: in std_logic_vector(31 downto 0);
            i_MEMDATA  	: in std_logic_vector(31 downto 0);
            i_MEM2REG   : in std_logic;
            o_MUXOUT    : out std_logic_vector(31 downto 0)
         );
end muxMem;

architecture arch_muxMem of muxMem is
begin

    process (i_UALOUT, i_MEMDATA, i_MEM2REG)
    begin
        if i_MEM2REG = '0' then
            o_MUXOUT <= i_UALOUT;
        else
            o_MUXOUT <= i_MEMDATA;
        end if;
    end process;

end architecture arch_muxMem;