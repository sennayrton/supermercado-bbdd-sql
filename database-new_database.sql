-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.9.2-alpha
-- PostgreSQL version: 10.0
-- Project Site: pgmodeler.io
-- Model Author: ---


-- Database creation must be done outside a multicommand file.
-- These commands were put in this file only as a convenience.
-- -- object: new_database | type: DATABASE --
-- -- DROP DATABASE IF EXISTS new_database;
-- CREATE DATABASE new_database;
-- -- ddl-end --
-- 

-- object: public.trabajadores | type: TABLE --
-- DROP TABLE IF EXISTS public.trabajadores CASCADE;
CREATE TABLE public.trabajadores(
	ss character varying(13) NOT NULL,
	nombre character varying(15) NOT NULL,
	fijo character varying(11) NOT NULL,
	movil character varying(11) NOT NULL,
	turno character varying(6) NOT NULL,
	puntuacion numeric NOT NULL,
	ciudad_tienda text,
	CONSTRAINT trabajadores_pk PRIMARY KEY (ss)

);
-- ddl-end --

-- object: public.tienda | type: TABLE --
-- DROP TABLE IF EXISTS public.tienda CASCADE;
CREATE TABLE public.tienda(
	ciudad text NOT NULL,
	CONSTRAINT tienda_pk PRIMARY KEY (ciudad)

);
-- ddl-end --

-- object: public.cajero | type: TABLE --
-- DROP TABLE IF EXISTS public.cajero CASCADE;
CREATE TABLE public.cajero(
	ss_trabajadores character varying(13) NOT NULL,
	CONSTRAINT cajero_pk PRIMARY KEY (ss_trabajadores)

);
-- ddl-end --

-- object: public.reponedor | type: TABLE --
-- DROP TABLE IF EXISTS public.reponedor CASCADE;
CREATE TABLE public.reponedor(
	horas numeric(5,0) NOT NULL,
	ss_trabajadores character varying(13) NOT NULL,
	CONSTRAINT reponedor_pk PRIMARY KEY (horas,ss_trabajadores)

);
-- ddl-end --

-- object: public.socio | type: TABLE --
-- DROP TABLE IF EXISTS public.socio CASCADE;
CREATE TABLE public.socio(
	numsocio numeric NOT NULL,
	telefono numeric NOT NULL,
	saldo numeric,
	direccion text NOT NULL,
	nombre name NOT NULL,
	email text NOT NULL,
	CONSTRAINT socio_pk PRIMARY KEY (numsocio)

);
-- ddl-end --

-- object: public.tickets | type: TABLE --
-- DROP TABLE IF EXISTS public.tickets CASCADE;
CREATE TABLE public.tickets(
	num numeric NOT NULL,
	fecha date NOT NULL,
	hora time NOT NULL,
	cajero character varying(10) NOT NULL,
	saldo character varying(10) NOT NULL,
	precio numeric(10) NOT NULL,
	numsocio_socio numeric,
	ss_trabajadores_cajero character varying(13) NOT NULL,
	ciudad_tienda text,
	CONSTRAINT tickets_pk PRIMARY KEY (num)

);
-- ddl-end --

-- object: public.cupones | type: TABLE --
-- DROP TABLE IF EXISTS public.cupones CASCADE;
CREATE TABLE public.cupones(
	numero numeric(12) NOT NULL,
	descuento character varying(10),
	numsocio_socio numeric,
	CONSTRAINT cupones_pk PRIMARY KEY (numero)

);
-- ddl-end --

-- object: public.opinion | type: TABLE --
-- DROP TABLE IF EXISTS public.opinion CASCADE;
CREATE TABLE public.opinion(
	numero numeric(10) NOT NULL,
	fecha date NOT NULL,
	hora character varying(7) NOT NULL,
	numsocio_socio numeric,
	nota numeric(2),
	ciudad_tienda text NOT NULL,
	CONSTRAINT opinion_pk PRIMARY KEY (numero)

);
-- ddl-end --

-- object: public.productos | type: TABLE --
-- DROP TABLE IF EXISTS public.productos CASCADE;
CREATE TABLE public.productos(
	codigobarras numeric NOT NULL,
	precioiva numeric NOT NULL,
	preciosiniva numeric NOT NULL,
	stock numeric(7,0) NOT NULL,
	CONSTRAINT productos_pk PRIMARY KEY (codigobarras)

);
-- ddl-end --

-- object: public.ofertas | type: TABLE --
-- DROP TABLE IF EXISTS public.ofertas CASCADE;
CREATE TABLE public.ofertas(
	semana numeric(2,0) NOT NULL,
	descuento character varying(5),
	inicio date NOT NULL,
	fin date NOT NULL,
	CONSTRAINT ofertas_pk PRIMARY KEY (semana)

);
-- ddl-end --

