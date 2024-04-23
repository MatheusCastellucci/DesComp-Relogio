library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoriaROM is
   generic (
          dataWidth: natural := 4;
          addrWidth: natural := 9
    );
   port (
          Endereco : in std_logic_vector (addrWidth-1 DOWNTO 0);
          Dado : out std_logic_vector (dataWidth-1 DOWNTO 0)
    );
end entity;

architecture assincrona of memoriaROM is

  type blocoMemoria is array(0 TO 2**addrWidth - 1) of std_logic_vector(dataWidth-1 DOWNTO 0);

  function initMemory
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
		  
		  
  constant NOP  : std_logic_vector(3 downto 0) := "0000";
  constant LDA  : std_logic_vector(3 downto 0) := "0001";
  constant SOMA : std_logic_vector(3 downto 0) := "0010";
  constant SUB  : std_logic_vector(3 downto 0) := "0011";
  constant LDI  : std_logic_vector(3 downto 0) := "0100";
  constant STA  : std_logic_vector(3 downto 0) := "0101";
  constant JMP  : std_logic_vector(3 downto 0) := "0110";
  constant JEQ  : std_logic_vector(3 downto 0) := "0111";
  constant CEQ  : std_logic_vector(3 downto 0) := "1000";
  constant JSR  : std_logic_vector(3 downto 0) := "1001";
  constant RET  : std_logic_vector(3 downto 0) := "1010";

		  
		  
  begin
