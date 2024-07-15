-- QUESTÃO 1 E 2

-- Tabela do automovel: chassi, placa, modelo, marca e ano
CREATE TABLE automovel(
  chassi_do_automovel CHAR(17), -- PK
  placa_do_automovel CHAR(7),
  modelo_do_automovel VARCHAR(50),
  marca_do_automovel VARCHAR(50),
  ano_do_automovel INTEGER
);

-- Tabela do segurado: nome, cpf, telefone, endereço, data de nascimento, chassi
-- do automovel segurado, id do seguro escolhido, data de vinculo e data de 
-- vencimento do seguro
CREATE TABLE segurado(
  nome_do_segurado VARCHAR(255),
  cpf_do_segurado CHAR(11), -- PK
  telefone_do_segurado VARCHAR(15),
  endereco_do_segurado VARCHAR(255),
  data_de_nascimento_do_segurado DATE,
  automovel_segurado CHAR(17), -- FK
  id_do_seguro SERIAL, -- FK
  data_de_vinculo DATE,
  data_de_termino DATE
);

-- Tabela do perito: cpf, nome e oficina na qual ele presta o serviço
CREATE TABLE perito(
  cpf_do_perito CHAR(11), -- PK
  nome_do_perito VARCHAR(255),
  cnpj_da_oficina CHAR(14) -- FK
);

-- Tabela da oficina: cnpj, nome e endereço
CREATE TABLE oficina(
  cnpj_da_oficina CHAR(14), -- PK
  nome_da_oficina VARCHAR(255),
  endereco_da_oficina VARCHAR(255)
);

-- Tabela do seguro: id, tipo de plano e valor
CREATE TABLE seguro(
  id_do_seguro SERIAL, -- PK
  tipo_de_plano_do_seguro VARCHAR(255),
  valor_do_seguro NUMERIC
);

-- Tabela do sinistro: id, descrição (batida, furto, ...) e valor que ele agrega 
-- ao seguro
CREATE TABLE sinistro(
  id_do_sinistro SERIAL, -- PK
  descricao_do_sinistro VARCHAR(255),
  valor_do_sinistro NUMERIC
);

-- Tabela da perícia: id, cpf do perito, cnpj da oficina que foi realizada a 
-- pericia, chassi do automovel periciado, tipo de perda (total ou parcial),
-- relatório e nível da perda (%)
CREATE TABLE pericia(
  id_da_pericia SERIAL, -- PK
  cpf_do_perito CHAR(11), -- FK
  cnpj_da_oficina CHAR(14), -- FK
  automovel_periciado CHAR(17), -- FK
  tipo_de_perda VARCHAR(20),
  relatorio_da_pericia TEXT,
  nivel_da_perda INTEGER
);

-- Tabela do reparo: id, chassi do automovel reparado, cnpj da oficina onde foi
-- feito o reparo, id da pericia que levou ao reparo, descrição do sinistro que
-- vai ser reparado e a data e hora do reparo
CREATE TABLE reparo(
  id_do_reparo SERIAL, -- PK
  automovel_reparado CHAR(17), -- FK
  cnpj_da_oficina CHAR(14), -- FK
  id_da_pericia SERIAL, -- FK
  id_do_sinistro SERIAL, -- FK
  data_do_reparo TIMESTAMP
);



-- QUESTÃO 3: Definindo as chaves primárias de cada tabela

ALTER TABLE automovel ADD PRIMARY KEY (chassi_do_automovel);
ALTER TABLE segurado ADD PRIMARY KEY (cpf_do_segurado);
ALTER TABLE perito ADD PRIMARY KEY (cpf_do_perito);
ALTER TABLE oficina ADD PRIMARY KEY (cnpj_da_oficina);
ALTER TABLE seguro ADD PRIMARY KEY (id_do_seguro);
ALTER TABLE sinistro ADD PRIMARY KEY (id_do_sinistro);
ALTER TABLE pericia ADD PRIMARY KEY (id_da_pericia);
ALTER TABLE reparo ADD PRIMARY KEY (id_do_reparo);



-- QUESTÃO 4

-- FK que referencia o chassi do automovel ao segurado
ALTER TABLE segurado ADD CONSTRAINT segurado_automovel_segurado_fkey FOREIGN KEY (automovel_segurado) REFERENCES automovel(chassi_do_automovel);