-- object: trabajadores_fk | type: CONSTRAINT --
-- ALTER TABLE public.cajero DROP CONSTRAINT IF EXISTS trabajadores_fk CASCADE;
ALTER TABLE public.cajero ADD CONSTRAINT trabajadores_fk FOREIGN KEY (ss_trabajadores)
REFERENCES public.trabajadores (ss) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: trabajadores_fk | type: CONSTRAINT --
-- ALTER TABLE public.reponedor DROP CONSTRAINT IF EXISTS trabajadores_fk CASCADE;
ALTER TABLE public.reponedor ADD CONSTRAINT trabajadores_fk FOREIGN KEY (ss_trabajadores)
REFERENCES public.trabajadores (ss) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: socio_fk | type: CONSTRAINT --
-- ALTER TABLE public.tickets DROP CONSTRAINT IF EXISTS socio_fk CASCADE;
ALTER TABLE public.tickets ADD CONSTRAINT socio_fk FOREIGN KEY (numsocio_socio)
REFERENCES public.socio (numsocio) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: socio_fk | type: CONSTRAINT --
-- ALTER TABLE public.cupones DROP CONSTRAINT IF EXISTS socio_fk CASCADE;
ALTER TABLE public.cupones ADD CONSTRAINT socio_fk FOREIGN KEY (numsocio_socio)
REFERENCES public.socio (numsocio) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: socio_fk | type: CONSTRAINT --
-- ALTER TABLE public.opinion DROP CONSTRAINT IF EXISTS socio_fk CASCADE;
ALTER TABLE public.opinion ADD CONSTRAINT socio_fk FOREIGN KEY (numsocio_socio)
REFERENCES public.socio (numsocio) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public.devuelve | type: TABLE --
-- DROP TABLE IF EXISTS public.devuelve CASCADE;
CREATE TABLE public.devuelve(
	num_tickets numeric NOT NULL,
	codigobarras_productos numeric NOT NULL,
	cantidad numeric,
	CONSTRAINT devuelve_pk PRIMARY KEY (num_tickets,codigobarras_productos)

);
-- ddl-end --

-- object: tickets_fk | type: CONSTRAINT --
-- ALTER TABLE public.devuelve DROP CONSTRAINT IF EXISTS tickets_fk CASCADE;
ALTER TABLE public.devuelve ADD CONSTRAINT tickets_fk FOREIGN KEY (num_tickets)
REFERENCES public.tickets (num) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: productos_fk | type: CONSTRAINT --
-- ALTER TABLE public.devuelve DROP CONSTRAINT IF EXISTS productos_fk CASCADE;
ALTER TABLE public.devuelve ADD CONSTRAINT productos_fk FOREIGN KEY (codigobarras_productos)
REFERENCES public.productos (codigobarras) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: public.compra | type: TABLE --
-- DROP TABLE IF EXISTS public.compra CASCADE;
CREATE TABLE public.compra(
	num_tickets numeric NOT NULL,
	codigobarras_productos numeric NOT NULL,
	cantidad numeric,
	CONSTRAINT compra_pk PRIMARY KEY (num_tickets,codigobarras_productos)

);
-- ddl-end --

-- object: tickets_fk | type: CONSTRAINT --
-- ALTER TABLE public.compra DROP CONSTRAINT IF EXISTS tickets_fk CASCADE;
ALTER TABLE public.compra ADD CONSTRAINT tickets_fk FOREIGN KEY (num_tickets)
REFERENCES public.tickets (num) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: productos_fk | type: CONSTRAINT --
-- ALTER TABLE public.compra DROP CONSTRAINT IF EXISTS productos_fk CASCADE;
ALTER TABLE public.compra ADD CONSTRAINT productos_fk FOREIGN KEY (codigobarras_productos)
REFERENCES public.productos (codigobarras) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: public.contiene | type: TABLE --
-- DROP TABLE IF EXISTS public.contiene CASCADE;
CREATE TABLE public.contiene(
	numero_cupones numeric(12) NOT NULL,
	codigobarras_productos numeric NOT NULL,
	cantidad numeric,
	CONSTRAINT contiene_pk PRIMARY KEY (numero_cupones,codigobarras_productos)

);
-- ddl-end --

-- object: cupones_fk | type: CONSTRAINT --
-- ALTER TABLE public.contiene DROP CONSTRAINT IF EXISTS cupones_fk CASCADE;
ALTER TABLE public.contiene ADD CONSTRAINT cupones_fk FOREIGN KEY (numero_cupones)
REFERENCES public.cupones (numero) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: productos_fk | type: CONSTRAINT --
-- ALTER TABLE public.contiene DROP CONSTRAINT IF EXISTS productos_fk CASCADE;
ALTER TABLE public.contiene ADD CONSTRAINT productos_fk FOREIGN KEY (codigobarras_productos)
REFERENCES public.productos (codigobarras) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: public.tiene | type: TABLE --
-- DROP TABLE IF EXISTS public.tiene CASCADE;
CREATE TABLE public.tiene(
	codigobarras_productos numeric NOT NULL,
	semana_ofertas numeric(2,0) NOT NULL,
	CONSTRAINT tiene_pk PRIMARY KEY (codigobarras_productos,semana_ofertas)

);
-- ddl-end --

