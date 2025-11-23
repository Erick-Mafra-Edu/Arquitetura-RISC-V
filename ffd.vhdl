library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ffd is
    port (
        i_DATA    : in  std_logic_vector(31 downto 0);
        i_CLK     : in  std_logic;
        i_RSTn    : in  std_logic;
        o_DATA    : out std_logic_vector(31 downto 0)
    );
end entity ffd;

architecture arch_ffd of ffd is

begin
    process( i_CLK, i_RSTn)
    begin
        if i_RSTn = '0' then
            o_DATA <= (others => '0');
        else
            if rising_edge(i_CLK) then        
                    o_DATA <= i_DATA;          --register operation
            end if;
        end if;
    end process ;
end arch_ffd ; -- arch_ffd