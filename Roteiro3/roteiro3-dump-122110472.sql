--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3 (Debian 15.3-1.pgdg120+1)
-- Dumped by pg_dump version 15.4 (Ubuntu 15.4-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_vendedor_cpf_fkey;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_medicamento_fkey;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT venda_cpf_cliente_fkey;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT id_venda_entregas_fkey;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_id_farmacia_fkey;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT farmacias_gerente_fkey;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT entregas_id_enderecos_cliente_fkey;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT entregas_entregador_cpf_fkey;
ALTER TABLE ONLY public.enderecos_cliente DROP CONSTRAINT enderecos_cliente_cpf_cliente_fkey;
ALTER TABLE ONLY public.vendas DROP CONSTRAINT vendas_pkey;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT sede_unica;
ALTER TABLE ONLY public.medicamentos DROP CONSTRAINT medicamentos_pkey;
ALTER TABLE ONLY public.medicamentos DROP CONSTRAINT medicamentos_id_receita_unique;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_pkey;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_cpf_cargo_uk;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT farmacias_pkey;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT farmacias_bairro_key;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT entregas_pkey;
ALTER TABLE ONLY public.enderecos_cliente DROP CONSTRAINT enderecos_cliente_pkey;
ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_pkey;
ALTER TABLE public.vendas ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.medicamentos ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.farmacias ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.entregas ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.enderecos_cliente ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE public.vendas_id_seq;
DROP TABLE public.vendas;
DROP SEQUENCE public.medicamentos_id_seq;
DROP TABLE public.medicamentos;
DROP TABLE public.funcionario;
DROP SEQUENCE public.farmacias_id_seq;
DROP TABLE public.farmacias;
DROP SEQUENCE public.entregas_id_seq;
DROP TABLE public.entregas;
DROP SEQUENCE public.enderecos_cliente_id_seq;
DROP TABLE public.enderecos_cliente;
DROP TABLE public.clientes;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: clientes; Type: TABLE; Schema: public; Owner: anandavv
--

CREATE TABLE public.clientes (
    cpf character(11) NOT NULL,
    nome character varying(255),
    data_nasc date,
    CONSTRAINT cpf_valido_chk CHECK ((char_length(cpf) = 11)),
    CONSTRAINT maior_de_18_anos_chk CHECK ((data_nasc <= (CURRENT_DATE - '18 years'::interval)))
);


ALTER TABLE public.clientes OWNER TO anandavv;

--
-- Name: enderecos_cliente; Type: TABLE; Schema: public; Owner: anandavv
--

CREATE TABLE public.enderecos_cliente (
    id integer NOT NULL,
    cpf_cliente character(11),
    bairro character varying(50),
    cidade character varying(50),
    estado character(2),
    tipo character(1),
    CONSTRAINT cpf_cliente_valido_chk CHECK ((char_length(cpf_cliente) = 11)),
    CONSTRAINT enderecos_cliente_tipo_check CHECK (((tipo IS NOT NULL) AND (tipo = ANY (ARRAY['R'::bpchar, 'T'::bpchar, 'O'::bpchar]))))
);


ALTER TABLE public.enderecos_cliente OWNER TO anandavv;

--
-- Name: enderecos_cliente_id_seq; Type: SEQUENCE; Schema: public; Owner: anandavv
--

CREATE SEQUENCE public.enderecos_cliente_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.enderecos_cliente_id_seq OWNER TO anandavv;

--
-- Name: enderecos_cliente_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anandavv
--

ALTER SEQUENCE public.enderecos_cliente_id_seq OWNED BY public.enderecos_cliente.id;


--
-- Name: entregas; Type: TABLE; Schema: public; Owner: anandavv
--

CREATE TABLE public.entregas (
    id integer NOT NULL,
    saida timestamp without time zone,
    entrega timestamp without time zone,
    id_venda integer,
    entregador_cpf character(11) NOT NULL,
    entregador_cargo character(1),
    id_endereco_cliente integer NOT NULL,
    CONSTRAINT entregador_cargo_valido_chk CHECK ((entregador_cargo = 'E'::bpchar))
);


ALTER TABLE public.entregas OWNER TO anandavv;

--
-- Name: entregas_id_seq; Type: SEQUENCE; Schema: public; Owner: anandavv
--

CREATE SEQUENCE public.entregas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.entregas_id_seq OWNER TO anandavv;

--
-- Name: entregas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anandavv
--

ALTER SEQUENCE public.entregas_id_seq OWNED BY public.entregas.id;


--
-- Name: farmacias; Type: TABLE; Schema: public; Owner: anandavv
--

CREATE TABLE public.farmacias (
    id integer NOT NULL,
    nome character varying(50),
    tipo character(1),
    bairro character varying(50),
    cidade character varying(50),
    estado public.estado,
    gerente_cpf character(11),
    gerente_cargo character(1),
    CONSTRAINT farmacias_tipo_check CHECK ((tipo = ANY (ARRAY['S'::bpchar, 'F'::bpchar]))),
    CONSTRAINT gerente_cargo_valido_chk CHECK ((gerente_cargo = ANY (ARRAY['F'::bpchar, 'A'::bpchar])))
);


ALTER TABLE public.farmacias OWNER TO anandavv;

--
-- Name: farmacias_id_seq; Type: SEQUENCE; Schema: public; Owner: anandavv
--

CREATE SEQUENCE public.farmacias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.farmacias_id_seq OWNER TO anandavv;

--
-- Name: farmacias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anandavv
--

ALTER SEQUENCE public.farmacias_id_seq OWNED BY public.farmacias.id;


--
-- Name: funcionario; Type: TABLE; Schema: public; Owner: anandavv
--

CREATE TABLE public.funcionario (
    cpf character(11) NOT NULL,
    nome character varying(255),
    cargo character(1),
    id_farmacia integer,
    CONSTRAINT cpf_valido_chk CHECK ((char_length(cpf) = 11)),
    CONSTRAINT funcionario_cargo_check CHECK (((cargo IS NOT NULL) AND (cargo = ANY (ARRAY['F'::bpchar, 'V'::bpchar, 'E'::bpchar, 'C'::bpchar, 'A'::bpchar]))))
);


ALTER TABLE public.funcionario OWNER TO anandavv;

--
-- Name: medicamentos; Type: TABLE; Schema: public; Owner: anandavv
--

CREATE TABLE public.medicamentos (
    id integer NOT NULL,
    nome character varying(50),
    validade date,
    receita boolean
);


ALTER TABLE public.medicamentos OWNER TO anandavv;

--
-- Name: medicamentos_id_seq; Type: SEQUENCE; Schema: public; Owner: anandavv
--

CREATE SEQUENCE public.medicamentos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.medicamentos_id_seq OWNER TO anandavv;

--
-- Name: medicamentos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anandavv
--

ALTER SEQUENCE public.medicamentos_id_seq OWNED BY public.medicamentos.id;


--
-- Name: vendas; Type: TABLE; Schema: public; Owner: anandavv
--

CREATE TABLE public.vendas (
    id integer NOT NULL,
    medicamento_id integer,
    medicamento_receita boolean,
    cpf_cliente character(11),
    vendedor_cpf character(11),
    vendedor_cargo character(1),
    CONSTRAINT venda_com_receita_valida_chk CHECK ((((cpf_cliente IS NOT NULL) AND (medicamento_receita IS TRUE)) OR ((cpf_cliente IS NULL) AND (medicamento_receita IS FALSE)))),
    CONSTRAINT vendedor_cargo_valido_chk CHECK ((vendedor_cargo = 'V'::bpchar))
);


ALTER TABLE public.vendas OWNER TO anandavv;

--
-- Name: vendas_id_seq; Type: SEQUENCE; Schema: public; Owner: anandavv
--

CREATE SEQUENCE public.vendas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vendas_id_seq OWNER TO anandavv;

--
-- Name: vendas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: anandavv
--

ALTER SEQUENCE public.vendas_id_seq OWNED BY public.vendas.id;


--
-- Name: enderecos_cliente id; Type: DEFAULT; Schema: public; Owner: anandavv
--

ALTER TABLE ONLY public.enderecos_cliente ALTER COLUMN id SET DEFAULT nextval('public.enderecos_cliente_id_seq'::regclass);


--
-- Name: entregas id; Type: DEFAULT; Schema: public; Owner: anandavv
--

ALTER TABLE ONLY public.entregas ALTER COLUMN id SET DEFAULT nextval('public.entregas_id_seq'::regclass);


--
-- Name: farmacias id; Type: DEFAULT; Schema: public; Owner: anandavv
--

ALTER TABLE ONLY public.farmacias ALTER COLUMN id SET DEFAULT nextval('public.farmacias_id_seq'::regclass);


--
-- Name: medicamentos id; Type: DEFAULT; Schema: public; Owner: anandavv
--

ALTER TABLE ONLY public.medicamentos ALTER COLUMN id SET DEFAULT nextval('public.medicamentos_id_seq'::regclass);


--
-- Name: vendas id; Type: DEFAULT; Schema: public; Owner: anandavv
--

ALTER TABLE ONLY public.vendas ALTER COLUMN id SET DEFAULT nextval('public.vendas_id_seq'::regclass);


--
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: anandavv
--

INSERT INTO public.clientes (cpf, nome, data_nasc) VALUES ('32132132000', 'Filipe', '2000-05-05');
INSERT INTO public.clientes (cpf, nome, data_nasc) VALUES ('32132132100', 'Beatriz', '2000-11-10');
INSERT INTO public.clientes (cpf, nome, data_nasc) VALUES ('32132132200', 'Ana', '2000-01-09');


--
-- Data for Name: enderecos_cliente; Type: TABLE DATA; Schema: public; Owner: anandavv
--

INSERT INTO public.enderecos_cliente (id, cpf_cliente, bairro, cidade, estado, tipo) VALUES (1, '32132132200', 'Residencial ABC', 'CG', 'PB', 'R');
INSERT INTO public.enderecos_cliente (id, cpf_cliente, bairro, cidade, estado, tipo) VALUES (2, '32132132200', 'Empresarial BCD', 'Campina Grande', 'PB', 'T');
INSERT INTO public.enderecos_cliente (id, cpf_cliente, bairro, cidade, estado, tipo) VALUES (3, '32132132200', 'Casa de Fulano', 'CG', 'PB', 'O');


--
-- Data for Name: entregas; Type: TABLE DATA; Schema: public; Owner: anandavv
--

INSERT INTO public.entregas (id, saida, entrega, id_venda, entregador_cpf, entregador_cargo, id_endereco_cliente) VALUES (1, '2024-07-29 10:00:00', '2024-07-29 10:30:11', 1, '12312312200', 'E', 1);


--
-- Data for Name: farmacias; Type: TABLE DATA; Schema: public; Owner: anandavv
--

INSERT INTO public.farmacias (id, nome, tipo, bairro, cidade, estado, gerente_cpf, gerente_cargo) VALUES (1, 'Ideal', 'S', 'Centro', 'CG', 'PB', '12312312300', 'A');


--
-- Data for Name: funcionario; Type: TABLE DATA; Schema: public; Owner: anandavv
--

INSERT INTO public.funcionario (cpf, nome, cargo, id_farmacia) VALUES ('12312312300', 'Higor', 'A', 1);
INSERT INTO public.funcionario (cpf, nome, cargo, id_farmacia) VALUES ('12312312400', 'Maria', 'C', 1);
INSERT INTO public.funcionario (cpf, nome, cargo, id_farmacia) VALUES ('12312312000', 'Gustavo', 'V', 1);
INSERT INTO public.funcionario (cpf, nome, cargo, id_farmacia) VALUES ('12312312100', 'Rogério', 'F', 1);
INSERT INTO public.funcionario (cpf, nome, cargo, id_farmacia) VALUES ('12312312200', 'Yan', 'E', 1);


--
-- Data for Name: medicamentos; Type: TABLE DATA; Schema: public; Owner: anandavv
--

INSERT INTO public.medicamentos (id, nome, validade, receita) VALUES (1, 'Dipirona', '2024-12-31', false);
INSERT INTO public.medicamentos (id, nome, validade, receita) VALUES (2, 'Antibiótico', '2025-06-30', true);


--
-- Data for Name: vendas; Type: TABLE DATA; Schema: public; Owner: anandavv
--

INSERT INTO public.vendas (id, medicamento_id, medicamento_receita, cpf_cliente, vendedor_cpf, vendedor_cargo) VALUES (1, 2, true, '32132132100', '12312312000', 'V');
INSERT INTO public.vendas (id, medicamento_id, medicamento_receita, cpf_cliente, vendedor_cpf, vendedor_cargo) VALUES (2, 1, false, NULL, '12312312000', 'V');


--
-- Name: enderecos_cliente_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anandavv
--

SELECT pg_catalog.setval('public.enderecos_cliente_id_seq', 5, true);


--
-- Name: entregas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anandavv
--

SELECT pg_catalog.setval('public.entregas_id_seq', 4, true);


--
-- Name: farmacias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anandavv
--

SELECT pg_catalog.setval('public.farmacias_id_seq', 3, true);


--
-- Name: medicamentos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anandavv
--

SELECT pg_catalog.setval('public.medicamentos_id_seq', 2, true);


--
-- Name: vendas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: anandavv
--

SELECT pg_catalog.setval('public.vendas_id_seq', 8, true);


--
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: anandavv
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (cpf);


--
-- Name: enderecos_cliente enderecos_cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: anandavv
--

ALTER TABLE ONLY public.enderecos_cliente
    ADD CONSTRAINT enderecos_cliente_pkey PRIMARY KEY (id);


--
-- Name: entregas entregas_pkey; Type: CONSTRAINT; Schema: public; Owner: anandavv
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT entregas_pkey PRIMARY KEY (id);


--
-- Name: farmacias farmacias_bairro_key; Type: CONSTRAINT; Schema: public; Owner: anandavv
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT farmacias_bairro_key UNIQUE (bairro);


--
-- Name: farmacias farmacias_pkey; Type: CONSTRAINT; Schema: public; Owner: anandavv
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT farmacias_pkey PRIMARY KEY (id);


--
-- Name: funcionario funcionario_cpf_cargo_uk; Type: CONSTRAINT; Schema: public; Owner: anandavv
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_cpf_cargo_uk UNIQUE (cpf, cargo);


--
-- Name: funcionario funcionario_pkey; Type: CONSTRAINT; Schema: public; Owner: anandavv
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_pkey PRIMARY KEY (cpf);


--
-- Name: medicamentos medicamentos_id_receita_unique; Type: CONSTRAINT; Schema: public; Owner: anandavv
--

ALTER TABLE ONLY public.medicamentos
    ADD CONSTRAINT medicamentos_id_receita_unique UNIQUE (id, receita);


--
-- Name: medicamentos medicamentos_pkey; Type: CONSTRAINT; Schema: public; Owner: anandavv
--

ALTER TABLE ONLY public.medicamentos
    ADD CONSTRAINT medicamentos_pkey PRIMARY KEY (id);


--
-- Name: farmacias sede_unica; Type: CONSTRAINT; Schema: public; Owner: anandavv
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT sede_unica EXCLUDE USING gist (nome WITH =) WHERE ((tipo = 'S'::bpchar));


--
-- Name: vendas vendas_pkey; Type: CONSTRAINT; Schema: public; Owner: anandavv
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_pkey PRIMARY KEY (id);


--
-- Name: enderecos_cliente enderecos_cliente_cpf_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: anandavv
--

ALTER TABLE ONLY public.enderecos_cliente
    ADD CONSTRAINT enderecos_cliente_cpf_cliente_fkey FOREIGN KEY (cpf_cliente) REFERENCES public.clientes(cpf);


--
-- Name: entregas entregas_entregador_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: anandavv
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT entregas_entregador_cpf_fkey FOREIGN KEY (entregador_cpf, entregador_cargo) REFERENCES public.funcionario(cpf, cargo);


--
-- Name: entregas entregas_id_enderecos_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: anandavv
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT entregas_id_enderecos_cliente_fkey FOREIGN KEY (id_endereco_cliente) REFERENCES public.enderecos_cliente(id);


--
-- Name: farmacias farmacias_gerente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: anandavv
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT farmacias_gerente_fkey FOREIGN KEY (gerente_cpf, gerente_cargo) REFERENCES public.funcionario(cpf, cargo);


--
-- Name: funcionario funcionario_id_farmacia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: anandavv
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_id_farmacia_fkey FOREIGN KEY (id_farmacia) REFERENCES public.farmacias(id);


--
-- Name: entregas id_venda_entregas_fkey; Type: FK CONSTRAINT; Schema: public; Owner: anandavv
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT id_venda_entregas_fkey FOREIGN KEY (id_venda) REFERENCES public.vendas(id);


--
-- Name: vendas venda_cpf_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: anandavv
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT venda_cpf_cliente_fkey FOREIGN KEY (cpf_cliente) REFERENCES public.clientes(cpf);


--
-- Name: vendas vendas_medicamento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: anandavv
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_medicamento_fkey FOREIGN KEY (medicamento_id, medicamento_receita) REFERENCES public.medicamentos(id, receita) ON DELETE RESTRICT;


--
-- Name: vendas vendas_vendedor_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: anandavv
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_vendedor_cpf_fkey FOREIGN KEY (vendedor_cpf, vendedor_cargo) REFERENCES public.funcionario(cpf, cargo) ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--


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