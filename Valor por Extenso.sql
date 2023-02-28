FUNCTION ESTF_VLREXTENSO(valor number) return varchar2 is
  extenso     varchar2(240);
  b1          number(1);
  b2          number(1);
  b3          number(1);
  b4          number(1);
  b5          number(1);
  b6          number(1);
  b7          number(1);
  b8          number(1);
  b9          number(1);
  b10         number(1);
  b11         number(1);
  b12         number(1);
  b13         number(1);
  b14         number(1);
  l1          varchar2(12);
  l2          varchar2(3);
  l3          varchar2(9);
  l4          varchar2(3);
  l5          varchar2(6);
  l6          varchar2(8);
  l7          varchar2(12);
  l8          varchar2(3);
  l9          varchar2(9);
  l10         varchar2(3);
  l11         varchar2(6);
  l12         varchar2(8);
  l13         varchar2(12);
  l14         varchar2(3);
  l15         varchar2(9);
  l16         varchar2(3);
  l17         varchar2(6);
  l18         varchar2(8);
  l19         varchar2(12);
  l20         varchar2(3);
  l21         varchar2(9);
  l22         varchar2(3);
  l23         varchar2(6);
  l24         varchar2(16);
  l25         varchar2(3);
  l26         varchar2(9);
  l27         varchar2(3);
  l28         varchar2(6);
  l29         varchar2(17);
  virgula_bi  char(3);
  virgula_mi  char(3);
  virgula_mil char(3);
  virgula_cr  char(3);
  valor1      char(14);

  -- TABELA DE CENTENAS --
  centenas char(108) := '       Cento    Duzentos   Trezentos' ||
                        'Quatrocentos  Quinhentos  Seiscentos' ||
                        '  Setecentos  Oitocentos  Novecentos';

  -- TABELA DE DEZENAS --
  dezenas char(79) := '      Dez    Vinte   Trinta Quarenta' ||
                      'Cinquenta Sessenta  Setenta  Oitenta' || 'Noventa';

  -- TABELA DE UNIDADES --
  unidades char(54) := '    Um  Dois  TresQuatro Cinco  Seis' ||
                       '  Sete  Oito  Nove';

  -- TABELA DE UNIDADES DA DEZENA 10 --
  unid10 char(81) := '     Onze     Doze    Treze Quatorze' ||
                     '   QuinzeDezesseisDezessete  Dezoito' || ' Dezenove';

