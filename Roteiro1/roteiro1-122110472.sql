-- QUESTÃO 1 E 2

-- Tabela do automovel: chassi, placa, modelo, marca, ano e o id do seu seguro
CREATE TABLE automovel(
  chassi_do_automovel CHAR(17), -- PK
  placa_do_automovel CHAR(7),
  modelo_do_automovel VARCHAR(50),
  marca_do_automovel VARCHAR(50),
  ano_do_automovel INTEGER
);

-- Tabela do segurado: cpf, nome, telefone, endereço e data de nascimento
CREATE TABLE segurado(
  cpf_do_segurado CHAR(11), -- PK
  nome_do_segurado VARCHAR(255),
  telefone_do_segurado VARCHAR(15),
  endereco_do_segurado VARCHAR(255),
  data_de_nascimento_do_segurado DATE
);

-- Tabela do perito: cpf e nome
CREATE TABLE perito(
  cpf_do_perito CHAR(11), -- PK
  nome_do_perito VARCHAR(255)
);

-- Tabela da oficina: cnpj, nome e endereço
CREATE TABLE oficina(
  cnpj_da_oficina CHAR(14), -- PK
  nome_da_oficina VARCHAR(255),
  endereco_da_oficina VARCHAR(255)
);

-- Tabela do seguro: id, tipo de plano, valor, data de inicio, data de término,
-- segurado que possui o seguro e o automovel segurado
CREATE TABLE seguro(
  id_do_seguro SERIAL, -- PK
  tipo_de_plano_do_seguro VARCHAR(255),
  valor_do_seguro NUMERIC,
  data_de_inicio DATE,
  data_de_termino DATE,
  segurado CHAR(11), -- FK
  automovel CHAR(17) -- FK
);

-- Tabela do sinistro: id, descrição (batida, furto, ...), valor ($$) e o seguro 
-- que se relaciona ao mesmo
CREATE TABLE sinistro(
  id_do_sinistro SERIAL, -- PK
  descricao_do_sinistro VARCHAR(255),
  valor_do_sinistro NUMERIC,
  seguro INTEGER -- FK
);

-- Tabela da perícia: id, relatório, tipo de perda (total ou parcial), nível da perda (%),
-- data de agendamento, data e hora do inicio e fim da pericia, id que referencia o sinistro,
-- cpf do perito que realizou a pericia e cnpj da oficina onde foi realizada
CREATE TABLE pericia(
  id_da_pericia SERIAL, -- PK
  relatorio_da_pericia TEXT,
  tipo_de_perda VARCHAR(20),
  nivel_da_perda INTEGER,
  agendamento_da_pericia DATE,
  inicio_da_pericia TIMESTAMP,
  fim_da_pericia TIMESTAMP,
  sinistro INTEGER, -- FK
  perito CHAR(11), -- FK
  oficina CHAR(14) -- FK
);

