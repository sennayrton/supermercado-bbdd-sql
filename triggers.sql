-- COMPROBAR DEVOLUCION --

CREATE FUNCTION public.comprobar_devolucion()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$DECLARE
BEGIN

  IF ( NEW.cantidad ) < 0 THEN RAISE EXCEPTION 'NO SE PUEDE DEVOLVER ALGO NEGATIVO';
END
IF;
		
   RETURN NEW;
END;$BODY$;

ALTER FUNCTION public.comprobar_devolucion()
    OWNER TO postgres;

CREATE TRIGGER comprobar_devolucion BEFORE
INSERT OR
UPDATE
  ON devuelve FOR EACH ROW
EXECUTE PROCEDURE comprobar_devolucion
();

-- DEVOLVER PRODUCTO --

CREATE FUNCTION public.devolver_producto()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$BEGIN

IF NEW.codigobarras_productos NOT IN ( SELECT codigobarras_productos
FROM compra
  INNER JOIN tickets ON num_tickets = num_tickets
WHERE num_tickets = NEW.num_tickets ) 
	THEN RAISE EXCEPTION 'EL PRODUCTO NO EXISTE EN EL TICKET';
END
IF;
   
   IF NEW.cantidad > ( SELECT cantidad
FROM compra
  INNER JOIN tickets ON num_tickets = num_tickets
WHERE num_tickets = NEW.num_tickets AND codigobarras_productos = NEW.codigobarras_productos ) 
	THEN RAISE EXCEPTION 'LA DEVOLUCION ES MAYOR QUE LA COMPRA';
END
IF;
   
   UPDATE compra SET cantidad = ( SELECT cantidad
FROM compra
  INNER JOIN tickets ON num_tickets = num_tickets_
WHERE num_tickets = NEW.num_tickets AND codigobarras_productos = NEW.codigobarras_productos ) - NEW.cantidad
   WHERE num_tickets = NEW.num_tickets AND codigobarras_productos = NEW.codigobarras_productos;

RETURN NEW;
END;$BODY$;

ALTER FUNCTION public.devolver_producto()
    OWNER TO postgres;

CREATE TRIGGER devolver_producto BEFORE
INSERT
  ON
devuelve
FOR
EACH
ROW
EXECUTE PROCEDURE devolver_producto
();

-- TRABAJADOR_NO_ES_CAJERO --

CREATE FUNCTION public.trabajador_no_es_cajero()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$DECLARE

BEGIN
  IF NEW.ss_trabajadores IN ( SELECT ss_trabajadores
  FROM reponedor ) THEN RAISE EXCEPTION 'EL TRABAJADOR YA EXISTE EN REPONEDOR';
END
IF;
   RETURN NEW;
END;$BODY$;

ALTER FUNCTION public.trabajador_no_es_cajero()
    OWNER TO postgres;

CREATE TRIGGER trabajador_no_es_cajero BEFORE
INSERT or
UPDATE
  ON CAJERO FOR EACH ROW
EXECUTE PROCEDURE trabajador_no_es_cajero
();

-- TRABAJADOR_NO_EXISTE --

CREATE FUNCTION public.trabajador_no_existe()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
  IF NEW.nombre IN ( SELECT nombre
  FROM trabajadores ) THEN RAISE EXCEPTION 'EL TRABAJADOR YA EXISTE';
END
IF;
   RETURN NEW;
END;$BODY$;

ALTER FUNCTION public.trabajador_no_existe()
    OWNER TO postgres;

CREATE TRIGGER trabajador_no_existe BEFORE
INSERT
  ON
trabajadores
FOR
EACH
ROW
EXECUTE PROCEDURE trabajador_no_existe
();

-- TRABAJADOR NO ES REPONEDOR --

CREATE FUNCTION public.trabajador_no_es_reponedor()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$DECLARE

BEGIN
  IF NEW.ss_trabajadores IN ( SELECT ss_trabajadores
  FROM cajero ) THEN RAISE EXCEPTION 'EL TRABAJADOR YA EXISTE EN CAJERO';
END
IF;
   RETURN NEW;