-- object: productos_fk | type: CONSTRAINT --
-- ALTER TABLE public.tiene DROP CONSTRAINT IF EXISTS productos_fk CASCADE;
ALTER TABLE public.tiene ADD CONSTRAINT productos_fk FOREIGN KEY (codigobarras_productos)
REFERENCES public.productos (codigobarras) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: ofertas_fk | type: CONSTRAINT --
-- ALTER TABLE public.tiene DROP CONSTRAINT IF EXISTS ofertas_fk CASCADE;
ALTER TABLE public.tiene ADD CONSTRAINT ofertas_fk FOREIGN KEY (semana_ofertas)
REFERENCES public.ofertas (semana) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: public.evalua | type: TABLE --
-- DROP TABLE IF EXISTS public.evalua CASCADE;
CREATE TABLE public.evalua(
	ss_trabajadores character varying(13) NOT NULL,
	ss_trabajadores1 character varying(13) NOT NULL,
	nota numeric NOT NULL,
	CONSTRAINT evalua_pk PRIMARY KEY (ss_trabajadores,ss_trabajadores1)

);
-- ddl-end --

-- object: trabajadores_fk | type: CONSTRAINT --
-- ALTER TABLE public.evalua DROP CONSTRAINT IF EXISTS trabajadores_fk CASCADE;
ALTER TABLE public.evalua ADD CONSTRAINT trabajadores_fk FOREIGN KEY (ss_trabajadores)
REFERENCES public.trabajadores (ss) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: trabajadores_fk1 | type: CONSTRAINT --
-- ALTER TABLE public.evalua DROP CONSTRAINT IF EXISTS trabajadores_fk1 CASCADE;
ALTER TABLE public.evalua ADD CONSTRAINT trabajadores_fk1 FOREIGN KEY (ss_trabajadores1)
REFERENCES public.trabajadores (ss) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: cajero_fk | type: CONSTRAINT --
-- ALTER TABLE public.tickets DROP CONSTRAINT IF EXISTS cajero_fk CASCADE;
ALTER TABLE public.tickets ADD CONSTRAINT cajero_fk FOREIGN KEY (ss_trabajadores_cajero)
REFERENCES public.cajero (ss_trabajadores) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: tienda_fk | type: CONSTRAINT --
-- ALTER TABLE public.tickets DROP CONSTRAINT IF EXISTS tienda_fk CASCADE;
ALTER TABLE public.tickets ADD CONSTRAINT tienda_fk FOREIGN KEY (ciudad_tienda)
REFERENCES public.tienda (ciudad) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: tienda_fk | type: CONSTRAINT --
-- ALTER TABLE public.trabajadores DROP CONSTRAINT IF EXISTS tienda_fk CASCADE;
ALTER TABLE public.trabajadores ADD CONSTRAINT tienda_fk FOREIGN KEY (ciudad_tienda)
REFERENCES public.tienda (ciudad) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: tienda_fk | type: CONSTRAINT --
-- ALTER TABLE public.opinion DROP CONSTRAINT IF EXISTS tienda_fk CASCADE;
ALTER TABLE public.opinion ADD CONSTRAINT tienda_fk FOREIGN KEY (ciudad_tienda)
REFERENCES public.tienda (ciudad) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: public.producto_oferta | type: TABLE --
-- DROP TABLE IF EXISTS public.producto_oferta CASCADE;
CREATE TABLE public.producto_oferta(
	semana_ofertas numeric(2,0) NOT NULL,
	codigobarras_productos numeric NOT NULL
);
-- ddl-end --
ALTER TABLE public.producto_oferta OWNER TO postgres;
-- ddl-end --

-- object: ofertas_fk | type: CONSTRAINT --
-- ALTER TABLE public.producto_oferta DROP CONSTRAINT IF EXISTS ofertas_fk CASCADE;
ALTER TABLE public.producto_oferta ADD CONSTRAINT ofertas_fk FOREIGN KEY (semana_ofertas)
REFERENCES public.ofertas (semana) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: productos_fk | type: CONSTRAINT --
-- ALTER TABLE public.producto_oferta DROP CONSTRAINT IF EXISTS productos_fk CASCADE;
ALTER TABLE public.producto_oferta ADD CONSTRAINT productos_fk FOREIGN KEY (codigobarras_productos)
REFERENCES public.productos (codigobarras) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: producto_oferta_uq | type: CONSTRAINT --
-- ALTER TABLE public.producto_oferta DROP CONSTRAINT IF EXISTS producto_oferta_uq CASCADE;
ALTER TABLE public.producto_oferta ADD CONSTRAINT producto_oferta_uq UNIQUE (codigobarras_productos);
-- ddl-end --


