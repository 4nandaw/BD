CREATE TYPE estado AS ENUM ('MA', 'PI', 'CE', 'PB', 'RN', 'PE', 'AL', 'SE', 'BA');

CREATE TABLE farmacias (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50),
    tipo CHAR(1) CHECK (tipo IN ('S', 'F')), -- Sede ou Filial
    bairro VARCHAR(50) UNIQUE,
    cidade VARCHAR(50),
    estado estado, -- Usando o tipo ENUM
    gerente_cpf CHAR(11), --FK func
    gerente_cargo CHAR(1), -- FK func
    CONSTRAINT farmacias_gerente_fkey FOREIGN KEY (gerente_cpf, gerente_cargo) REFERENCES funcionario (cpf, cargo),
    CONSTRAINT gerente_cargo_valido_chk CHECK (gerente_cargo IN ('F', 'A')),
    CONSTRAINT sede_unica EXCLUDE USING gist (nome WITH =) WHERE (tipo = 'S')
);


CREATE TABLE funcionario (
    cpf CHAR(11) PRIMARY KEY,
    nome VARCHAR(255),
    cargo CHAR(1) CHECK (cargo IS NOT NULL AND cargo IN ('F', 'V', 'E', 'C', 'A')), -- Farmaceutico, Vendedor, Entregador, Caixa ou Administrador
    id_farmacia INTEGER, -- FK farmacia
    CONSTRAINT funcionario_cpf_cargo_uk UNIQUE (cpf, cargo),
    CONSTRAINT cpf_valido_chk CHECK (char_length(cpf) = 11)
);

ALTER TABLE funcionario ADD CONSTRAINT funcionario_id_farmacia_fkey FOREIGN KEY (id_farmacia) REFERENCES farmacias (id);


CREATE TABLE clientes (
    cpf CHAR(11) PRIMARY KEY,
    nome VARCHAR(255),
    data_nasc DATE,
    CONSTRAINT cpf_valido_chk CHECK (char_length(cpf) = 11),
    CONSTRAINT maior_de_18_anos_chk CHECK (data_nasc <= (CURRENT_DATE - INTERVAL '18 years'))
);


CREATE TABLE enderecos_cliente (
    id SERIAL PRIMARY KEY,
    cpf_cliente CHAR(11), -- FK cliente
    bairro VARCHAR(50),
    cidade VARCHAR(50),
    estado CHAR(2),
    tipo CHAR(1) CHECK (tipo IS NOT NULL AND tipo IN ('R', 'T', 'O')), -- Residencia, Trabalho ou Outro
    CONSTRAINT enderecos_cliente_cpf_cliente_fkey FOREIGN KEY (cpf_cliente) REFERENCES clientes (cpf),
    CONSTRAINT cpf_cliente_valido_chk CHECK (char_length(cpf_cliente) = 11)
);


CREATE TABLE medicamentos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50),
    validade DATE,
    receita BOOLEAN,
    UNIQUE (id, receita)
);


CREATE TABLE vendas (
    id SERIAL PRIMARY KEY,
    medicamento_id INTEGER, -- FK medicamentos
    medicamento_receita BOOLEAN, -- FK medicamentos
    cpf_cliente CHAR(11), -- FK clientes or null
    vendedor_cpf CHAR(11), -- FK func
    vendedor_cargo CHAR(1), -- FK func
    CONSTRAINT vendas_medicamento_fkey FOREIGN KEY (medicamento_id, medicamento_receita) REFERENCES medicamentos (id, receita) ON DELETE RESTRICT,
    CONSTRAINT venda_com_receita_valida_chk CHECK ((cpf_cliente IS NOT NULL AND medicamento_receita IS TRUE) OR (cpf_cliente IS NULL AND medicamento_receita IS FALSE)),
    CONSTRAINT venda_cpf_cliente_fkey FOREIGN KEY (cpf_cliente) REFERENCES clientes (cpf),
    CONSTRAINT vendas_vendedor_cpf_fkey FOREIGN KEY (vendedor_cpf, vendedor_cargo) REFERENCES funcionario (cpf, cargo) ON DELETE RESTRICT,
    CONSTRAINT vendedor_cargo_valido_chk CHECK (vendedor_cargo IN ('V'))
);