END;$BODY$;

ALTER FUNCTION public.trabajador_no_es_reponedor()
    OWNER TO postgres;

CREATE TRIGGER trabajador_no_es_reponedor BEFORE
INSERT or
UPDATE
  ON reponedor FOR EACH ROW
EXECUTE PROCEDURE trabajador_no_es_reponedor
();


-- ACTUALIZAR TICKET --

CREATE FUNCTION public.actualizar_ticket()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$DECLARE
BEGIN

  UPDATE tickets SET precio = ( SELECT DISTINCT precio
  FROM tickets
    INNER JOIN compra ON num_tickets = num_tickets
  WHERE num_tickets = NEW.num_tickets ) + ( SELECT (NEW.cantidad - OLD.cantidad)*precio
  FROM productos
  WHERE codigobarras = NEW.codigobarras_productos )
   		WHERE num_tickets = NEW.num_tickets;

  RETURN NEW;
END;$BODY$;

ALTER FUNCTION public.actualizar_ticket()
    OWNER TO postgres;

CREATE TRIGGER actualizar_ticket AFTER
UPDATE
  ON compra FOR EACH ROW
EXECUTE PROCEDURE actualizar_ticket
();


-- NUEVO TICKET SOCIO --

CREATE FUNCTION public.nuevo_ticket_socio()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$DECLARE
BEGIN
  IF NEW.numsocio_socio IN ( SELECT numsocio
  FROM socio ) THEN
  UPDATE socio 
   SET saldo = saldo + NEW.precio WHERE socio.numsocio = NEW.numsocio_socio
;
END
IF;
   RETURN NEW;
END;$BODY$;

ALTER FUNCTION public.nuevo_ticket_socio()
    OWNER TO postgres;

CREATE TRIGGER nuevo_ticket_socio AFTER
INSERT
  ON
tickets
FOR
EACH
ROW
EXECUTE PROCEDURE nuevo_ticket_socio
();

-- ACTUALIZAR TICKET SOCIO --

CREATE FUNCTION public.actualizar_ticket_socio()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$DECLARE
BEGIN

  IF NEW.numsocio_socio IN ( SELECT numsocio
  FROM socio )
   THEN
  UPDATE socio SET saldo = saldo + ( NEW.precio - OLD.precio ) WHERE socio.numsocio = NEW.numsocio_socio
;
END
IF;
   
   RETURN NEW;
END;$BODY$;

ALTER FUNCTION public.actualizar_ticket_socio()
    OWNER TO postgres;

CREATE TRIGGER actualizar_ticket_socio AFTER
UPDATE
  ON tickets FOR EACH ROW
EXECUTE PROCEDURE actualizar_ticket_socio
();

-- ACTUALIZAR DEVOLUCION --

CREATE FUNCTION public.actualizar_devolucion()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$DECLARE
BEGIN

  UPDATE compra SET cantidad = ( SELECT cantidad
  FROM compra
  WHERE num_tickets = NEW.num_tickets AND codigobarras_productos = NEW.codigobarras_productos ) - ( NEW.cantidad - OLD.cantidad )
		WHERE NEW.codigobarras_productos = codigobarras_productos AND num_tickets = NEW.num_tickets;

  UPDATE tickets SET precio = ( SELECT DISTINCT precio
  FROM tickets INNER JOIN compra ON num = num_tickets
  WHERE num = OLD.num_tickets ) + ( SELECT (OLD.CANTIDAD - NEW.CANTIDAD)*precio
  FROM productos
  WHERE codigobarras = NEW.codigobarras_productos )
   		WHERE num = NEW.num_tickets;

  RETURN NEW;
END;$BODY$;

ALTER FUNCTION public.actualizar_devolucion()
    OWNER TO postgres;

CREATE TRIGGER actualizar_devolucion AFTER
UPDATE
  ON devuelve FOR EACH ROW
EXECUTE PROCEDURE actualizar_devolucion
();

-- EVALUACION DE NOTA MEDIA --
CREATE FUNCTION public.trabajador_evalua_trabajador()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$DECLARE
  nota SMALLINT := 0;
