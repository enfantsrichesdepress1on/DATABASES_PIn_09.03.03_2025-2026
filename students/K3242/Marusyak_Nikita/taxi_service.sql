--
-- PostgreSQL database dump
--

\restrict Vql9H3DBDO4fx4c2iBdtj8rA7IkgMHxiwr08OTC3g39SVTKG2X5Vyd1GG8G9OAR

-- Dumped from database version 16.13 (Ubuntu 16.13-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.13 (Ubuntu 16.13-0ubuntu0.24.04.1)

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

--
-- Name: taxi_service_db; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE taxi_service_db WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'ru_RU.UTF-8';


ALTER DATABASE taxi_service_db OWNER TO postgres;

\unrestrict Vql9H3DBDO4fx4c2iBdtj8rA7IkgMHxiwr08OTC3g39SVTKG2X5Vyd1GG8G9OAR
\connect taxi_service_db
\restrict Vql9H3DBDO4fx4c2iBdtj8rA7IkgMHxiwr08OTC3g39SVTKG2X5Vyd1GG8G9OAR

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

--
-- Name: taxi_service; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA taxi_service;


ALTER SCHEMA taxi_service OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: car_models; Type: TABLE; Schema: taxi_service; Owner: postgres
--

CREATE TABLE taxi_service.car_models (
    model_id integer NOT NULL,
    brand_name character varying(50) NOT NULL,
    model_name character varying(50) NOT NULL,
    technical_specs text NOT NULL,
    manufacturer_country character varying(50) NOT NULL,
    cost numeric(12,2) NOT NULL,
    CONSTRAINT chk_car_model_cost CHECK ((cost > (0)::numeric))
);


ALTER TABLE taxi_service.car_models OWNER TO postgres;

--
-- Name: car_models_model_id_seq; Type: SEQUENCE; Schema: taxi_service; Owner: postgres
--

CREATE SEQUENCE taxi_service.car_models_model_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE taxi_service.car_models_model_id_seq OWNER TO postgres;

--
-- Name: car_models_model_id_seq; Type: SEQUENCE OWNED BY; Schema: taxi_service; Owner: postgres
--

ALTER SEQUENCE taxi_service.car_models_model_id_seq OWNED BY taxi_service.car_models.model_id;


--
-- Name: cars; Type: TABLE; Schema: taxi_service; Owner: postgres
--

CREATE TABLE taxi_service.cars (
    car_id integer NOT NULL,
    model_id integer NOT NULL,
    state_number character varying(20) NOT NULL,
    year_of_manufacture integer NOT NULL,
    mileage numeric(10,2) NOT NULL,
    last_service_date date NOT NULL,
    ownership_type character varying(20) NOT NULL,
    owner_driver_id integer,
    CONSTRAINT chk_cars_mileage CHECK ((mileage >= (0)::numeric)),
    CONSTRAINT chk_cars_owner_logic CHECK (((((ownership_type)::text = 'COMPANY'::text) AND (owner_driver_id IS NULL)) OR (((ownership_type)::text = 'DRIVER'::text) AND (owner_driver_id IS NOT NULL)))),
    CONSTRAINT chk_cars_ownership CHECK (((ownership_type)::text = ANY ((ARRAY['COMPANY'::character varying, 'DRIVER'::character varying])::text[]))),
    CONSTRAINT chk_cars_year CHECK (((year_of_manufacture >= 2000) AND (year_of_manufacture <= (EXTRACT(year FROM CURRENT_DATE))::integer)))
);


ALTER TABLE taxi_service.cars OWNER TO postgres;

--
-- Name: cars_car_id_seq; Type: SEQUENCE; Schema: taxi_service; Owner: postgres
--

CREATE SEQUENCE taxi_service.cars_car_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE taxi_service.cars_car_id_seq OWNER TO postgres;

--
-- Name: cars_car_id_seq; Type: SEQUENCE OWNED BY; Schema: taxi_service; Owner: postgres
--

ALTER SEQUENCE taxi_service.cars_car_id_seq OWNED BY taxi_service.cars.car_id;


--
-- Name: driver_schedules; Type: TABLE; Schema: taxi_service; Owner: postgres
--

CREATE TABLE taxi_service.driver_schedules (
    schedule_id integer NOT NULL,
    driver_id integer NOT NULL,
    work_date date NOT NULL,
    shift_start time without time zone NOT NULL,
    shift_end time without time zone NOT NULL,
    CONSTRAINT chk_driver_schedule_time CHECK ((shift_start < shift_end))
);


ALTER TABLE taxi_service.driver_schedules OWNER TO postgres;

--
-- Name: driver_schedules_schedule_id_seq; Type: SEQUENCE; Schema: taxi_service; Owner: postgres
--

CREATE SEQUENCE taxi_service.driver_schedules_schedule_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE taxi_service.driver_schedules_schedule_id_seq OWNER TO postgres;

--
-- Name: driver_schedules_schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: taxi_service; Owner: postgres
--

ALTER SEQUENCE taxi_service.driver_schedules_schedule_id_seq OWNED BY taxi_service.driver_schedules.schedule_id;


--
-- Name: employee_categories; Type: TABLE; Schema: taxi_service; Owner: postgres
--

CREATE TABLE taxi_service.employee_categories (
    category_id integer NOT NULL,
    category_name character varying(50) NOT NULL
);


ALTER TABLE taxi_service.employee_categories OWNER TO postgres;

--
-- Name: employee_categories_category_id_seq; Type: SEQUENCE; Schema: taxi_service; Owner: postgres
--

CREATE SEQUENCE taxi_service.employee_categories_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE taxi_service.employee_categories_category_id_seq OWNER TO postgres;

--
-- Name: employee_categories_category_id_seq; Type: SEQUENCE OWNED BY; Schema: taxi_service; Owner: postgres
--

ALTER SEQUENCE taxi_service.employee_categories_category_id_seq OWNED BY taxi_service.employee_categories.category_id;


--
-- Name: employees; Type: TABLE; Schema: taxi_service; Owner: postgres
--

CREATE TABLE taxi_service.employees (
    employee_id integer NOT NULL,
    full_name character varying(150) NOT NULL,
    address character varying(200) NOT NULL,
    phone_number character varying(20) NOT NULL,
    passport_data character varying(30) NOT NULL,
    position_id integer NOT NULL,
    category_id integer NOT NULL,
    hire_date date DEFAULT CURRENT_DATE NOT NULL,
    CONSTRAINT chk_employees_phone CHECK ((char_length((phone_number)::text) >= 10))
);


ALTER TABLE taxi_service.employees OWNER TO postgres;

--
-- Name: employees_employee_id_seq; Type: SEQUENCE; Schema: taxi_service; Owner: postgres
--

CREATE SEQUENCE taxi_service.employees_employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE taxi_service.employees_employee_id_seq OWNER TO postgres;

--
-- Name: employees_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: taxi_service; Owner: postgres
--

ALTER SEQUENCE taxi_service.employees_employee_id_seq OWNED BY taxi_service.employees.employee_id;


--
-- Name: orders; Type: TABLE; Schema: taxi_service; Owner: postgres
--

CREATE TABLE taxi_service.orders (
    order_id integer NOT NULL,
    admin_id integer NOT NULL,
    driver_id integer NOT NULL,
    car_id integer NOT NULL,
    tariff_id integer NOT NULL,
    card_id integer,
    call_date date NOT NULL,
    pickup_time timestamp without time zone NOT NULL,
    dropoff_time timestamp without time zone NOT NULL,
    passenger_phone character varying(20) NOT NULL,
    origin_address character varying(200) NOT NULL,
    destination_address character varying(200) NOT NULL,
    distance_km numeric(8,2) NOT NULL,
    waiting_minutes integer DEFAULT 0 NOT NULL,
    waiting_penalty numeric(10,2) DEFAULT 0 NOT NULL,
    payment_type character varying(20) NOT NULL,
    client_claim text,
    applied_coefficient numeric(4,2) DEFAULT 1.00 NOT NULL,
    applied_price_per_km numeric(8,2) NOT NULL,
    total_amount numeric(10,2) NOT NULL,
    CONSTRAINT chk_orders_coefficient CHECK ((applied_coefficient > (0)::numeric)),
    CONSTRAINT chk_orders_distance CHECK ((distance_km > (0)::numeric)),
    CONSTRAINT chk_orders_payment_logic CHECK (((((payment_type)::text = 'CASH'::text) AND (card_id IS NULL)) OR (((payment_type)::text = 'ONLINE'::text) AND (card_id IS NOT NULL)))),
    CONSTRAINT chk_orders_payment_type CHECK (((payment_type)::text = ANY ((ARRAY['CASH'::character varying, 'ONLINE'::character varying])::text[]))),
    CONSTRAINT chk_orders_price_per_km CHECK ((applied_price_per_km > (0)::numeric)),
    CONSTRAINT chk_orders_time CHECK ((dropoff_time > pickup_time)),
    CONSTRAINT chk_orders_total_amount CHECK ((total_amount > (0)::numeric)),
    CONSTRAINT chk_orders_waiting CHECK ((waiting_minutes >= 0)),
    CONSTRAINT chk_orders_waiting_penalty CHECK ((waiting_penalty >= (0)::numeric))
);


ALTER TABLE taxi_service.orders OWNER TO postgres;

--
-- Name: orders_order_id_seq; Type: SEQUENCE; Schema: taxi_service; Owner: postgres
--

CREATE SEQUENCE taxi_service.orders_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE taxi_service.orders_order_id_seq OWNER TO postgres;

--
-- Name: orders_order_id_seq; Type: SEQUENCE OWNED BY; Schema: taxi_service; Owner: postgres
--

ALTER SEQUENCE taxi_service.orders_order_id_seq OWNED BY taxi_service.orders.order_id;


--
-- Name: payment_cards; Type: TABLE; Schema: taxi_service; Owner: postgres
--

CREATE TABLE taxi_service.payment_cards (
    card_id integer NOT NULL,
    masked_card_number character varying(25) NOT NULL,
    bank_name character varying(100) NOT NULL
);


ALTER TABLE taxi_service.payment_cards OWNER TO postgres;

--
-- Name: payment_cards_card_id_seq; Type: SEQUENCE; Schema: taxi_service; Owner: postgres
--

CREATE SEQUENCE taxi_service.payment_cards_card_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE taxi_service.payment_cards_card_id_seq OWNER TO postgres;

--
-- Name: payment_cards_card_id_seq; Type: SEQUENCE OWNED BY; Schema: taxi_service; Owner: postgres
--

ALTER SEQUENCE taxi_service.payment_cards_card_id_seq OWNED BY taxi_service.payment_cards.card_id;


--
-- Name: positions; Type: TABLE; Schema: taxi_service; Owner: postgres
--

CREATE TABLE taxi_service.positions (
    position_id integer NOT NULL,
    position_name character varying(50) NOT NULL
);


ALTER TABLE taxi_service.positions OWNER TO postgres;

--
-- Name: positions_position_id_seq; Type: SEQUENCE; Schema: taxi_service; Owner: postgres
--

CREATE SEQUENCE taxi_service.positions_position_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE taxi_service.positions_position_id_seq OWNER TO postgres;

--
-- Name: positions_position_id_seq; Type: SEQUENCE OWNED BY; Schema: taxi_service; Owner: postgres
--

ALTER SEQUENCE taxi_service.positions_position_id_seq OWNED BY taxi_service.positions.position_id;


--
-- Name: tariff_adjustments; Type: TABLE; Schema: taxi_service; Owner: postgres
--

CREATE TABLE taxi_service.tariff_adjustments (
    adjustment_id integer NOT NULL,
    tariff_id integer NOT NULL,
    time_from time without time zone NOT NULL,
    time_to time without time zone NOT NULL,
    road_situation character varying(100) NOT NULL,
    coefficient numeric(4,2) NOT NULL,
    CONSTRAINT chk_adjustments_coefficient CHECK ((coefficient > (0)::numeric)),
    CONSTRAINT chk_adjustments_time CHECK ((time_from <> time_to))
);


ALTER TABLE taxi_service.tariff_adjustments OWNER TO postgres;

--
-- Name: tariff_adjustments_adjustment_id_seq; Type: SEQUENCE; Schema: taxi_service; Owner: postgres
--

CREATE SEQUENCE taxi_service.tariff_adjustments_adjustment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE taxi_service.tariff_adjustments_adjustment_id_seq OWNER TO postgres;

--
-- Name: tariff_adjustments_adjustment_id_seq; Type: SEQUENCE OWNED BY; Schema: taxi_service; Owner: postgres
--

ALTER SEQUENCE taxi_service.tariff_adjustments_adjustment_id_seq OWNED BY taxi_service.tariff_adjustments.adjustment_id;


--
-- Name: tariffs; Type: TABLE; Schema: taxi_service; Owner: postgres
--

CREATE TABLE taxi_service.tariffs (
    tariff_id integer NOT NULL,
    tariff_code character varying(20) NOT NULL,
    tariff_name character varying(100) NOT NULL,
    car_type_name character varying(50) NOT NULL,
    base_price_per_km numeric(8,2) NOT NULL,
    CONSTRAINT chk_tariffs_price CHECK ((base_price_per_km > (0)::numeric))
);


ALTER TABLE taxi_service.tariffs OWNER TO postgres;

--
-- Name: tariffs_tariff_id_seq; Type: SEQUENCE; Schema: taxi_service; Owner: postgres
--

CREATE SEQUENCE taxi_service.tariffs_tariff_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE taxi_service.tariffs_tariff_id_seq OWNER TO postgres;

--
-- Name: tariffs_tariff_id_seq; Type: SEQUENCE OWNED BY; Schema: taxi_service; Owner: postgres
--

ALTER SEQUENCE taxi_service.tariffs_tariff_id_seq OWNED BY taxi_service.tariffs.tariff_id;


--
-- Name: car_models model_id; Type: DEFAULT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.car_models ALTER COLUMN model_id SET DEFAULT nextval('taxi_service.car_models_model_id_seq'::regclass);


--
-- Name: cars car_id; Type: DEFAULT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.cars ALTER COLUMN car_id SET DEFAULT nextval('taxi_service.cars_car_id_seq'::regclass);


--
-- Name: driver_schedules schedule_id; Type: DEFAULT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.driver_schedules ALTER COLUMN schedule_id SET DEFAULT nextval('taxi_service.driver_schedules_schedule_id_seq'::regclass);


--
-- Name: employee_categories category_id; Type: DEFAULT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.employee_categories ALTER COLUMN category_id SET DEFAULT nextval('taxi_service.employee_categories_category_id_seq'::regclass);


--
-- Name: employees employee_id; Type: DEFAULT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.employees ALTER COLUMN employee_id SET DEFAULT nextval('taxi_service.employees_employee_id_seq'::regclass);


--
-- Name: orders order_id; Type: DEFAULT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.orders ALTER COLUMN order_id SET DEFAULT nextval('taxi_service.orders_order_id_seq'::regclass);


--
-- Name: payment_cards card_id; Type: DEFAULT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.payment_cards ALTER COLUMN card_id SET DEFAULT nextval('taxi_service.payment_cards_card_id_seq'::regclass);


--
-- Name: positions position_id; Type: DEFAULT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.positions ALTER COLUMN position_id SET DEFAULT nextval('taxi_service.positions_position_id_seq'::regclass);


--
-- Name: tariff_adjustments adjustment_id; Type: DEFAULT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.tariff_adjustments ALTER COLUMN adjustment_id SET DEFAULT nextval('taxi_service.tariff_adjustments_adjustment_id_seq'::regclass);


--
-- Name: tariffs tariff_id; Type: DEFAULT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.tariffs ALTER COLUMN tariff_id SET DEFAULT nextval('taxi_service.tariffs_tariff_id_seq'::regclass);


--
-- Data for Name: car_models; Type: TABLE DATA; Schema: taxi_service; Owner: postgres
--

COPY taxi_service.car_models (model_id, brand_name, model_name, technical_specs, manufacturer_country, cost) FROM stdin;
1	Toyota	Camry	2.5 бензин, АКПП, 181 л.с.	Япония	95000.00
2	Volkswagen	Polo	1.6 бензин, МКПП, 110 л.с.	Германия	52000.00
3	Skoda	Octavia	1.8 бензин, АКПП, 180 л.с.	Чехия	73000.00
4	Kia	Rio	1.6 бензин, АКПП, 123 л.с.	Южная Корея	48000.00
\.


--
-- Data for Name: cars; Type: TABLE DATA; Schema: taxi_service; Owner: postgres
--

COPY taxi_service.cars (car_id, model_id, state_number, year_of_manufacture, mileage, last_service_date, ownership_type, owner_driver_id) FROM stdin;
1	1	1234 AB-7	2021	85000.00	2025-11-25	COMPANY	\N
2	2	2345 BC-7	2020	112000.00	2025-11-20	DRIVER	4
3	3	3456 CD-7	2022	54000.00	2025-11-18	COMPANY	\N
4	4	4567 DE-7	2021	97000.00	2025-11-10	DRIVER	5
\.


--
-- Data for Name: driver_schedules; Type: TABLE DATA; Schema: taxi_service; Owner: postgres
--

COPY taxi_service.driver_schedules (schedule_id, driver_id, work_date, shift_start, shift_end) FROM stdin;
1	3	2025-12-10	08:00:00	20:00:00
2	4	2025-12-10	09:00:00	21:00:00
3	5	2025-12-10	08:00:00	18:00:00
4	3	2025-12-11	08:00:00	20:00:00
5	4	2025-12-11	09:00:00	21:00:00
6	5	2025-12-11	08:00:00	18:00:00
\.


--
-- Data for Name: employee_categories; Type: TABLE DATA; Schema: taxi_service; Owner: postgres
--

COPY taxi_service.employee_categories (category_id, category_name) FROM stdin;
1	Первая категория
2	Вторая категория
3	Высшая категория
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: taxi_service; Owner: postgres
--

COPY taxi_service.employees (employee_id, full_name, address, phone_number, passport_data, position_id, category_id, hire_date) FROM stdin;
1	Иванова Марина Сергеевна	г. Минск, ул. Ленина, д. 10, кв. 5	+775291111111	MP1234567	1	3	2023-02-10
2	Петров Олег Викторович	г. Минск, ул. Победы, д. 22, кв. 17	+737292222222	MP2345678	1	2	2023-04-15
3	Сидоров Алексей Игоревич	г. Минск, ул. Советская, д. 8, кв. 2	+799129333333	MP3456789	2	3	2022-11-01
4	Козлов Дмитрий Андреевич	г. Минск, пр. Независимости, д. 45, кв. 11	+775294444444	MP4567890	2	2	2023-01-20
5	Николаев Павел Олегович	г. Минск, ул. Якуба Коласа, д. 14, кв. 9	+775295555555	MP5678901	2	1	2024-03-12
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: taxi_service; Owner: postgres
--

COPY taxi_service.orders (order_id, admin_id, driver_id, car_id, tariff_id, card_id, call_date, pickup_time, dropoff_time, passenger_phone, origin_address, destination_address, distance_km, waiting_minutes, waiting_penalty, payment_type, client_claim, applied_coefficient, applied_price_per_km, total_amount) FROM stdin;
1	1	3	1	2	1	2025-12-10	2025-12-10 08:15:00	2025-12-10 08:42:00	+375296001122	Минск, ул. Сурганова, 15	Минск, пр. Победителей, 39	12.50	3	2.50	ONLINE	\N	1.15	2.40	37.00
2	1	4	2	1	\N	2025-12-10	2025-12-10 09:05:00	2025-12-10 09:28:00	+375296001133	Минск, ул. Кульман, 9	Минск, ул. Немига, 3	9.20	0	0.00	CASH	\N	1.20	1.80	19.87
3	2	5	4	1	2	2025-12-10	2025-12-10 17:40:00	2025-12-10 18:15:00	+375296001144	Минск, ул. Притыцкого, 28	Минск, ул. Казинца, 54	14.80	5	4.00	ONLINE	Опоздание машины на 10 минут	1.25	1.80	37.30
4	2	3	3	2	\N	2025-12-10	2025-12-10 19:10:00	2025-12-10 19:36:00	+375296001155	Минск, ул. Богдановича, 77	Минск, ул. Захарова, 50	10.40	2	1.50	CASH	\N	1.20	2.40	31.45
5	1	4	2	1	3	2025-12-11	2025-12-11 07:25:00	2025-12-11 07:54:00	+375296001166	Минск, ул. Одинцова, 12	Минск, ул. Маяковского, 8	11.30	1	1.00	ONLINE	\N	1.20	1.80	25.41
6	2	5	4	1	\N	2025-12-11	2025-12-11 12:05:00	2025-12-11 12:31:00	+375296001177	Минск, ул. Лобанка, 91	Минск, ул. Шаранговича, 25	8.60	0	0.00	CASH	\N	1.00	1.80	15.48
\.


--
-- Data for Name: payment_cards; Type: TABLE DATA; Schema: taxi_service; Owner: postgres
--

COPY taxi_service.payment_cards (card_id, masked_card_number, bank_name) FROM stdin;
1	4111 **** **** 1024	Сбербанк
2	5469 **** **** 8877	Озон-банк
3	2200 **** **** 4512	Альфа-Банк
\.


--
-- Data for Name: positions; Type: TABLE DATA; Schema: taxi_service; Owner: postgres
--

COPY taxi_service.positions (position_id, position_name) FROM stdin;
1	Администратор
2	Водитель
\.


--
-- Data for Name: tariff_adjustments; Type: TABLE DATA; Schema: taxi_service; Owner: postgres
--

COPY taxi_service.tariff_adjustments (adjustment_id, tariff_id, time_from, time_to, road_situation, coefficient) FROM stdin;
1	1	07:00:00	10:00:00	Час пик	1.20
2	1	17:00:00	20:00:00	Вечерний час пик	1.25
3	2	07:00:00	10:00:00	Час пик	1.15
4	2	17:00:00	20:00:00	Пробки	1.20
5	3	00:00:00	06:00:00	Ночной тариф	1.10
\.


--
-- Data for Name: tariffs; Type: TABLE DATA; Schema: taxi_service; Owner: postgres
--

COPY taxi_service.tariffs (tariff_id, tariff_code, tariff_name, car_type_name, base_price_per_km) FROM stdin;
1	ECON	Эконом	Легковой стандарт	1.80
2	COMF	Комфорт	Комфорт-класс	2.40
3	BUS	Минивэн	Минивэн	3.20
\.


--
-- Name: car_models_model_id_seq; Type: SEQUENCE SET; Schema: taxi_service; Owner: postgres
--

SELECT pg_catalog.setval('taxi_service.car_models_model_id_seq', 4, true);


--
-- Name: cars_car_id_seq; Type: SEQUENCE SET; Schema: taxi_service; Owner: postgres
--

SELECT pg_catalog.setval('taxi_service.cars_car_id_seq', 4, true);


--
-- Name: driver_schedules_schedule_id_seq; Type: SEQUENCE SET; Schema: taxi_service; Owner: postgres
--

SELECT pg_catalog.setval('taxi_service.driver_schedules_schedule_id_seq', 6, true);


--
-- Name: employee_categories_category_id_seq; Type: SEQUENCE SET; Schema: taxi_service; Owner: postgres
--

SELECT pg_catalog.setval('taxi_service.employee_categories_category_id_seq', 3, true);


--
-- Name: employees_employee_id_seq; Type: SEQUENCE SET; Schema: taxi_service; Owner: postgres
--

SELECT pg_catalog.setval('taxi_service.employees_employee_id_seq', 5, true);


--
-- Name: orders_order_id_seq; Type: SEQUENCE SET; Schema: taxi_service; Owner: postgres
--

SELECT pg_catalog.setval('taxi_service.orders_order_id_seq', 6, true);


--
-- Name: payment_cards_card_id_seq; Type: SEQUENCE SET; Schema: taxi_service; Owner: postgres
--

SELECT pg_catalog.setval('taxi_service.payment_cards_card_id_seq', 3, true);


--
-- Name: positions_position_id_seq; Type: SEQUENCE SET; Schema: taxi_service; Owner: postgres
--

SELECT pg_catalog.setval('taxi_service.positions_position_id_seq', 2, true);


--
-- Name: tariff_adjustments_adjustment_id_seq; Type: SEQUENCE SET; Schema: taxi_service; Owner: postgres
--

SELECT pg_catalog.setval('taxi_service.tariff_adjustments_adjustment_id_seq', 5, true);


--
-- Name: tariffs_tariff_id_seq; Type: SEQUENCE SET; Schema: taxi_service; Owner: postgres
--

SELECT pg_catalog.setval('taxi_service.tariffs_tariff_id_seq', 3, true);


--
-- Name: car_models car_models_pkey; Type: CONSTRAINT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.car_models
    ADD CONSTRAINT car_models_pkey PRIMARY KEY (model_id);


--
-- Name: cars cars_pkey; Type: CONSTRAINT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.cars
    ADD CONSTRAINT cars_pkey PRIMARY KEY (car_id);


--
-- Name: cars cars_state_number_key; Type: CONSTRAINT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.cars
    ADD CONSTRAINT cars_state_number_key UNIQUE (state_number);


--
-- Name: driver_schedules driver_schedules_pkey; Type: CONSTRAINT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.driver_schedules
    ADD CONSTRAINT driver_schedules_pkey PRIMARY KEY (schedule_id);


--
-- Name: employee_categories employee_categories_category_name_key; Type: CONSTRAINT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.employee_categories
    ADD CONSTRAINT employee_categories_category_name_key UNIQUE (category_name);


--
-- Name: employee_categories employee_categories_pkey; Type: CONSTRAINT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.employee_categories
    ADD CONSTRAINT employee_categories_pkey PRIMARY KEY (category_id);


--
-- Name: employees employees_passport_data_key; Type: CONSTRAINT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.employees
    ADD CONSTRAINT employees_passport_data_key UNIQUE (passport_data);


--
-- Name: employees employees_phone_number_key; Type: CONSTRAINT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.employees
    ADD CONSTRAINT employees_phone_number_key UNIQUE (phone_number);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- Name: payment_cards payment_cards_masked_card_number_key; Type: CONSTRAINT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.payment_cards
    ADD CONSTRAINT payment_cards_masked_card_number_key UNIQUE (masked_card_number);


--
-- Name: payment_cards payment_cards_pkey; Type: CONSTRAINT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.payment_cards
    ADD CONSTRAINT payment_cards_pkey PRIMARY KEY (card_id);


--
-- Name: positions positions_pkey; Type: CONSTRAINT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.positions
    ADD CONSTRAINT positions_pkey PRIMARY KEY (position_id);


--
-- Name: positions positions_position_name_key; Type: CONSTRAINT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.positions
    ADD CONSTRAINT positions_position_name_key UNIQUE (position_name);


--
-- Name: tariff_adjustments tariff_adjustments_pkey; Type: CONSTRAINT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.tariff_adjustments
    ADD CONSTRAINT tariff_adjustments_pkey PRIMARY KEY (adjustment_id);


--
-- Name: tariffs tariffs_pkey; Type: CONSTRAINT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.tariffs
    ADD CONSTRAINT tariffs_pkey PRIMARY KEY (tariff_id);


--
-- Name: tariffs tariffs_tariff_code_key; Type: CONSTRAINT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.tariffs
    ADD CONSTRAINT tariffs_tariff_code_key UNIQUE (tariff_code);


--
-- Name: tariffs tariffs_tariff_name_key; Type: CONSTRAINT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.tariffs
    ADD CONSTRAINT tariffs_tariff_name_key UNIQUE (tariff_name);


--
-- Name: car_models uq_car_model; Type: CONSTRAINT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.car_models
    ADD CONSTRAINT uq_car_model UNIQUE (brand_name, model_name);


--
-- Name: driver_schedules uq_driver_schedule; Type: CONSTRAINT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.driver_schedules
    ADD CONSTRAINT uq_driver_schedule UNIQUE (driver_id, work_date, shift_start);


--
-- Name: tariff_adjustments fk_adjustments_tariff; Type: FK CONSTRAINT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.tariff_adjustments
    ADD CONSTRAINT fk_adjustments_tariff FOREIGN KEY (tariff_id) REFERENCES taxi_service.tariffs(tariff_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cars fk_cars_model; Type: FK CONSTRAINT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.cars
    ADD CONSTRAINT fk_cars_model FOREIGN KEY (model_id) REFERENCES taxi_service.car_models(model_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cars fk_cars_owner_driver; Type: FK CONSTRAINT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.cars
    ADD CONSTRAINT fk_cars_owner_driver FOREIGN KEY (owner_driver_id) REFERENCES taxi_service.employees(employee_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: employees fk_employees_category; Type: FK CONSTRAINT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.employees
    ADD CONSTRAINT fk_employees_category FOREIGN KEY (category_id) REFERENCES taxi_service.employee_categories(category_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: employees fk_employees_position; Type: FK CONSTRAINT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.employees
    ADD CONSTRAINT fk_employees_position FOREIGN KEY (position_id) REFERENCES taxi_service.positions(position_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: orders fk_orders_admin; Type: FK CONSTRAINT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.orders
    ADD CONSTRAINT fk_orders_admin FOREIGN KEY (admin_id) REFERENCES taxi_service.employees(employee_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: orders fk_orders_car; Type: FK CONSTRAINT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.orders
    ADD CONSTRAINT fk_orders_car FOREIGN KEY (car_id) REFERENCES taxi_service.cars(car_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: orders fk_orders_card; Type: FK CONSTRAINT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.orders
    ADD CONSTRAINT fk_orders_card FOREIGN KEY (card_id) REFERENCES taxi_service.payment_cards(card_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: orders fk_orders_driver; Type: FK CONSTRAINT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.orders
    ADD CONSTRAINT fk_orders_driver FOREIGN KEY (driver_id) REFERENCES taxi_service.employees(employee_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: orders fk_orders_tariff; Type: FK CONSTRAINT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.orders
    ADD CONSTRAINT fk_orders_tariff FOREIGN KEY (tariff_id) REFERENCES taxi_service.tariffs(tariff_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: driver_schedules fk_schedule_driver; Type: FK CONSTRAINT; Schema: taxi_service; Owner: postgres
--

ALTER TABLE ONLY taxi_service.driver_schedules
    ADD CONSTRAINT fk_schedule_driver FOREIGN KEY (driver_id) REFERENCES taxi_service.employees(employee_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict Vql9H3DBDO4fx4c2iBdtj8rA7IkgMHxiwr08OTC3g39SVTKG2X5Vyd1GG8G9OAR