CREATE TABLE entregas (
    id SERIAL PRIMARY KEY,
    saida TIMESTAMP,
    entrega TIMESTAMP,
    id_venda INTEGER, -- FK venda
    entregador_cpf CHAR(11) NOT NULL, -- FK func
    entregador_cargo CHAR(1), -- FK func
    id_endereco_cliente INTEGER NOT NULL, -- FK end
    CONSTRAINT id_venda_entregas_fkey FOREIGN KEY (id_venda) REFERENCES vendas (id),
    CONSTRAINT entregas_entregador_cpf_fkey FOREIGN KEY (entregador_cpf, entregador_cargo) REFERENCES funcionario (cpf, cargo),
    CONSTRAINT entregador_cargo_valido_chk CHECK (entregador_cargo IN ('E')),
    CONSTRAINT entregas_id_enderecos_cliente_fkey FOREIGN KEY (id_endereco_cliente) REFERENCES enderecos_cliente (id)
);





-- ADICIONAL / TESTES


-- Sucesso
INSERT INTO funcionario VALUES ('12312312000', 'Gustavo', 'V', null);
INSERT INTO funcionario VALUES ('12312312100', 'Rogério', 'F', null);
INSERT INTO funcionario VALUES ('12312312200', 'Yan', 'E', null);
INSERT INTO funcionario VALUES ('12312312300', 'Higor', 'A', null);
INSERT INTO funcionario VALUES ('12312312400', 'Maria', 'C', null);

INSERT INTO farmacias (nome, tipo, bairro, cidade, estado, gerente_cpf, gerente_cargo) VALUES ('Ideal', 'S', 'Centro', 'CG', 'PB', '12312312300', 'A');

UPDATE funcionario SET id_farmacia = 1 WHERE nome = 'Gustavo';
UPDATE funcionario SET id_farmacia = 1 WHERE nome = 'Rogério';
UPDATE funcionario SET id_farmacia = 1 WHERE nome = 'Yan';
UPDATE funcionario SET id_farmacia = 1 WHERE nome = 'Higor';
UPDATE funcionario SET id_farmacia = 1 WHERE nome = 'Maria';


-- Erro: violates check constraint "funcionario_cargo_check"
INSERT INTO funcionario VALUES ('12312312301', 'André', 'Z', null);

-- Erro: violates unique constraint "funcionario_pkey"
INSERT INTO funcionario VALUES ('12312312300', 'Allan', 'V', null);

-- Erro: violates exclusion constraint "sede_unica"
INSERT INTO farmacias (nome, tipo, bairro, cidade, estado, gerente_cpf, gerente_cargo) VALUES ('Ideal', 'S', 'Prata', 'CG', 'PB', '12312312100', 'F');

-- Erro: violates check constraint "gerente_cargo_valido_chk"
INSERT INTO farmacias (nome, tipo, bairro, cidade, estado, gerente_cpf, gerente_cargo) VALUES ('Ideal', 'F', 'Prata', 'CG', 'PB', '12312312100', 'C');


-- Sucesso
INSERT INTO clientes VALUES ('32132132000', 'Filipe', '2000-05-05');
INSERT INTO clientes VALUES ('32132132100', 'Beatriz', '2000-11-10');
INSERT INTO clientes VALUES ('32132132200', 'Ana', '2000-01-09');

-- Erro: violates check constraint "maior_de_18_anos_chk", usuários < 18 anos não são permitidos
INSERT INTO clientes VALUES ('32132132300', 'Lucia', '2014-01-09');


-- Sucesso
INSERT INTO enderecos_cliente (cpf_cliente, bairro, cidade, estado, tipo) VALUES ('32132132200', 'Residencial ABC', 'CG', 'PB', 'R');
INSERT INTO enderecos_cliente (cpf_cliente, bairro, cidade, estado, tipo) VALUES ('32132132200', 'Empresarial BCD', 'Campina Grande', 'PB', 'T');
INSERT INTO enderecos_cliente (cpf_cliente, bairro, cidade, estado, tipo) VALUES ('32132132200', 'Casa de Fulano', 'CG', 'PB', 'O');

-- Erro: violates check constraint "enderecos_cliente_tipo_check", tipo de endereço só pode ser 'R', 'T' ou 'O'
INSERT INTO enderecos_cliente (cpf_cliente, bairro, cidade, estado, tipo) VALUES ('32132132200', 'Casa de Ciclano', 'CG', 'PB', 'H');

-- Erro: violates foreign key constraint "enderecos_cliente_cpf_cliente_fkey", cpf não cadastrado na tabela de clientes
INSERT INTO enderecos_cliente (cpf_cliente, bairro, cidade, estado, tipo) VALUES ('12332132200', 'Casa de Fulano', 'CG', 'PB', 'O');


-- Sucesso
INSERT INTO medicamentos (nome, validade, receita) VALUES ('Dipirona', '2024-12-31', FALSE);
INSERT INTO medicamentos (nome, validade, receita) VALUES ('Antibiótico', '2025-06-30', TRUE);

