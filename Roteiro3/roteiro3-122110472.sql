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
    CONSTRAINT funcionario_id_farmacia_fkey FOREIGN KEY (id_farmacia) REFERENCES farmacias (id),
    CONSTRAINT cpf_valido_chk CHECK (char_length(cpf) = 11)
);


CREATE TABLE medicamentos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50),
    validade DATE,
    receita BOOLEAN
);


CREATE TABLE vendas (
    id SERIAL PRIMARY KEY,
    medicamento_id INTEGER, -- FK medicamentos
    medicamento_receita BOOLEAN, -- FK medicamentos
    cpf_cliente CHAR(11), -- FK clientes or null
    vendedor_cpf CHAR(11), -- FK func
    vendedor_cargo CHAR(1), -- FK func
    CONSTRAINT vendas_medicamento_fkey FOREIGN KEY (medicamento_id, medicamento_receita) REFERENCES medicamentos (id, receita) ON DELETE RESTRICT,
    CONSTRAINT venda_com_receita_valida_chk CHECK (cpf_cliente IS NOT NULL AND medicamento_receita IS TRUE),
    CONSTRAINT venda_cpf_cliente_fkey FOREIGN KEY (cpf_cliente) REFERENCES clientes (cpf),
    CONSTRAINT vendas_vendedor_cpf_fkey FOREIGN KEY (vendedor_cpf, vendedor_cargo) REFERENCES funcionario (cpf, cargo) ON DELETE RESTRIC,
    CONSTRAINT vendedor_cargo_valido_chk CHECK (vendedor_cargo IN ('V'))
);


CREATE TABLE entregas (
    id SERIAL PRIMARY KEY,
    entregador_cpf CHAR(11) NOT NULL, -- FK func
    entregador_cargo CHAR(1), -- FK func
    id_endereco_cliente INTEGER NOT NULL, -- FK end
    CONSTRAINT entregas_entregador_cpf_fkey FOREIGN KEY (entregador_cpf, entregador_cargo) REFERENCES funcionario (cpf, cargo),
    CONSTRAINT entregador_cargo_valido_chk CHECK (entregador_cargo IN ('E')),
    CONSTRAINT entregas_id_enderecos_cliente_fkey FOREIGN KEY (id_endereco_cliente) REFERENCES enderecos_cliente (id)
);


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