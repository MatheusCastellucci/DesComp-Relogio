LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity divisorGenerico_e_Interface is
	
   port(clk      :   in std_logic;
      habilitaLeitura : in std_logic;
      limpaLeitura : in std_logic;
      leituraUmSegundo :   out std_logic_vector (7 downto 0);
		seletor : in std_logic
   );
end entity;

architecture interface of divisorGenerico_e_Interface is
  signal sinalUmSegundo : std_logic;
  signal saidaclk_reg1seg, saidaclk_rapido, tempo  : std_logic;
begin

baseTempo: entity work.divisorGenerico
           generic map (divisor => 25000000)   -- divide por 10.
           port map (clk => clk, saida_clk => saidaclk_reg1seg);
			  
			  
baseTempoR: entity work.divisorGenerico
           generic map (divisor => 25000)   -- divide por 10.
           port map (clk => clk, saida_clk => saidaclk_rapido);	
	
MUXTempo :  entity work.muxGenerico2x1_bit  generic map (larguraDados => 1)
        port map( entradaA_MUX => saidaclk_reg1seg,
                 entradaB_MUX =>  saidaclk_rapido,
                 seletor_MUX => seletor,
                 saida_MUX => tempo);
				

			  
registraUmSegundo: entity work.FlipFlop
   port map (DIN => '1', DOUT => sinalUmSegundo,
         ENABLE => '1', CLK => tempo,
         RST => limpaLeitura);

-- Faz o tristate de saida:
leituraUmSegundo <= "0000000" & sinalUmSegundo when habilitaLeitura = '1' else "ZZZZZZZZ";

end architecture interface;