BEGIN
  IF NEW.ss_trabajador1 NOT IN (SELECT DISTINCT ss_trabajador1
  FROM trabajador_evalua_trabajador)
   	THEN
  UPDATE trabajadores SET nota_media = NEW.nota WHERE trabajadores.ss = NEW.ss_trabajador1;
END
IF;
   
   IF NEW.ss_trabajador1 = NEW.ss_trabajadores
   	THEN RAISE EXCEPTION 'UN TRABAJADOR NO PUEDE PUNTUARSE A SI MISMO';
END
IF;
   RETURN NEW;
END;$BODY$;

ALTER FUNCTION public.trabajador_evalua_trabajador()
    OWNER TO postgres;

CREATE TRIGGER trabajador_evalua_trabajador BEFORE
INSERT or
UPDATE
  ON evalua FOR EACH ROW
EXECUTE PROCEDURE trabajador_evalua_trabajador
();

-- CALCULAR EVALUACION --
CREATE FUNCTION public.calcular_evaluacion()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$DECLARE
  nota SMALLINT := 0;
BEGIN

  UPDATE trabajadores SET nota_media = (SELECT CAST(AVG(nota) AS decimal(10,2)) as media
  FROM trabajador_evalua_trabajador
  WHERE ss_trabajador1 = NEW.ss_trabajador1
  GROUP BY ss_trabajador1 ) WHERE trabajadores.ss = NEW.ss_trabajador1;

  RETURN NEW;
END;$BODY$;

ALTER FUNCTION public.calcular_evaluacion()
    OWNER TO postgres;

CREATE TRIGGER tg_calcular_evaluacion AFTER
INSERT or
UPDATE
  ON evalua FOR EACH ROW
EXECUTE PROCEDURE calcular_evaluacion
();

-- COMPROBAR TICKET COMPRA --

CREATE FUNCTION public.comprobar_ticket_compra()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$DECLARE
BEGIN

  IF ( NEW.cantidad ) < 0 THEN RAISE EXCEPTION 'NO SE PUEDE COMPRAR ALGO NEGATIVO';
END
IF;
		
   RETURN NEW;
END;$BODY$;

ALTER FUNCTION public.comprobar_ticket_compra()
    OWNER TO postgres;

CREATE TRIGGER comprobar_ticket_compra BEFORE
UPDATE OR INSERT
  ON compra FOR EACH ROW
EXECUTE PROCEDURE comprobar_ticket_compra
();

-- SUMA TOTAL TICKET --

CREATE FUNCTION public.suma_ticket()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$DECLARE
BEGIN

  UPDATE tickets SET precio = ( SELECT DISTINCT precio
  FROM tickets
    INNER JOIN compra ON id_tickets = num_tickets
  WHERE num_tickets = NEW.num_tickets ) + (SELECT precio*NEW.cantidad
  FROM productos
  WHERE codigobarras = NEW.codigobarras_productos)
   		WHERE num_tickets = NEW.num_tickets;

  RETURN NEW;
END;$BODY$;

ALTER FUNCTION public.suma_ticket()
    OWNER TO postgres;

CREATE TRIGGER suma_ticket AFTER
INSERT
  ON
compra
FOR
EACH
ROW
EXECUTE PROCEDURE suma_ticket
();

-- RESTA TICKET --

CREATE FUNCTION public.resta_ticket()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$DECLARE
BEGIN

  UPDATE tickets SET precio = ( SELECT DISTINCT precio
  FROM tickets
    INNER JOIN compra ON num_tickets = num_tickets
  WHERE num_tickets = OLD.num_tickets ) - (SELECT precio*OLD.cantidad
  FROM productos
  WHERE codigobarras = OLD.codigobarras_productos)
   		WHERE num_tickets = OLD.num_tickets;

  RETURN NEW;
END;$BODY$;

ALTER FUNCTION public.resta_ticket()
    OWNER TO postgres;

CREATE TRIGGER resta_ticket AFTER
DELETE
  ON compra FOR EACH
ROW
EXECUTE PROCEDURE resta_ticket
();








