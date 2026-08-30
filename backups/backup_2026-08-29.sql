--
-- PostgreSQL database dump
--

\restrict SgcYOBY8wvwcALSefGZGOOtoDCO9X8gVlK81wlhuGYIxkS6WVbZsOrfkTmLjAG0

-- Dumped from database version 16.15 (Debian 16.15-1.pgdg13+2)
-- Dumped by pg_dump version 16.15 (Debian 16.15-1.pgdg13+2)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: proyectos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.proyectos (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    color character varying(20) DEFAULT 'gris'::character varying,
    fecha_creacion timestamp without time zone DEFAULT now()
);


ALTER TABLE public.proyectos OWNER TO postgres;

--
-- Name: proyectos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.proyectos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.proyectos_id_seq OWNER TO postgres;

--
-- Name: proyectos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.proyectos_id_seq OWNED BY public.proyectos.id;


--
-- Name: subtareas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subtareas (
    id integer NOT NULL,
    titulo character varying(150) NOT NULL,
    completada boolean DEFAULT false,
    tarea_id integer
);


ALTER TABLE public.subtareas OWNER TO postgres;

--
-- Name: subtareas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.subtareas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.subtareas_id_seq OWNER TO postgres;

--
-- Name: subtareas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.subtareas_id_seq OWNED BY public.subtareas.id;


--
-- Name: tareas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tareas (
    id integer NOT NULL,
    titulo character varying(150) NOT NULL,
    descripcion text,
    completada boolean DEFAULT false,
    prioridad character varying(10) DEFAULT 'media'::character varying,
    fecha_vencimiento date,
    fecha_creacion timestamp without time zone DEFAULT now(),
    proyecto_id integer,
    CONSTRAINT tareas_prioridad_check CHECK (((prioridad)::text = ANY ((ARRAY['baja'::character varying, 'media'::character varying, 'alta'::character varying])::text[])))
);


ALTER TABLE public.tareas OWNER TO postgres;

--
-- Name: tareas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tareas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tareas_id_seq OWNER TO postgres;

--
-- Name: tareas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tareas_id_seq OWNED BY public.tareas.id;


--
-- Name: proyectos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proyectos ALTER COLUMN id SET DEFAULT nextval('public.proyectos_id_seq'::regclass);


--
-- Name: subtareas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subtareas ALTER COLUMN id SET DEFAULT nextval('public.subtareas_id_seq'::regclass);


--
-- Name: tareas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tareas ALTER COLUMN id SET DEFAULT nextval('public.tareas_id_seq'::regclass);


--
-- Data for Name: proyectos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.proyectos (id, nombre, color, fecha_creacion) FROM stdin;
1	Homelab	azul	2026-08-29 23:23:04.604942
2	Personal	verde	2026-08-29 23:23:04.604942
\.


--
-- Data for Name: subtareas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subtareas (id, titulo, completada, tarea_id) FROM stdin;
1	Levantar Postgres	t	1
2	Levantar PostRest	f	1
3	Escribir servidor Apollo	f	1
4	comprar carnes y patatas	t	2
\.


--
-- Data for Name: tareas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tareas (id, titulo, descripcion, completada, prioridad, fecha_vencimiento, fecha_creacion, proyecto_id) FROM stdin;
1	Terminar paso 4 del homelab	Postgres + PostRest + Apollo + Nginx	f	alta	2026-08-20	2026-08-29 23:23:04.625883	1
2	Practicar Aleman	Ver video en aleman nativo con subs	f	alta	2026-08-21	2026-08-29 23:23:04.625883	1
3	Comprar mercado	\N	f	baja	\N	2026-08-29 23:23:04.625883	2
\.


--
-- Name: proyectos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.proyectos_id_seq', 2, true);


--
-- Name: subtareas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.subtareas_id_seq', 4, true);


--
-- Name: tareas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tareas_id_seq', 3, true);


--
-- Name: proyectos proyectos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proyectos
    ADD CONSTRAINT proyectos_pkey PRIMARY KEY (id);


--
-- Name: subtareas subtareas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subtareas
    ADD CONSTRAINT subtareas_pkey PRIMARY KEY (id);


--
-- Name: tareas tareas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tareas
    ADD CONSTRAINT tareas_pkey PRIMARY KEY (id);


--
-- Name: subtareas subtareas_tarea_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subtareas
    ADD CONSTRAINT subtareas_tarea_id_fkey FOREIGN KEY (tarea_id) REFERENCES public.tareas(id) ON DELETE CASCADE;


--
-- Name: tareas tareas_proyecto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tareas
    ADD CONSTRAINT tareas_proyecto_id_fkey FOREIGN KEY (proyecto_id) REFERENCES public.proyectos(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict SgcYOBY8wvwcALSefGZGOOtoDCO9X8gVlK81wlhuGYIxkS6WVbZsOrfkTmLjAG0

