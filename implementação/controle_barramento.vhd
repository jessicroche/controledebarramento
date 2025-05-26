library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity controle_barramento is port(
	KEY: in STD_LOGIC_VECTOR(3 downto 0);-- reset = KEY(1), clock = KEY(0)
    SW: in STD_LOGIC_VECTOR(9 downto 0);-- requests= SW(0 a 3) e priority = SW(9)
    LEDR: out STD_LOGIC_VECTOR(9 downto 0) -- aut0 a aut3 = LEDR(0 a 3)
); end controle_barramento;

architecture behav_sistema of controle_barramento is 
    type state_type is (idle, estado_aut0, estado_aut1, estado_aut2,estado_aut3);
    signal estado_atual : state_type;
begin
    process(KEY(0), KEY(1)) begin
        if KEY(1) = '0' then --reset
            estado_atual <= idle;
        elsif rising_edge(KEY(0)) then --clock
            case estado_atual is
                when idle => --inicia o de menor indice independente da prioridade
                    if SW(0) = '1' then
                        estado_atual <= estado_aut0;
                    elsif SW(1) = '1' then
                        estado_atual <= estado_aut1;
                    elsif SW(2) = '1' then
                        estado_atual <= estado_aut2;
                    elsif SW(3) = '1' then
                        estado_atual <= estado_aut3;
                    else estado_atual <=idle;
                    end if;
                when estado_aut0 =>
                        if SW(0)='1' then
                            estado_atual <= estado_aut0;
                        elsif SW(0)='0' then
                            estado_atual <= idle;
                        end if;
                when estado_aut1 =>
                    if SW(9)='1' and SW(0)='1' then
                        estado_atual <= estado_aut0;
                    elsif SW(1)='0' then
                        estado_atual <= idle;
                    else estado_atual <= estado_aut1;
                    end if;
                when estado_aut2 =>
                        if SW(9)='1' and SW(0)='1' then
                            estado_atual <= estado_aut0;
                        elsif SW(9)='1' and SW(1)='1' then 
                            estado_atual <= estado_aut1;
                        elsif SW(2)='0' then 
                            estado_atual <= idle;
                        else estado_atual <= estado_aut2;
                        end if;
                when estado_aut3 =>
                    if SW(9)='1' and SW(0)='1' then 
                        estado_atual <= estado_aut0;
                    elsif SW(9)='1' and SW(1)='1' then
                        estado_atual <= estado_aut1;
                    elsif SW(9)='1' and SW(2)='1' then 
                        estado_atual <= estado_aut2;
                    elsif SW(3)='0' then
                        estado_atual <= idle;
                    else estado_atual <= estado_aut3;
                    end if;
                when others => null;
            end case;
        end if;
    end process;
    process (estado_atual) begin
        case estado_atual is
            when idle =>
                LEDR(0) <= '0';
                LEDR(1) <= '0'; 
                LEDR(2) <= '0'; 
                LEDR(3) <= '0';
            when estado_aut0 =>
                LEDR(0) <= '1'; 
                LEDR(1) <= '0';
                LEDR(2) <= '0'; 
                LEDR(3) <= '0'; 
            when estado_aut1 =>
                LEDR(0) <= '0'; 
                LEDR(1) <= '1'; 
                LEDR(2) <= '0'; 
                LEDR(3) <= '0'; 
            when estado_aut2 =>
                LEDR(0) <= '0'; 
                LEDR(1) <= '0'; 
                LEDR(2) <= '1'; 
                LEDR(3) <= '0';
            when estado_aut3 =>
                LEDR(0) <= '0'; 
                LEDR(1) <= '0';
                LEDR(2) <= '0'; 
                LEDR(3) <= '1'; 
            when others => null;
            end case;
    end process;
end architecture behav_sistema;