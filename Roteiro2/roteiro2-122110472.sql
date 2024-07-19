-- Questão 1
-- Para inserir os valores é necessário criar as tabelas:

CREATE TABLE tarefas(
    id INTEGER,
    descricao VARCHAR(255),
    cpf_encarregado CHAR(11),
    prioridade INTEGER,
    status CHAR(1)
);

INSERT INTO tarefas VALUES (2147483646, 'limpar chão do corredor central','98765432111', 0, 'F');
INSERT INTO tarefas VALUES (2147483647, 'limpar janelas da sala 203', '98765432122', 1, 'F');
INSERT INTO tarefas VALUES (null, null, null, null, null);

INSERT INTO tarefas VALUES (2147483644, 'limpar chão do corredor superior', '987654323211', 0, 'F');
-- Erro 'value too long' para o CHAR(11) (cpf)

INSERT INTO tarefas VALUES (2147483643, 'limpar chão do corredor superior', '98765432321', 0, 'FF');
-- Erro 'value too long' para o CHAR(1) (status)



-- Questão 2

INSERT INTO tarefas VALUES (2147483648, 'limpar portas do térreo', '32323232955', 4, 'A');
-- Erro 'integer out of range', para resolver:
ALTER TABLE tarefas ALTER COLUMN id TYPE BIGINT;



-- Questão 3
-- Deve ser permitido inserir valores até 32757 e para isso:
ALTER TABLE tarefas ALTER COLUMN prioridade TYPE SMALLINT;

INSERT INTO tarefas VALUES (2147483651, 'limpar portas do 1o andar','32323232911', 32767, 'A');
INSERT INTO tarefas VALUES (2147483652, 'limpar portas do 2o andar', '32323232911', 32766, 'A');



-- Questão 4

-- Nomeando a coluna corretamente:
ALTER TABLE tarefas RENAME COLUMN cpf_encarregado TO func_resp_cpf;

-- Eliminando a possibilidade de adicionar valores null

-- Ao tentar alterar a tabela:
-- ERROR:  column "id" of relation "tarefas" contains null values

-- Primeiro elimina-se os valores null existentes:
DELETE FROM tarefas WHERE id is null;

-- Em seguida altera-se as colunas das tabelas:
ALTER TABLE tarefas ALTER COLUMN id SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN descricao SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN func_resp_cpf SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN prioridade SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN status SET NOT NULL;



-- Questão 5
-- Não permitir id's repetidos

ALTER TABLE tarefas ADD PRIMARY KEY (id);
INSERT INTO tarefas VALUES (2147483653, 'limpar portas do 1o andar','32323232911', 2, 'A');