-- Sucesso
INSERT INTO vendas (medicamento_id, medicamento_receita, cpf_cliente, vendedor_cpf, vendedor_cargo) VALUES (2, TRUE, '32132132100', '12312312000', 'V');
INSERT INTO vendas (medicamento_id, medicamento_receita, cpf_cliente, vendedor_cpf, vendedor_cargo) VALUES (1, FALSE, NULL, '12312312000', 'V');

-- Erro: violates foreign key constraint "vendas_vendedor_cpf_fkey", cpf não corresponde ao de um vendedor
INSERT INTO vendas (medicamento_id, medicamento_receita, cpf_cliente, vendedor_cpf, vendedor_cargo) VALUES (2, TRUE, '32132132100', '12312312100', 'V');

-- Erro: violates check constraint "vendedor_cargo_valido_chk", cargo incorreto para uma venda
INSERT INTO vendas (medicamento_id, medicamento_receita, cpf_cliente, vendedor_cpf, vendedor_cargo) VALUES (2, TRUE, '32132132100', '12312311200', 'F');

-- Erro: violates check constraint "venda_com_receita_valida_chk", venda de medicamento com receita para cliente não cadastrado
INSERT INTO vendas (medicamento_id, medicamento_receita, cpf_cliente, vendedor_cpf, vendedor_cargo) VALUES (2, TRUE, null, '12312312000', 'V');

-- Erro: violates foreign key constraint "venda_cpf_cliente_fkey", cpf do cliente inexistente
INSERT INTO vendas (medicamento_id, medicamento_receita, cpf_cliente, vendedor_cpf, vendedor_cargo) VALUES (2, TRUE, '12332132100', '12312311200', 'V');


-- Sucesso
INSERT INTO entregas (saida, entrega, id_venda, entregador_cpf, entregador_cargo, id_endereco_cliente) VALUES ('2024-07-29 10:00:00', '2024-07-29 10:30:11', 1, '12312312200', 'E', 1);

-- Erro: violates foreign key constraint "entregas_entregador_cpf_fkey", cpf de um funcionário que não é entregador
INSERT INTO entregas (saida, entrega, id_venda, entregador_cpf, entregador_cargo, id_endereco_cliente) VALUES ('2024-07-29 20:00:00', '2024-07-29 20:40:06', 1, '12312312300', 'E', 1);

-- Erro: violates check constraint "entregador_cargo_valido_chk", o cargo não é de um entregador
INSERT INTO entregas (saida, entrega, id_venda, entregador_cpf, entregador_cargo, id_endereco_cliente) VALUES ('2024-07-29 10:00:00', '2024-07-29 10:30:11', 1, '12312312200', 'F', 1);

-- Erro: violates foreign key constraint "entregas_id_enderecos_cliente_fkey", endereço não cadastrado
INSERT INTO entregas (saida, entrega, id_venda, entregador_cpf, entregador_cargo, id_endereco_cliente) VALUES ('2024-07-29 10:00:00', '2024-07-29 10:30:11', 1, '12312312200', 'E', 0);



-- Erro: violates foreign key constraint "venda_cpf_cliente_fkey" on table "vendas", devido à restrição de chave estrangeira
-- DETAIL:  Key (cpf)=(32132132100) is still referenced from table "vendas"
DELETE FROM clientes WHERE cpf = '32132132100';

-- Erro: violates foreign key constraint "vendas_vendedor_cpf_fkey" on table "vendas", devido à restrição de chave estrangeira
-- DETAIL:  Key (cpf, cargo)=(12312312000, V) is still referenced from table "vendas"
DELETE FROM funcionario WHERE cpf = '12312312000';

-- Erro: violates foreign key constraint "vendas_medicamento_fkey" on table "vendas", devido à restrição de chave estrangeira
-- DETAIL:  Key (id, receita)=(1, f) is still referenced from table "vendas"
DELETE FROM medicamentos WHERE id = 1;


-- Erro: violates foreign key constraint "funcionario_id_farmacia_fkey" on table "funcionario", devido à restrição de chave estrangeira
-- DETAIL:  Key (id)=(1) is still referenced from table "funcionario"
DELETE FROM farmacias WHERE id = 1;

-- Erro: violates foreign key constraint "entregas_id_enderecos_cliente_fkey" on table "entregas", devido à restrição de chave estrangeira
-- DETAIL:  Key (id)=(1) is still referenced from table "entregas"
DELETE FROM enderecos_cliente WHERE id = 1;