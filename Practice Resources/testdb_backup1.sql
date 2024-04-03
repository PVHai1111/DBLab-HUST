--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

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
-- Name: store; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA store;


ALTER SCHEMA store OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: customer; Type: TABLE; Schema: store; Owner: postgres
--

CREATE TABLE store.customer (
    customerid character(6) NOT NULL,
    lastname character varying NOT NULL,
    firstname character varying NOT NULL,
    address character varying NOT NULL,
    city character varying NOT NULL,
    state character(2) NOT NULL,
    zip character(5) NOT NULL,
    phone character varying
);


ALTER TABLE store.customer OWNER TO postgres;

--
-- Name: order; Type: TABLE; Schema: store; Owner: postgres
--

CREATE TABLE store."order" (
    orderid character(6) NOT NULL,
    customerid character(6) NOT NULL,
    productid character(6) NOT NULL,
    purchasedate date NOT NULL,
    totalcost money NOT NULL,
    quantity integer
);


ALTER TABLE store."order" OWNER TO postgres;

--
-- Name: product; Type: TABLE; Schema: store; Owner: postgres
--

CREATE TABLE store.product (
    productid character(6) NOT NULL,
    productname character varying NOT NULL,
    model character varying NOT NULL,
    manufacturer character varying NOT NULL,
    unitprice money NOT NULL,
    inventory integer
);


ALTER TABLE store.product OWNER TO postgres;

--
-- Data for Name: customer; Type: TABLE DATA; Schema: store; Owner: postgres
--

COPY store.customer (customerid, lastname, firstname, address, city, state, zip, phone) FROM stdin;
BLU001	Blum\n	Jessica	229 State	Whiting	IN	46300	555-0921
BLU003	AAAA	Katie	342 Pine	Hammond	IN	46200	555-9242
WIL001	Williams	Frank	456 Oak St.	Hammond	IN	46102	\N
BLU005	Bbbbbbbb	Rich	123 Main St.	Chicago	IL	60633	555-1234
\.


--
-- Data for Name: order; Type: TABLE DATA; Schema: store; Owner: postgres
--

COPY store."order" (orderid, customerid, productid, purchasedate, totalcost, quantity) FROM stdin;
ODR001	BLU001	LAP001	2012-08-21	$1.30	1
ODR002	BLU003	LAP002	2012-02-03	$2.00	2
ODR003	WIL001	LAP001	2012-06-06	$1.30	1
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: store; Owner: postgres
--

COPY store.product (productid, productname, model, manufacturer, unitprice, inventory) FROM stdin;
LAP001	VAIO CR31Z	CR	Sony Valo	$1.30	5
LAP002	HP AZE	HP	null	$1.00	18
LAP003	HP 34	HP	HP	$1,000.00	200
\.


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (customerid);


--
-- Name: order order_pkey; Type: CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (orderid);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (productid);


--
-- Name: order fk_customerid; Type: FK CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store."order"
    ADD CONSTRAINT fk_customerid FOREIGN KEY (customerid) REFERENCES store.customer(customerid);


--
-- Name: order fk_productid; Type: FK CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store."order"
    ADD CONSTRAINT fk_productid FOREIGN KEY (productid) REFERENCES store.product(productid);


--
-- Name: TABLE customer; Type: ACL; Schema: store; Owner: postgres
--

GRANT INSERT,DELETE,UPDATE ON TABLE store.customer TO salesman;
GRANT SELECT ON TABLE store.customer TO salesman WITH GRANT OPTION;
GRANT SELECT ON TABLE store.customer TO accountant;


--
-- Name: TABLE "order"; Type: ACL; Schema: store; Owner: postgres
--

GRANT INSERT,DELETE,UPDATE ON TABLE store."order" TO salesman;
GRANT SELECT ON TABLE store."order" TO salesman WITH GRANT OPTION;
GRANT INSERT,DELETE,UPDATE ON TABLE store."order" TO accountant;
GRANT SELECT ON TABLE store."order" TO accountant WITH GRANT OPTION;


--
-- Name: TABLE product; Type: ACL; Schema: store; Owner: postgres
--

GRANT SELECT ON TABLE store.product TO salesman;
GRANT INSERT,DELETE,UPDATE ON TABLE store.product TO accountant;
GRANT SELECT ON TABLE store.product TO accountant WITH GRANT OPTION;


--
-- PostgreSQL database dump complete
--

