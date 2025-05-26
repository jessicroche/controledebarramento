library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity logica is port(
    priority,reset,clock : in STD_LOGIC;
    request: in STD_LOGIC_VECTOR(3 downto 0);
    aut0,aut1,aut2,aut3: out STD_LOGIC
); end logica;

architecture behav_sistema of logica is 
    type state_type is (idle, estado_aut0, estado_aut1, estado_aut2,estado_aut3);
    signal estado_atual : state_type;
begin
    process(clock, reset) begin
        if reset = '1' then
            estado_atual <= idle;
        elsif rising_edge(clock) then
            case estado_atual is
                when idle =>
                    if request(0) = '1' then
                        estado_atual <= estado_aut0;
                    elsif request (1) = '1' then
                        estado_atual <= estado_aut1;
                    elsif request(2) = '1' then
                        estado_atual <= estado_aut2;
                    elsif request(3) = '1' then
                        estado_atual <= estado_aut3;
                    else estado_atual <=idle;
                    end if;
                when estado_aut0 =>
                        if request(0)='1' then
                            estado_atual <= estado_aut0;
                        elsif request(0)='0' then
                            estado_atual <= idle;
                        end if;
                when estado_aut1 =>
                    if priority='1' and request(0)='1' then
                        estado_atual <= estado_aut0;
                    elsif request(1)='0' then
                        estado_atual <= idle;
                    else estado_atual <= estado_aut1;
                    end if;
                when estado_aut2 =>
                        if priority='1' and request(0)='1' then
                            estado_atual <= estado_aut0;
                        elsif priority='1' and request(1)='1' then 
                            estado_atual <= estado_aut1;
                        elsif request(2)='0' then 
                            estado_atual <= idle;
                        else estado_atual <= estado_aut2;
                        end if;
                when estado_aut3 =>
                    if priority='1' and request(0)='1' then 
                        estado_atual <= estado_aut0;
                    elsif priority='1' and request(1)='1' then
                        estado_atual <= estado_aut1;
                    elsif priority='1' and request(2)='1' then 
                        estado_atual <= estado_aut2;
                    elsif request(3)='0' then
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
                aut0 <= '0';
                aut1 <= '0'; 
                aut2 <= '0'; 
                aut3 <= '0';
            when estado_aut0 =>
                aut0 <= '1'; 
                aut1 <= '0';
                aut2 <= '0'; 
                aut3 <= '0'; 
            when estado_aut1 =>
                aut0 <= '0'; 
                aut1 <= '1'; 
                aut2 <= '0'; 
                aut3 <= '0'; 
            when estado_aut2 =>
                aut0 <= '0'; 
                aut1 <= '0'; 
                aut2 <= '1'; 
                aut3 <= '0';
            when estado_aut3 =>
                aut0 <= '0'; 
                aut1 <= '0';
                aut2 <= '0'; 
                aut3 <= '1'; 
            when others => null;
            end case;
    end process;
end architecture behav_sistema;