begin
  valor1 := lpad(to_char(valor * 100), 14, '0');
  b1     := substr(valor1, 1, 1);
  b2     := substr(valor1, 2, 1);
  b3     := substr(valor1, 3, 1);
  b4     := substr(valor1, 4, 1);
  b5     := substr(valor1, 5, 1);
  b6     := substr(valor1, 6, 1);
  b7     := substr(valor1, 7, 1);
  b8     := substr(valor1, 8, 1);
  b9     := substr(valor1, 9, 1);
  b10    := substr(valor1, 10, 1);
  b11    := substr(valor1, 11, 1);
  b12    := substr(valor1, 12, 1);
  b13    := substr(valor1, 13, 1);
  b14    := substr(valor1, 14, 1);

  if valor != 0 then
    if b1 != 0 then
      if b1 = 1 then
        if b2 = 0 and b3 = 0 then
          l5 := 'Cem';
        else
          l1 := substr(centenas, b1 * 12 - 11, 12);
        end if;
      else
        l1 := substr(centenas, b1 * 12 - 11, 12);
      end if;
    end if;
    if b2 != 0 then
      if b2 = 1 then
        if b3 = 0 then
          l5 := 'Dez';
        else
          l3 := substr(unid10, b3 * 9 - 8, 9);
        end if;
      else
        l3 := substr(dezenas, b2 * 9 - 8, 9);
      end if;
    end if;
    if b3 != 0 then
      if b2 != 1 then
        l5 := substr(unidades, b3 * 6 - 5, 6);
      end if;
    end if;
    if b1 != 0 or b2 != 0 or b3 != 0 then
      if (b1 = 0 and b2 = 0) and b3 = 1 then
        l5 := 'Um';
        l6 := ' Bilhão';
      else
        l6 := ' Bilhões';
      end if;
      if valor > 999999999 then
        virgula_bi := ' e ';
        if (b4 + b5 + b6 + b7 + b8 + b9 + b10 + b11 + b12) = 0 then
          virgula_bi := ' de';
        end if;
      end if;
      l1 := ltrim(l1);
      l3 := ltrim(l3);
      l5 := ltrim(l5);
      if b2 > 1 and b3 > 0 then
        l4 := ' e ';
      end if;
      if b1 != 0 and (b2 != 0 or b3 != 0) then
        l2 := ' e ';
      end if;
    end if;
    -- ROTINA DOS MILHOES --
    if b4 != 0 then
      if b4 = 1 then
        if b5 = 0 and b6 = 0 then
          l7 := 'Cem';
        else
          l7 := substr(centenas, b4 * 12 - 11, 12);
        end if;
      else
        l7 := substr(centenas, b4 * 12 - 11, 12);
      end if;
    end if;
    if b5 != 0 then
      if b5 = 1 then
        if b6 = 0 then
          l11 := 'Dez';
        else
          l9 := substr(unid10, b6 * 9 - 8, 9);
        end if;
      else
        l9 := substr(dezenas, b5 * 9 - 8, 9);
      end if;
    end if;
    if b6 != 0 then
      if b5 != 1 then
        l11 := substr(unidades, b6 * 6 - 5, 6);
      end if;
    end if;
    if b4 != 0 or b5 != 0 or b6 != 0 then
      if (b4 = 0 and b5 = 0) and b6 = 1 then
        l11 := ' Um';
        l12 := ' Milhão';
      else
        l12 := ' Milhões';
      end if;
      if valor > 999999 then
        virgula_mi := ' e ';
        if (b7 + b8 + b9 + b10 + b11 + b12) = 0 then
          virgula_mi := ' de';
        end if;
      end if;
      l7  := ltrim(l7);
      l9  := ltrim(l9);
      l11 := ltrim(l11);
      if b5 > 1 and b6 > 0 then
        l10 := ' e ';
      end if;
      if b4 != 0 and (b5 != 0 or b6 != 0) then
        l8 := ' e ';
      end if;
    end if;
    -- ROTINA DOS MILHARES --
    if b7 != 0 then
      if b7 = 1 then
        if b8 = 0 and b9 = 0 then
          l17 := 'Cem';
        else
          l13 := substr(centenas, b7 * 12 - 11, 12);
        end if;
      else
        l13 := substr(centenas, b7 * 12 - 11, 12);
      end if;
    end if;
    if b8 != 0 then
      if b8 = 1 then
        if b9 = 0 then
          l17 := 'Dez';
        else
          l15 := substr(unid10, b9 * 9 - 8, 9);
        end if;
      else
        l15 := substr(dezenas, b8 * 9 - 8, 9);
      end if;
    end if;
    if b9 != 0 then
      if b8 != 1 then
        l17 := substr(unidades, b9 * 6 - 5, 6);
      end if;
    end if;
    if b7 != 0 or b8 != 0 or b9 != 0 then
      if (b7 = 0 and b8 = 0) and b9 = 1 then
        l17 := 'Um';
        l18 := ' Mil';
      else
        l18 := ' Mil';
      end if;
      if valor > 999 and (b10 + b11 + b12) != 0 then
        virgula_mil := ' e ';
      end if;
      l13 := ltrim(l13);
      l15 := ltrim(l15);
      l17 := ltrim(l17);
      if b8 > 1 and b9 > 0 then
        l16 := ' e ';
      end if;
      if b7 != 0 and (b8 != 0 or b9 != 0) then
        l14 := ' e ';
      end if;
    end if;
    -- ROTINA DOS REAIS --
    if b10 != 0 then
      if b10 = 1 then
        if b11 = 0 and b12 = 0 then
          l19 := 'Cem';
        else
          l19 := substr(centenas, b10 * 12 - 11, 12);
        end if;
      else
        l19 := substr(centenas, b10 * 12 - 11, 12);
      end if;
    end if;
    if b11 != 0 then
      if b11 = 1 then
        if b12 = 0 then
          l23 := 'Dez';
        else
          l21 := substr(unid10, b12 * 9 - 8, 9);
        end if;
      else
        l21 := substr(dezenas, b11 * 9 - 8, 9);
      end if;
    end if;
    if b12 != 0 then
      if b11 != 1 then
        l23 := substr(unidades, b12 * 6 - 5, 6);
      end if;
    end if;
    if b10 != 0 or b11 != 0 or b12 != 0 then
      if valor > 0 and valor < 2 then
        l23 := 'Um';
      end if;
      l19 := ltrim(l19);
      l21 := ltrim(l21);
      l23 := ltrim(l23);
      if b11 > 1 and b12 > 0 then
        l22 := ' e ';
      end if;
      if b10 != 0 and (b11 != 0 or b12 != 0) then
        l20 := ' e ';
      end if;
    end if;
    if valor > 0 and valor < 2 then
      if b12 != 0 then
        l24 := ' Real';
      end if;
    else
      if valor > 1 then
        l24 := ' Reais';
      end if;
    end if;
    -- TRATA CENTAVOS --
    if b13 != 0 OR b14 != 0 then
      if valor > 0 then
        if (b12 != 0) or
           (b1 + b2 + b3 + b4 + b5 + b6 + b7 + b8 + b9 + b10 + b11 + b12) != 0 then
          L25 := ' e ';
        end if;
      end if;
      if b13 != 0 then
        if b13 = 1 then
          if b14 = 0 then
            l28 := 'Dez';
          else
            l26 := substr(unid10, b14 * 9 - 8, 9);
          end if;
        else
          l26 := substr(dezenas, b13 * 9 - 8, 9);
        end if;
      end if;
      if b14 != 0 then
        if b13 != 1 then
          l28 := substr(unidades, b14 * 6 - 5, 6);
        end if;
      end if;
      if b13 != 0 or b14 != 0 then
        if valor = 1 then
          l28 := 'Um';
        end if;
        l26 := ltrim(l26);
        l28 := ltrim(l28);
        if b13 > 1 and b14 > 0 then
          l27 := ' e ';
        end if;
      end if;
      if (b1 + b2 + b3 + b4 + b5 + b6 + b7 + b8 + b9 + b10 + b11 + b12) > 0 then
        if b13 = 0 and b14 = 1 then
          l29 := ' Centavo';
        else
          l29 := ' Centavos';
        end if;
      else
        if b13 = 0 and b14 = 1 then
          l29 := ' Centavo de Real';
        else
          l29 := ' Centavos de Real';
        end if;
      end if;
    end if;
    -- CONCATENAR O LITERAL --
    if l29 = ' Centavo de Real' or l29 = ' Centavos de Real' then
      virgula_mil := '';
    end if;
    extenso := l1 || l2 || l3 || l4 || l5 || l6 || virgula_bi || L7 || L8 || L9 || L10 || L11 || l12 ||
               virgula_mi || l13 || l14 || l15 || l16 || l17 || l18 ||
               virgula_mil || L19 || L20 || L21 || L22 || L23 || l24 ||
               virgula_cr || L25 || L26 || L27 || L28 || L29;
    extenso := ltrim(extenso);
    extenso := replace(extenso, '  ', ' ');
  else
    extenso := 'Zero';
  end if;
  return extenso;
END ESTF_VLREXTENSO;