tmp(0) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(1) := x"5" & "00" & '1' & x"FE";	-- STA @510                        	# Reseta a entrada KEY1
tmp(2) := x"5" & "00" & '1' & x"FC";	-- STA @508                        	# Reseta a entrada KEY0
tmp(3) := x"5" & "00" & '1' & x"FD";	-- STA @509                        	# Reseta a entrada de Reset
tmp(4) := x"4" & "00" & '0' & x"00";	-- LDI R0, $0                      	# Inicializa R0 com 0
tmp(5) := x"5" & "00" & '0' & x"00";	-- STA R0, @0                      	# Armazena 0 no endereço 0 da RAM
tmp(6) := x"4" & "00" & '0' & x"01";	-- LDI R0, $1                      	# Define R0 com valor 1
tmp(7) := x"5" & "00" & '0' & x"01";	-- STA R0, @1                      	# Armazena o valor 1 no endereço 1 da RAM
tmp(8) := x"4" & "00" & '0' & x"02";	-- LDI R0, $2                      	# Define R0 com valor 2
tmp(9) := x"5" & "00" & '0' & x"02";	-- STA R0, @2                      	# Armazena o valor 2 no endereço 2 da RAM
tmp(10) := x"4" & "00" & '0' & x"03";	-- LDI R0, $3                      	# Define R0 com valor 3
tmp(11) := x"5" & "00" & '0' & x"03";	-- STA R0, @3                      	# Armazena o valor 3 no endereço 3 da RAM
tmp(12) := x"4" & "00" & '0' & x"04";	-- LDI R0, $4                      	# Define R0 com valor 4
tmp(13) := x"5" & "00" & '0' & x"04";	-- STA R0, @4                      	# Armazena o valor 4 no endereço 4 da RAM
tmp(14) := x"4" & "00" & '0' & x"05";	-- LDI R0, $5                      	# Define R0 com valor 5
tmp(15) := x"5" & "00" & '0' & x"05";	-- STA R0, @5                      	# Armazena o valor 5 no endereço 5 da RAM
tmp(16) := x"4" & "00" & '0' & x"06";	-- LDI R0, $6                      	# Define R0 com valor 6
tmp(17) := x"5" & "00" & '0' & x"06";	-- STA R0, @6                      	# Armazena o valor 6 no endereço 6 da RAM
tmp(18) := x"4" & "00" & '0' & x"07";	-- LDI R0, $7                      	# Define R0 com valor 7
tmp(19) := x"5" & "00" & '0' & x"07";	-- STA R0, @7                      	# Armazena o valor 7 no endereço 7 da RAM
tmp(20) := x"4" & "00" & '0' & x"08";	-- LDI R0, $8                      	# Define R0 com valor 8
tmp(21) := x"5" & "00" & '0' & x"08";	-- STA R0, @8                      	# Armazena o valor 8 no endereço 8 da RAM
tmp(22) := x"4" & "00" & '0' & x"09";	-- LDI R0, $9                      	# Define R0 com valor 9
tmp(23) := x"5" & "00" & '0' & x"09";	-- STA R0, @9                      	# Armazena o valor 9 no endereço 9 da RAM
tmp(24) := x"4" & "00" & '0' & x"0A";	-- LDI R0, $10                     	# Define R0 com valor 10
tmp(25) := x"5" & "00" & '0' & x"0A";	-- STA R0, @10                     	# Armazena o valor 10 no endereço 10 da RAM
tmp(26) := x"4" & "00" & '0' & x"0B";	-- LDI R0, $11                     	# Define R0 com valor 11
tmp(27) := x"5" & "00" & '0' & x"0B";	-- STA R0, @11                     	# Armazena o valor 11 no endereço 11 da RAM
tmp(28) := x"4" & "00" & '0' & x"0C";	-- LDI R0, $12                     	# Define R0 com valor 12
tmp(29) := x"5" & "00" & '0' & x"0C";	-- STA R0, @12                     	# Armazena o valor 12 no endereço 12 da RAM
tmp(30) := x"4" & "00" & '0' & x"0D";	-- LDI R0, $13                     	# Define R0 com valor 13
tmp(31) := x"5" & "00" & '0' & x"0D";	-- STA R0, @13                     	# Armazena o valor 13 no endereço 13 da RAM
tmp(32) := x"4" & "00" & '0' & x"0E";	-- LDI R0, $14                     	# Define R0 com valor 14
tmp(33) := x"5" & "00" & '0' & x"0E";	-- STA R0, @14                     	# Armazena o valor 14 no endereço 14 da RAM
tmp(34) := x"4" & "00" & '0' & x"0F";	-- LDI R0, $15                     	# Define R0 com valor 15
tmp(35) := x"5" & "00" & '0' & x"0F";	-- STA R0, @15                     	# Armazena o valor 15 no endereço 15 da RAM
tmp(36) := x"1" & "00" & '0' & x"00";	-- LDA R0, @0                      	# Carrega o valor do endereço 0 da RAM em R0
tmp(37) := x"5" & "00" & '1' & x"02";	-- STA R0, @258                    	# Desliga o LED 9
tmp(38) := x"5" & "00" & '1' & x"01";	-- STA R0, @257                    	# Desliga o LED 8
tmp(39) := x"5" & "00" & '1' & x"00";	-- STA R0, @256                    	# Desliga os LEDs de 7 a 0
tmp(40) := x"5" & "00" & '1' & x"20";	-- STA R0, @288                    	# Limpa o display HEX 0
tmp(41) := x"5" & "00" & '1' & x"21";	-- STA R0, @289                    	# Limpa o display HEX 1
tmp(42) := x"5" & "00" & '1' & x"22";	-- STA R0, @290                    	# Limpa o display HEX 2
tmp(43) := x"5" & "00" & '1' & x"23";	-- STA R0, @291                    	# Limpa o display HEX 3
tmp(44) := x"5" & "00" & '1' & x"24";	-- STA R0, @292                    	# Limpa o display HEX 4
tmp(45) := x"5" & "00" & '1' & x"25";	-- STA R0, @293                    	# Limpa o display HEX 5
tmp(46) := x"5" & "00" & '0' & x"10";	-- STA R0, @16                     	# Zera o endereço 16 da RAM (segundos unidades)
tmp(47) := x"5" & "00" & '0' & x"11";	-- STA R0, @17                     	# Zera o endereço 17 da RAM (segundos dezenas)
tmp(48) := x"5" & "00" & '0' & x"12";	-- STA R0, @18                     	# Zera o endereço 18 da RAM (minutos unidades)
tmp(49) := x"5" & "00" & '0' & x"13";	-- STA R0, @19                     	# Zera o endereço 19 da RAM (minutos dezenas)
tmp(50) := x"5" & "00" & '0' & x"14";	-- STA R0, @20                     	# Zera o endereço 20 da RAM (horas unidades)
tmp(51) := x"5" & "00" & '0' & x"15";	-- STA R0, @21                     	# Zera o endereço 21 da RAM (horas dezenas)
tmp(52) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(53) := x"1" & "00" & '1' & x"61";	-- LDA R0, @353                    	# Carrega o estado da entrada KEY1 em R0
tmp(54) := x"8" & "00" & '0' & x"00";	-- CEQ R0, @0                      	# Verifica se R0 é igual a 0
tmp(55) := x"7" & "00" & '0' & x"39";	-- JEQ @57                         	# Pula se for verdade
tmp(56) := x"9" & "00" & '0' & x"BA";	-- JSR @186                        	# Executa sub-rotina se for falso
tmp(57) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(58) := x"1" & "00" & '1' & x"65";	-- LDA R0, @357                    	# Carrega o estado do CLOCK em R0
tmp(59) := x"8" & "00" & '0' & x"00";	-- CEQ R0, @0                      	# Verifica se R0 é igual a 0
tmp(60) := x"7" & "00" & '0' & x"4A";	-- JEQ @74                         	# Pula se for verdade
tmp(61) := x"9" & "00" & '0' & x"4F";	-- JSR @79                         	# Executa sub-rotina se for falso
tmp(62) := x"1" & "00" & '0' & x"10";	-- LDA R0, @16                     	# Carrega o valor do endereço 16 da RAM em R0
tmp(63) := x"5" & "00" & '1' & x"20";	-- STA R0, @288                    	# Atualiza o display HEX 0 com o valor de R0
tmp(64) := x"1" & "00" & '0' & x"11";	-- LDA R0, @17                     	# Carrega o valor do endereço 17 da RAM em R0
tmp(65) := x"5" & "00" & '1' & x"21";	-- STA R0, @289                    	# Atualiza o display HEX 1 com o valor de R0
tmp(66) := x"1" & "00" & '0' & x"12";	-- LDA R0, @18                     	# Carrega o valor do endereço 18 da RAM em R0
tmp(67) := x"5" & "00" & '1' & x"22";	-- STA R0, @290                    	# Atualiza o display HEX 2 com o valor de R0
tmp(68) := x"1" & "00" & '0' & x"13";	-- LDA R0, @19                     	# Carrega o valor do endereço 19 da RAM em R0
tmp(69) := x"5" & "00" & '1' & x"23";	-- STA R0, @291                    	# Atualiza o display HEX 3 com o valor de R0
tmp(70) := x"1" & "00" & '0' & x"14";	-- LDA R0, @20                     	# Carrega o valor do endereço 20 da RAM em R0
tmp(71) := x"5" & "00" & '1' & x"24";	-- STA R0, @292                    	# Atualiza o display HEX 4 com o valor de R0
tmp(72) := x"1" & "00" & '0' & x"15";	-- LDA R0, @21                     	# Carrega o valor do endereço 21 da RAM em R0
tmp(73) := x"5" & "00" & '1' & x"25";	-- STA R0, @293                    	# Atualiza o display HEX 5 com o valor de R0
tmp(74) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(75) := x"1" & "00" & '1' & x"64";	-- LDA R0, @356                    	# Carrega o estado do RESET em R0
tmp(76) := x"8" & "00" & '0' & x"01";	-- CEQ R0, @1                      	# Verifica se R0 é igual a 1
tmp(77) := x"7" & "00" & '0' & x"00";	-- JEQ @0                          	# Pula se for verdade
tmp(78) := x"6" & "00" & '0' & x"34";	-- JMP @52                         	# Continua se for falso
tmp(79) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(80) := x"5" & "00" & '1' & x"FC";	-- STA R0, @508                    	# Limpa a entrada do CLOCK em R0
tmp(81) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(82) := x"1" & "01" & '0' & x"10";	-- LDA R1, @16                     	# Carrega o valor do endereço 16 da RAM em R1
tmp(83) := x"2" & "01" & '0' & x"01";	-- SOMA R1, @1                     	# Incrementa R1 em 1
tmp(84) := x"8" & "01" & '0' & x"0A";	-- CEQ R1, @10                     	# Verifica se R1 é igual a 10
tmp(85) := x"7" & "00" & '0' & x"5B";	-- JEQ @91                         	# Pula se for verdade
tmp(86) := x"5" & "01" & '0' & x"10";	-- STA R1, @16                     	# Atualiza o endereço 16 da RAM com o valor de R1
tmp(87) := x"1" & "00" & '1' & x"60";	-- LDA R0, @352                    	# Carrega o estado da entrada KEY0 em R0
tmp(88) := x"8" & "00" & '0' & x"01";	-- CEQ R0, @1                      	# Verifica se R0 é igual a 1
tmp(89) := x"7" & "00" & '0' & x"D8";	-- JEQ @216                        	# Pula se for verdade
tmp(90) := x"A" & "00" & '0' & x"00";	-- RET                             	# Retorna se for falso
tmp(91) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(92) := x"1" & "01" & '0' & x"00";	-- LDA R1, @0                      	# Carrega o valor do endereço 0 da RAM em R1
tmp(93) := x"5" & "01" & '0' & x"10";	-- STA R1, @16                     	# Atualiza o endereço 16 da RAM com o valor de R1
tmp(94) := x"1" & "01" & '0' & x"11";	-- LDA R1, @17                     	# Carrega o valor do endereço 17 da RAM em R1
tmp(95) := x"2" & "01" & '0' & x"01";	-- SOMA R1, @1                     	# Incrementa R1 em 1
tmp(96) := x"8" & "01" & '0' & x"06";	-- CEQ R1, @6                      	# Verifica se R1 é igual a 6
tmp(97) := x"7" & "00" & '0' & x"B2";	-- JEQ @178                        	# Pula se for verdade
tmp(98) := x"5" & "01" & '0' & x"11";	-- STA R1, @17                     	# Atualiza o endereço 17 da RAM com o valor de R1
tmp(99) := x"1" & "00" & '1' & x"60";	-- LDA R0, @352                    	# Carrega o estado da entrada KEY0 em R0
tmp(100) := x"8" & "00" & '0' & x"01";	-- CEQ R0, @1                      	# Verifica se R0 é igual a 1
tmp(101) := x"7" & "00" & '0' & x"D8";	-- JEQ @216                        	# Pula se for verdade
tmp(102) := x"A" & "00" & '0' & x"00";	-- RET                             	# Retorna se for falso
tmp(103) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(104) := x"1" & "01" & '0' & x"12";	-- LDA R1, @18                     	# Carrega o valor do endereço 18 da RAM em R1
tmp(105) := x"2" & "01" & '0' & x"01";	-- SOMA R1, @1                     	# Incrementa R1 em 1
tmp(106) := x"8" & "01" & '0' & x"0A";	-- CEQ R1, @10                     	# Verifica se R1 é igual a 10
tmp(107) := x"7" & "00" & '0' & x"71";	-- JEQ @113                        	# Pula se for verdade
tmp(108) := x"5" & "01" & '0' & x"12";	-- STA R1, @18                     	# Atualiza o endereço 18 da RAM com o valor de R1
tmp(109) := x"1" & "00" & '1' & x"60";	-- LDA R0, @352                    	# Carrega o estado da entrada KEY0 em R0
tmp(110) := x"8" & "00" & '0' & x"01";	-- CEQ R0, @1                      	# Verifica se R0 é igual a 1
tmp(111) := x"7" & "00" & '0' & x"C9";	-- JEQ @201                        	# Pula se for verdade
tmp(112) := x"A" & "00" & '0' & x"00";	-- RET                             	# Retorna se for falso
tmp(113) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(114) := x"1" & "01" & '0' & x"00";	-- LDA R1, @0                      	# Carrega o valor do endereço 0 da RAM em R1
tmp(115) := x"5" & "01" & '0' & x"12";	-- STA R1, @18                     	# Atualiza o endereço 18 da RAM com o valor de R1
tmp(116) := x"1" & "01" & '0' & x"13";	-- LDA R1, @19                     	# Carrega o valor do endereço 19 da RAM em R1
tmp(117) := x"2" & "01" & '0' & x"01";	-- SOMA R1, @1                     	# Incrementa R1 em 1
tmp(118) := x"8" & "01" & '0' & x"06";	-- CEQ R1, @6                      	# Verifica se R1 é igual a 6
tmp(119) := x"7" & "00" & '0' & x"AA";	-- JEQ @170                        	# Pula se for verdade
tmp(120) := x"5" & "01" & '0' & x"13";	-- STA R1, @19                     	# Atualiza o endereço 19 da RAM com o valor de R1
tmp(121) := x"1" & "00" & '1' & x"60";	-- LDA R0, @352                    	# Carrega o estado da entrada KEY0 em R0
tmp(122) := x"8" & "00" & '0' & x"01";	-- CEQ R0, @1                      	# Verifica se R0 é igual a 1
tmp(123) := x"7" & "00" & '0' & x"C9";	-- JEQ @201                        	# Pula se for verdade
tmp(124) := x"A" & "00" & '0' & x"00";	-- RET                             	# Retorna se for falso
tmp(125) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(126) := x"1" & "01" & '0' & x"15";	-- LDA R1, @21                     	# Carrega o valor do endereço 21 da RAM em R1
tmp(127) := x"8" & "01" & '0' & x"02";	-- CEQ R1, @2                      	# Verifica se R1 é igual a 2
tmp(128) := x"7" & "00" & '0' & x"8A";	-- JEQ @138                        	# Pula se for verdade
tmp(129) := x"1" & "01" & '0' & x"14";	-- LDA R1, @20                     	# Carrega o valor do endereço 20 da RAM em R1
tmp(130) := x"2" & "01" & '0' & x"01";	-- SOMA R1, @1                     	# Incrementa R1 em 1
tmp(131) := x"8" & "01" & '0' & x"0A";	-- CEQ R1, @10                     	# Verifica se R1 é igual a 10
tmp(132) := x"7" & "00" & '0' & x"94";	-- JEQ @148                        	# Pula se for verdade
tmp(133) := x"5" & "01" & '0' & x"14";	-- STA R1, @20                     	# Atualiza o endereço 20 da RAM com o valor de R1
tmp(134) := x"1" & "00" & '1' & x"60";	-- LDA R0, @352                    	# Carrega o estado da entrada KEY0 em R0
tmp(135) := x"8" & "00" & '0' & x"01";	-- CEQ R0, @1                      	# Verifica se R0 é igual a 1
tmp(136) := x"7" & "00" & '0' & x"BA";	-- JEQ @186                        	# Pula se for verdade
tmp(137) := x"A" & "00" & '0' & x"00";	-- RET                             	# Retorna se for falso
tmp(138) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(139) := x"1" & "01" & '0' & x"14";	-- LDA R1, @20                     	# Carrega o valor do endereço 20 da RAM em R1
tmp(140) := x"2" & "01" & '0' & x"01";	-- SOMA R1, @1                     	# Incrementa R1 em 1
tmp(141) := x"8" & "01" & '0' & x"04";	-- CEQ R1, @4                      	# Verifica se R1 é igual a 4
tmp(142) := x"7" & "00" & '0' & x"9E";	-- JEQ @158                        	# Pula se for verdade
tmp(143) := x"5" & "01" & '0' & x"14";	-- STA R1, @20                     	# Atualiza o endereço 20 da RAM com o valor de R1
tmp(144) := x"1" & "00" & '1' & x"60";	-- LDA R0, @352                    	# Carrega o estado da entrada KEY0 em R0
tmp(145) := x"8" & "00" & '0' & x"01";	-- CEQ R0, @1                      	# Verifica se R0 é igual a 1
tmp(146) := x"7" & "00" & '0' & x"BA";	-- JEQ @186                        	# Pula se for verdade
tmp(147) := x"A" & "00" & '0' & x"00";	-- RET                             	# Retorna se for falso
tmp(148) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(149) := x"1" & "01" & '0' & x"00";	-- LDA R1, @0                      	# Carrega o valor do endereço 0 da RAM em R1
tmp(150) := x"5" & "01" & '0' & x"14";	-- STA R1, @20                     	# Atualiza o endereço 20 da RAM com o valor de R1
tmp(151) := x"1" & "01" & '0' & x"15";	-- LDA R1, @21                     	# Carrega o valor do endereço 21 da RAM em R1
tmp(152) := x"2" & "01" & '0' & x"01";	-- SOMA R1, @1                     	# Incrementa R1 em 1
tmp(153) := x"5" & "01" & '0' & x"15";	-- STA R1, @21                     	# Atualiza o endereço 21 da RAM com o valor de R1
tmp(154) := x"1" & "00" & '1' & x"60";	-- LDA R0, @352                    	# Carrega o estado da entrada KEY0 em R0
tmp(155) := x"8" & "00" & '0' & x"01";	-- CEQ R0, @1                      	# Verifica se R0 é igual a 1
tmp(156) := x"7" & "00" & '0' & x"BA";	-- JEQ @186                        	# Pula se for verdade
tmp(157) := x"A" & "00" & '0' & x"00";	-- RET                             	# Retorna se for falso
tmp(158) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(159) := x"1" & "01" & '0' & x"00";	-- LDA R1, @0                      	# Carrega o valor do endereço 0 da RAM em R1
tmp(160) := x"5" & "01" & '0' & x"15";	-- STA R1, @21                     	# Atualiza o endereço 21 da RAM com o valor de R1
tmp(161) := x"5" & "01" & '0' & x"14";	-- STA R1, @20                     	# Atualiza o endereço 20 da RAM com o valor de R1
tmp(162) := x"1" & "00" & '1' & x"60";	-- LDA R0, @352                    	# Carrega o estado da entrada KEY0 em R0
tmp(163) := x"8" & "00" & '0' & x"01";	-- CEQ R0, @1                      	# Verifica se R0 é igual a 1
tmp(164) := x"7" & "00" & '0' & x"BA";	-- JEQ @186                        	# Pula se for verdade
tmp(165) := x"5" & "01" & '0' & x"13";	-- STA R1, @19                     	# Atualiza o endereço 19 da RAM com o valor de R1
tmp(166) := x"5" & "01" & '0' & x"12";	-- STA R1, @18                     	# Atualiza o endereço 18 da RAM com o valor de R1
tmp(167) := x"5" & "01" & '0' & x"11";	-- STA R1, @17                     	# Atualiza o endereço 17 da RAM com o valor de R1
tmp(168) := x"5" & "01" & '0' & x"10";	-- STA R1, @16                     	# Atualiza o endereço 16 da RAM com o valor de R1
tmp(169) := x"A" & "00" & '0' & x"00";	-- RET                             	# Retorna
tmp(170) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(171) := x"1" & "01" & '0' & x"00";	-- LDA R1, @0                      	# Carrega o valor do endereço 0 da RAM em R1
tmp(172) := x"5" & "01" & '0' & x"13";	-- STA R1, @19                     	# Atualiza o endereço 19 da RAM com o valor de R1
tmp(173) := x"5" & "01" & '0' & x"12";	-- STA R1, @18                     	# Atualiza o endereço 18 da RAM com o valor de R1
tmp(174) := x"1" & "00" & '1' & x"60";	-- LDA R0, @352                    	# Carrega o estado da entrada KEY0 em R0
tmp(175) := x"8" & "00" & '0' & x"01";	-- CEQ R0, @1                      	# Verifica se R0 é igual a 1
tmp(176) := x"7" & "00" & '0' & x"C9";	-- JEQ @201                        	# Pula se for verdade
tmp(177) := x"6" & "00" & '0' & x"7D";	-- JMP @125                        	# Continua se for falso
tmp(178) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(179) := x"1" & "01" & '0' & x"00";	-- LDA R1, @0                      	# Carrega o valor do endereço 0 da RAM em R1
tmp(180) := x"5" & "01" & '0' & x"11";	-- STA R1, @17                     	# Atualiza o endereço 17 da RAM com o valor de R1
tmp(181) := x"5" & "01" & '0' & x"10";	-- STA R1, @16                     	# Atualiza o endereço 16 da RAM com o valor de R1
tmp(182) := x"1" & "00" & '1' & x"60";	-- LDA R0, @352                    	# Carrega o estado da entrada KEY0 em R0
tmp(183) := x"8" & "00" & '0' & x"01";	-- CEQ R0, @1                      	# Verifica se R0 é igual a 1
tmp(184) := x"7" & "00" & '0' & x"D8";	-- JEQ @216                        	# Pula se for verdade
tmp(185) := x"6" & "00" & '0' & x"67";	-- JMP @103                        	# Continua se for falso
tmp(186) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(187) := x"5" & "00" & '1' & x"FE";	-- STA @510                        	# Reseta a entrada KEY1
tmp(188) := x"5" & "00" & '1' & x"FF";	-- STA @511                        	# Reseta a entrada KEY0
tmp(189) := x"1" & "01" & '0' & x"14";	-- LDA R1, @20                     	# Carrega o valor do endereço 20 da RAM em R1
tmp(190) := x"5" & "01" & '1' & x"24";	-- STA R1, @292                    	# Atualiza o display HEX 4 com o valor de R1
tmp(191) := x"1" & "01" & '0' & x"15";	-- LDA R1, @21                     	# Carrega o valor do endereço 21 da RAM em R1
tmp(192) := x"5" & "01" & '1' & x"25";	-- STA R1, @293                    	# Atualiza o display HEX 5 com o valor de R1
tmp(193) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(194) := x"1" & "00" & '1' & x"60";	-- LDA R0, @352                    	# Carrega o estado da entrada KEY0 em R0
tmp(195) := x"8" & "00" & '0' & x"01";	-- CEQ R0, @1                      	# Verifica se R0 é igual a 1
tmp(196) := x"7" & "00" & '0' & x"7D";	-- JEQ @125                        	# Pula se for verdade
tmp(197) := x"1" & "00" & '1' & x"61";	-- LDA R0, @353                    	# Carrega o estado da entrada KEY1 em R0
tmp(198) := x"8" & "00" & '0' & x"00";	-- CEQ R0, @0                      	# Verifica se R0 é igual a 0
tmp(199) := x"7" & "00" & '0' & x"C1";	-- JEQ @193                        	# Pula se for verdade
tmp(200) := x"5" & "00" & '1' & x"FE";	-- STA @510                        	# Reseta a entrada KEY1
tmp(201) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(202) := x"5" & "00" & '1' & x"FE";	-- STA @510                        	# Reseta a entrada KEY1
tmp(203) := x"5" & "00" & '1' & x"FF";	-- STA @511                        	# Reseta a entrada KEY0
tmp(204) := x"1" & "01" & '0' & x"12";	-- LDA R1, @18                     	# Carrega o valor do endereço 18 da RAM em R1
tmp(205) := x"5" & "01" & '1' & x"22";	-- STA R1, @290                    	# Atualiza o display HEX 2 com o valor de R1
tmp(206) := x"1" & "01" & '0' & x"13";	-- LDA R1, @19                     	# Carrega o valor do endereço 19 da RAM em R1
tmp(207) := x"5" & "01" & '1' & x"23";	-- STA R1, @291                    	# Atualiza o display HEX 3 com o valor de R1
tmp(208) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(209) := x"1" & "00" & '1' & x"60";	-- LDA R0, @352                    	# Carrega o estado da entrada KEY0 em R0
tmp(210) := x"8" & "00" & '0' & x"01";	-- CEQ R0, @1                      	# Verifica se R0 é igual a 1
tmp(211) := x"7" & "00" & '0' & x"67";	-- JEQ @103                        	# Pula se for verdade
tmp(212) := x"1" & "00" & '1' & x"61";	-- LDA R0, @353                    	# Carrega o estado da entrada KEY1 em R0
tmp(213) := x"8" & "00" & '0' & x"00";	-- CEQ R0, @0                      	# Verifica se R0 é igual a 0
tmp(214) := x"7" & "00" & '0' & x"D0";	-- JEQ @208                        	# Pula se for verdade
tmp(215) := x"5" & "00" & '1' & x"FE";	-- STA @510                        	# Reseta a entrada KEY1
tmp(216) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(217) := x"5" & "00" & '1' & x"FE";	-- STA @510                        	# Reseta a entrada KEY1
tmp(218) := x"5" & "00" & '1' & x"FF";	-- STA @511                        	# Reseta a entrada KEY0
tmp(219) := x"1" & "01" & '0' & x"10";	-- LDA R1, @16                     	# Carrega o valor do endereço 16 da RAM em R1
tmp(220) := x"5" & "01" & '1' & x"20";	-- STA R1, @288                    	# Atualiza o display HEX 0 com o valor de R1
tmp(221) := x"1" & "01" & '0' & x"11";	-- LDA R1, @17                     	# Carrega o valor do endereço 17 da RAM em R1
tmp(222) := x"5" & "01" & '1' & x"21";	-- STA R1, @289                    	# Atualiza o display HEX 1 com o valor de R1
tmp(223) := x"0" & "00" & '0' & x"00";	-- NOP
tmp(224) := x"1" & "00" & '1' & x"60";	-- LDA R0, @352                    	# Carrega o estado da entrada KEY0 em R0
tmp(225) := x"8" & "00" & '0' & x"01";	-- CEQ R0, @1                      	# Verifica se R0 é igual a 1
tmp(226) := x"7" & "00" & '0' & x"51";	-- JEQ @81                         	# Pula se for verdade
tmp(227) := x"1" & "00" & '1' & x"61";	-- LDA R0, @353                    	# Carrega o estado da entrada KEY1 em R0
tmp(228) := x"8" & "00" & '0' & x"00";	-- CEQ R0, @0                      	# Verifica se R0 é igual a 0
tmp(229) := x"7" & "00" & '0' & x"DF";	-- JEQ @223                        	# Pula se for verdade
tmp(230) := x"5" & "00" & '1' & x"FE";	-- STA @510                        	# Reseta a entrada KEY1
tmp(231) := x"A" & "00" & '0' & x"00";	-- RET                             	# Retorna


        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;