-- FK que referencia o id do seguro ao segurado
ALTER TABLE segurado ADD CONSTRAINT segurado_id_do_seguro_fkey FOREIGN KEY (id_do_seguro) REFERENCES seguro(id_do_seguro);

-- FK que referencia o cnpj da oficina ao perito
ALTER TABLE perito ADD CONSTRAINT perito_cnpj_da_oficina_fkey FOREIGN KEY (cnpj_da_oficina) REFERENCES oficina(cnpj_da_oficina);

-- FK que referencia o cpf do perito a pericia
ALTER TABLE pericia ADD CONSTRAINT pericia_cpf_do_perito_fkey FOREIGN KEY (cpf_do_perito) REFERENCES perito(cpf_do_perito);

-- FK que referencia o cnpj da oficina a pericia
ALTER TABLE pericia ADD CONSTRAINT pericia_cnpj_da_oficina_fkey FOREIGN KEY (cnpj_da_oficina) REFERENCES oficina(cnpj_da_oficina);

-- FK que referencia o chassi do automovel a pericia
ALTER TABLE pericia ADD CONSTRAINT pericia_automovel_periciado_fkey FOREIGN KEY (automovel_periciado) REFERENCES automovel(chassi_do_automovel);

-- FK que referencia o chassi do automovel ao reparo
ALTER TABLE reparo ADD CONSTRAINT reparo_automovel_reparado_fkey FOREIGN KEY (automovel_reparado) REFERENCES automovel(chassi_do_automovel);

-- FK que referencia o cnpj da oficina ao reparo
ALTER TABLE reparo ADD CONSTRAINT reparo_cnpj_da_oficina_fkey FOREIGN KEY (cnpj_da_oficina) REFERENCES oficina(cnpj_da_oficina);

-- FK que referencia o id da pericia ao reparo
ALTER TABLE reparo ADD CONSTRAINT reparo_id_da_pericia_fkey FOREIGN KEY (id_da_pericia) REFERENCES pericia(id_da_pericia);

-- FK que referencia o sinistro ao reparo
ALTER TABLE reparo ADD CONSTRAINT reparo_id_do_sinistro_fkey FOREIGN KEY (id_do_sinistro) REFERENCES sinistro(id_do_sinistro);



-- QUESTÃO 5
-- Os atributos NOT NULL deveriam ser as chaves primárias e estrangeiras:

-- Na tabela automovel: chassi_do_automovel (PK)
-- Na tabela segurado: cpf_do_segurado (PK), automovel_segurado (FK) e id_do_seguro (FK)
-- Na tabela perito: cpf_do_perito (PK) e cnpj_da_oficina (FK)
-- Na tabela oficina: cnpj_da_oficina (PK)
-- Na tabela seguro: id_do_seguro (PK)
-- Na tabela sinistro: id_do_sinistro (PK)
-- Na tabela pericia: id_da_pericia (PK), cpf_do_perito (FK), cnpj_da_oficina (FK),
-- e automovel_periciado (FK)
-- Na tabela reparo: id_do_reparo (PK), automovel_reparado (FK), cnpj_da_oficina (FK),
-- id_da_pericia (FK) e descricao_do_sinistro



-- QUESTÃO 6
-- Exclusão de forma que não ocorra erros por dependências de chaves estrangeiras

DROP TABLE reparo;
DROP TABLE pericia;
DROP TABLE perito;
DROP TABLE oficina;
DROP TABLE sinistro;
DROP TABLE segurado;
DROP TABLE seguro;
DROP TABLE automovel;



-- QUESTÃO 7 E 8
-- Criação de tabelas com suas respectivas chaves primárias e estrangeiras

CREATE TABLE automovel(
  chassi_do_automovel CHAR(17) NOT NULL PRIMARY KEY, 
  placa_do_automovel CHAR(7),
  modelo_do_automovel VARCHAR(50),
  marca_do_automovel VARCHAR(50),
  ano_do_automovel INTEGER
);

CREATE TABLE oficina(
  cnpj_da_oficina CHAR(14) NOT NULL PRIMARY KEY,
  nome_da_oficina VARCHAR(255),
  endereco_da_oficina VARCHAR(255)
);