-- Tabela do reparo: id, data e hora do reparo e id da pericia que levou ao reparo
CREATE TABLE reparo(
  id_do_reparo SERIAL, -- PK
  data_do_reparo TIMESTAMP,
  pericia INTEGER -- FK
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

-- FK que referencia o segurado daquele seguro
ALTER TABLE seguro ADD CONSTRAINT seguro_segurado_fkey FOREIGN KEY (segurado) REFERENCES segurado(cpf_do_segurado);

-- FK que referencia o seguro que o automovel possui
ALTER TABLE seguro ADD CONSTRAINT seguro_automovel_fkey FOREIGN KEY (automovel) REFERENCES automovel(chassi_do_automovel);

-- FK que referencia o seguro que cobre o sinistro
ALTER TABLE sinistro ADD CONSTRAINT sinistro_seguro_fkey FOREIGN KEY (seguro) REFERENCES seguro(id_do_seguro);

ALTER TABLE pericia ADD CONSTRAINT pericia_sinistro_fkey FOREIGN KEY (sinistro) REFERENCES sinistro(id_do_sinistro);

-- FK que referencia o cpf do perito a pericia
ALTER TABLE pericia ADD CONSTRAINT pericia_perito_fkey FOREIGN KEY (perito) REFERENCES perito(cpf_do_perito);

-- FK que referencia o cnpj da oficina a pericia
ALTER TABLE pericia ADD CONSTRAINT pericia_oficina_fkey FOREIGN KEY (oficina) REFERENCES oficina(cnpj_da_oficina);

-- FK que referencia o id da pericia ao reparo
ALTER TABLE reparo ADD CONSTRAINT reparo_pericia_fkey FOREIGN KEY (pericia) REFERENCES pericia(id_da_pericia);



-- QUESTÃO 5
-- Os atributos NOT NULL deveriam ser as chaves primárias e estrangeiras:

-- Na tabela automovel: chassi_do_automovel (PK)
-- Na tabela segurado: cpf_do_segurado (PK)
-- Na tabela perito: cpf_do_perito (PK)
-- Na tabela oficina: cnpj_da_oficina (PK)
-- Na tabela seguro: id_do_seguro (PK), segurado (FK) e automovel (FK)
-- Na tabela sinistro: id_do_sinistro (PK) e seguro (FK)
-- Na tabela pericia: id_da_pericia (PK), sinistro (FK), perito (FK) e oficina (FK)
-- Na tabela reparo: id_do_reparo (PK), pericia (FK)



-- QUESTÃO 6
-- Exclusão de forma que não ocorra erros por dependências de chaves estrangeiras

DROP TABLE reparo;
DROP TABLE pericia;
DROP TABLE sinistro;
DROP TABLE perito;
DROP TABLE oficina;
DROP TABLE seguro;
DROP TABLE automovel;
DROP TABLE segurado;



-- QUESTÃO 7 E 8
-- Criação de tabelas com suas respectivas chaves primárias e estrangeiras

CREATE TABLE automovel(
  chassi_do_automovel CHAR(17) NOT  NULL PRIMARY KEY,
  placa_do_automovel CHAR(7),
  modelo_do_automovel VARCHAR(50),
  marca_do_automovel VARCHAR(50),
  ano_do_automovel INTEGER
);

CREATE TABLE segurado(
  cpf_do_segurado CHAR(11) NOT  NULL PRIMARY KEY,
  nome_do_segurado VARCHAR(255),
  telefone_do_segurado VARCHAR(15),
  endereco_do_segurado VARCHAR(255),
  data_de_nascimento_do_segurado DATE
);

CREATE TABLE seguro(
  id_do_seguro SERIAL NOT  NULL PRIMARY KEY,
  tipo_de_plano_do_seguro VARCHAR(255),
  valor_do_seguro NUMERIC,
  data_de_inicio DATE,
  data_de_termino DATE,
  segurado CHAR(11),
  automovel CHAR(17),
  CONSTRAINT seguro_segurado_fkey FOREIGN KEY (segurado) REFERENCES segurado(cpf_do_segurado),
  CONSTRAINT seguro_automovel_fkey FOREIGN KEY (automovel) REFERENCES automovel(chassi_do_automovel)
);

CREATE TABLE perito(
  cpf_do_perito CHAR(11) NOT  NULL PRIMARY KEY,
  nome_do_perito VARCHAR(255)
);

CREATE TABLE oficina(
  cnpj_da_oficina CHAR(14) NOT  NULL PRIMARY KEY,
  nome_da_oficina VARCHAR(255),
  endereco_da_oficina VARCHAR(255)
);

CREATE TABLE sinistro(
  id_do_sinistro SERIAL NOT  NULL PRIMARY KEY,
  descricao_do_sinistro VARCHAR(255),
  valor_do_sinistro NUMERIC,
  seguro INTEGER,
  CONSTRAINT sinistro_seguro_fkey FOREIGN KEY (seguro) REFERENCES seguro(id_do_seguro)
);

CREATE TABLE pericia(
  id_da_pericia SERIAL NOT  NULL PRIMARY KEY,
  relatorio_da_pericia TEXT,
  tipo_de_perda VARCHAR(20),
  nivel_da_perda INTEGER,
  agendamento_da_pericia DATE,
  inicio_da_pericia TIMESTAMP,
  fim_da_pericia TIMESTAMP,
  sinistro INTEGER,
  perito CHAR(11),
  oficina CHAR(14),
  CONSTRAINT pericia_sinistro_fkey FOREIGN KEY (sinistro) REFERENCES sinistro(id_do_sinistro),
  CONSTRAINT pericia_perito_fkey FOREIGN KEY (perito) REFERENCES perito(cpf_do_perito),
  CONSTRAINT pericia_oficina_fkey FOREIGN KEY (oficina) REFERENCES oficina(cnpj_da_oficina)
);

CREATE TABLE reparo(
  id_do_reparo SERIAL NOT  NULL PRIMARY KEY,
  data_do_reparo TIMESTAMP,
  pericia INTEGER,
  CONSTRAINT reparo_pericia_fkey FOREIGN KEY (pericia) REFERENCES pericia(id_da_pericia)
);



-- QUESTÃO 9
-- Re-exclusão de forma que não ocorra erros por dependências de chaves estrangeiras

DROP TABLE reparo;
DROP TABLE pericia;
DROP TABLE sinistro;
DROP TABLE perito;
DROP TABLE oficina;
DROP TABLE seguro;
DROP TABLE segurado;
DROP TABLE automovel;



-- QUESTÃO 10: SUGESTÕES DE TABELAS
-- Criaria uma tabela para guardar informações que definem o preço do seguro,
-- que definem os tipos de sinistro, ...