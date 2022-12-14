--Paginação
SELECT *
  FROM (select NroEmpresa,
               CodFuncionario,
               Nome,
               row_number() over(order by CodFuncionario asc) as rank
          from dfp_Funcionario
         where NroEmpresa = 1)
WHERE RANK BETWEEN 10 AND 20 -- Posição da lista