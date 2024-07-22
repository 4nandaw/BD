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

ALTER TABLE ONLY public.tarefas DROP CONSTRAINT tarefas_funcionario_cpf_fk_set_null;
ALTER TABLE ONLY public.tarefas DROP CONSTRAINT tarefas_pkey;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_pkey;
DROP TABLE public.tarefas;
DROP TABLE public.funcionario;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: funcionario; Type: TABLE; Schema: public; Owner: anandavv
--

CREATE TABLE public.funcionario (
    cpf character(11) NOT NULL,
    data_nasc date NOT NULL,
    nome character varying(255) NOT NULL,
    funcao character varying(11) NOT NULL,
    nivel character(1) NOT NULL,
    superior_cpf character(11),
    CONSTRAINT funcionario_chk_funcao_valida CHECK ((((funcao)::text = 'SUP_LIMPEZA'::text) OR (((funcao)::text = 'LIMPEZA'::text) AND (superior_cpf IS NOT NULL)))),
    CONSTRAINT funcionario_nivel_check CHECK ((nivel = ANY (ARRAY['J'::bpchar, 'P'::bpchar, 'S'::bpchar])))
);


ALTER TABLE public.funcionario OWNER TO anandavv;

--
-- Name: tarefas; Type: TABLE; Schema: public; Owner: anandavv
--

CREATE TABLE public.tarefas (
    id bigint NOT NULL,
    descricao character varying(255) NOT NULL,
    func_resp_cpf character(11),
    prioridade smallint NOT NULL,
    status character(1) NOT NULL,
    CONSTRAINT chk_func_resp_cpf_status CHECK (((status = 'P'::bpchar) OR (func_resp_cpf IS NOT NULL))),
    CONSTRAINT prioridade_chk CHECK ((prioridade = ANY (ARRAY[0, 1, 2, 3, 4, 5]))),
    CONSTRAINT status_chk CHECK ((status = ANY (ARRAY['P'::bpchar, 'E'::bpchar, 'C'::bpchar]))),
    CONSTRAINT tarefas_chk_cpf_valido CHECK ((length(func_resp_cpf) = 11)),
    CONSTRAINT tarefas_chk_func_resp_cpf CHECK (((func_resp_cpf IS NOT NULL) OR (status = 'P'::bpchar))),
    CONSTRAINT tarefas_chk_func_status CHECK (((status = 'P'::bpchar) OR (func_resp_cpf IS NOT NULL)))
);


ALTER TABLE public.tarefas OWNER TO anandavv;

--
-- Data for Name: funcionario; Type: TABLE DATA; Schema: public; Owner: anandavv
--

INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678913', '2000-01-11', 'Ana', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678914', '1999-02-12', 'Marcos Silva', 'LIMPEZA', 'P', '12345678913');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678915', '1998-03-13', 'Carlos Oliveira', 'LIMPEZA', 'J', '12345678913');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678916', '1997-04-14', 'Fernanda Lima', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678917', '1996-05-15', 'Julia Ferreira', 'LIMPEZA', 'P', '12345678916');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678918', '1995-06-16', 'Rafael Costa', 'LIMPEZA', 'J', '12345678916');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678919', '1994-07-17', 'Lucas Martins', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678920', '1993-08-18', 'Patricia Mendes', 'LIMPEZA', 'P', '12345678919');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678921', '1992-09-19', 'Gustavo Almeida', 'LIMPEZA', 'J', '12345678919');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678923', '1984-07-15', 'Sandra Ribeiro', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678924', '1986-02-20', 'Ricardo Santos', 'LIMPEZA', 'J', '12345678923');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678925', '1987-05-30', 'Maria Fernanda', 'LIMPEZA', 'P', '12345678923');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678926', '1989-12-10', 'João Paulo', 'LIMPEZA', 'J', '12345678923');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678927', '1991-09-08', 'Aline Costa', 'LIMPEZA', 'P', '12345678923');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678922', '1991-10-20', 'Mariana Duarte', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('32323232955', '1999-02-12', 'Livia Souza', 'SUP_LIMPEZA', 'P', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('98765432111', '2000-05-01', 'Leandro Torres', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('98765432122', '2000-09-27', 'Lucas Alves', 'LIMPEZA', 'S', '32323232955');


--
-- Data for Name: tarefas; Type: TABLE DATA; Schema: public; Owner: anandavv
--

INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483646, 'limpar chão do corredor central', '98765432111', 0, 'C');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483647, 'limpar janelas da sala 203', '98765432122', 1, 'C');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483630, 'Limpar o tapete', NULL, 1, 'P');


--
-- Name: funcionario funcionario_pkey; Type: CONSTRAINT; Schema: public; Owner: anandavv
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_pkey PRIMARY KEY (cpf);


--
-- Name: tarefas tarefas_pkey; Type: CONSTRAINT; Schema: public; Owner: anandavv
--

ALTER TABLE ONLY public.tarefas
    ADD CONSTRAINT tarefas_pkey PRIMARY KEY (id);


--
-- Name: tarefas tarefas_funcionario_cpf_fk_set_null; Type: FK CONSTRAINT; Schema: public; Owner: anandavv
--

ALTER TABLE ONLY public.tarefas
    ADD CONSTRAINT tarefas_funcionario_cpf_fk_set_null FOREIGN KEY (func_resp_cpf) REFERENCES public.funcionario(cpf) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