CREATE TABLE seguro(
  id_do_seguro SERIAL NOT NULL PRIMARY KEY,
  tipo_de_plano_do_seguro VARCHAR(255),
  valor_do_seguro NUMERIC
);

CREATE TABLE sinistro(
  id_do_sinistro SERIAL NOT NULL PRIMARY KEY,
  descricao_do_sinistro VARCHAR(255),
  valor_do_sinistro NUMERIC
);

CREATE TABLE segurado(
  nome_do_segurado VARCHAR(255),
  cpf_do_segurado CHAR(11) NOT NULL PRIMARY KEY,
  telefone_do_segurado VARCHAR(15),
  endereco_do_segurado VARCHAR(255),
  data_de_nascimento_do_segurado DATE,
  automovel_segurado CHAR(17) NOT NULL,
  id_do_seguro SERIAL NOT NULL,
  data_de_vinculo DATE,
  data_de_termino DATE,
  CONSTRAINT segurado_automovel_segurado_fkey FOREIGN KEY (automovel_segurado) REFERENCES automovel(chassi_do_automovel),
  CONSTRAINT segurado_id_do_seguro_fkey FOREIGN KEY (id_do_seguro) REFERENCES seguro(id_do_seguro)
);

CREATE TABLE perito(
  cpf_do_perito CHAR(11) NOT NULL PRIMARY KEY,
  nome_do_perito VARCHAR(255),
  cnpj_da_oficina CHAR(14) NOT NULL,
  CONSTRAINT perito_cnpj_da_oficina_fkey FOREIGN KEY (cnpj_da_oficina) REFERENCES oficina(cnpj_da_oficina)
);

CREATE TABLE pericia(
  id_da_pericia SERIAL NOT NULL PRIMARY KEY,
  cpf_do_perito CHAR(11) NOT NULL,
  cnpj_da_oficina CHAR(14) NOT NULL,
  automovel_periciado CHAR(17) NOT NULL,
  tipo_de_perda VARCHAR(20),
  relatorio_da_pericia TEXT,
  nivel_da_perda INTEGER,
  CONSTRAINT pericia_cpf_do_perito_fkey FOREIGN KEY (cpf_do_perito) REFERENCES perito(cpf_do_perito),
  CONSTRAINT pericia_cnpj_da_oficina_fkey FOREIGN KEY (cnpj_da_oficina) REFERENCES oficina(cnpj_da_oficina),
  CONSTRAINT pericia_automovel_periciado_fkey FOREIGN KEY (automovel_periciado) REFERENCES automovel(chassi_do_automovel)
);

CREATE TABLE reparo(
  id_do_reparo SERIAL NOT NULL PRIMARY KEY,
  automovel_reparado CHAR(17) NOT NULL,
  cnpj_da_oficina CHAR(14) NOT NULL,
  id_da_pericia SERIAL NOT NULL,
  id_do_sinistro SERIAL NOT NULL,
  data_do_reparo TIMESTAMP,
  CONSTRAINT reparo_automovel_reparado_fkey FOREIGN KEY (automovel_reparado) REFERENCES automovel(chassi_do_automovel),
  CONSTRAINT reparo_cnpj_da_oficina_fkey FOREIGN KEY (cnpj_da_oficina) REFERENCES oficina(cnpj_da_oficina),
  CONSTRAINT reparo_id_da_pericia_fkey FOREIGN KEY (id_da_pericia) REFERENCES pericia(id_da_pericia),
  CONSTRAINT reparo_id_do_sinistro_fkey FOREIGN KEY (id_do_sinistro) REFERENCES sinistro(id_do_sinistro)
);



-- QUESTÃO 9
-- Re-exclusão de forma que não ocorra erros por dependências de chaves estrangeiras

DROP TABLE reparo;
DROP TABLE pericia;
DROP TABLE perito;
DROP TABLE segurado;
DROP TABLE sinistro;
DROP TABLE seguro;
DROP TABLE oficina;
DROP TABLE automovel;



-- QUESTÃO 10: SUGESTÕES DE TABELAS
-- Criaria uma tabela para guardar informações que definem o preço do seguro