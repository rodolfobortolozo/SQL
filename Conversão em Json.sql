SELECT json_object(
                   'id' VALUE SeqPessoa,
                   'nome' VALUE NomeRazao,
                   'cidade' VALUE Cidade,
                   'contato' VALUE json_object ('telefone' VALUE fonenro1,
                                           'telefone2' VALUE fonenro2,
                                           'emailxml' VALUE emailnfe)
                   
                   --ABSENT ON NULL
                   )
                   from GE_Pessoa
