--SENTENCIA 1--
SELECT codigobarras, preciosiniva
FROM productos

--SENTENCIA 2--
SELECT nombre,
    CASE WHEN horas IS NULL THEN 'cajero' ELSE 'reponedor' END AS tipo
FROM trabajadores FULL JOIN cajero ON cajero.ss_trabajadores = trabajadores.ss
    FULL JOIN reponedor ON reponedor.ss_trabajadores = trabajadores.ss

--SENTENCIA 3--
SELECT nombre
FROM trabajadores INNER JOIN reponedor ON trabajadores.ss = reponedor.ss_trabajadores
WHERE horas > 20

--SENTENCIA 4--
SELECT sum(precioiva*cantidad)
FROM compra INNER JOIN productos
    ON productos.codigobarras = compra.codigobarras_productos

--SENTENCIA 5--
SELECT numero, codigobarras_productos, descuento
FROM contiene, cupones
--O TAMBIEN--
SELECT numero, codigobarras_productos
FROM contiene INNER JOIN cupones ON cupones.descuento=cupones.descuento

--SENTENCIA 6--
SELECT contiene.codigobarras_productos
FROM cupones INNER JOIN contiene
    ON contiene.numero_cupones =  contiene.numero_cupones

--SENTENCIA 7--
SELECT round(AVG(nota))
FROM opinion

--SENTENCIA 8--
SELECT count(num), ciudad_tienda, cajero
FROM tickets
GROUP BY cajero,ciudad_tienda
ORDER BY count(num) DESC

--SENTENCIA 9--
SELECT count(nombre), ciudad_tienda
FROM trabajadores
GROUP BY ciudad_tienda
ORDER BY count(nombre)

--SENTENCIA 10--
SELECT nombre, fijo, movil
FROM trabajadores
WHERE trabajadores.puntuacion=(SELECT MAX(puntuacion)
FROM trabajadores)

--SENTENCIA 11--
SELECT *
FROM tiene INNER JOIN ofertas ON semana_ofertas = semana_ofertas
WHERE ofertas.inicio >= '2019-05-01' AND ofertas.fin <= '2019-05-05'
ORDER BY inicio

--SENTENCIA 12--
SELECT nombre
FROM socio
WHERE numsocio in (SELECT numsocio_socio
FROM tickets INNER JOIN contiene ON num = num
WHERE fecha >= '2019-05-27' AND fecha <= '2019-05-31' AND codigobarras_productos IN
(SELECT codigobarras_productos
    FROM producto_oferta INNER JOIN ofertas ON semana_ofertas = semana_ofertas
    WHERE inicio >= '2019-05-24' AND fin <= '2019-05-31'
    ORDER BY inicio))

--SENTENCIA 13--
SELECT nombre
FROM trabajadores
WHERE ciudad_tienda like  'M%'
ORDER BY nombre

--SENTENCIA 14--
SELECT email
FROM socio
WHERE saldo=(SELECT MAX(saldo)
FROM socio)

--SENTENCIA 15--
SELECT codigobarras_productos, SUM(cantidad) as total
FROM devuelve
GROUP BY codigobarras_productos
HAVING SUM(cantidad) >= 
(SELECT MAX(total)
FROM (SELECT SUM(cantidad) as total
    FROM devuelve
    GROUP BY 
codigobarras_productos) as total)
ORDER BY total desc

--SENTENCIA 16--
SELECT cajero
FROM tickets
WHERE tickets.cajero=(SELECT MAX(cajero)
FROM tickets)

--SENTENCIA 17--
SELECT nombre, nota
FROM socio, opinion
WHERE socio.numsocio = opinion.numsocio_socio AND opinion.nota = (SELECT MAX(opinion.nota)
    FROM opinion)

--SENTENCIA 18--
SELECT num, productos, cantidad, saldo, cajero, ciudad_tienda
FROM tickets
WHERE cajero like 'A%' AND ciudad_tienda like 'M%'

--SENTENCIA 19--
SELECT num, trabajadores.nombre, tienda.ciudad
FROM tickets, cajero, trabajadores, tienda
WHERE tickets.ss_trabajadores_cajero = cajero.ss_trabajadores AND
    cajero.ss_trabajadores = trabajadores.ss AND trabajadores.ciudad_tienda = tienda.ciudad AND tienda.ciudad = 'ALCALA DE HENARES'

--SENTENCIA 20--
SELECT num, trabajadores.nombre, tienda.ciudad, fecha
FROM tickets, cajero, trabajadores, tienda
WHERE tickets.ss_trabajadores_cajero = cajero.ss_trabajadores AND
    cajero.ss_trabajadores = trabajadores.ss AND trabajadores.ciudad_tienda = tienda.ciudad
    AND tienda.ciudad = 'ALCALA DE HENARES' AND num NOT IN 
(        (
        SELECT num
        FROM tickets
        WHERE numsocio_socio NOT IN ( SELECT numsocio_socio
        FROM contiene INNER JOIN
            ( SELECT numero, numsocio_socio
            FROM tiene INNER JOIN cupones ON numero = numero ) 
AS cupones_socios ON cupones_socios.numero = contiene.numero_cupones )
        )
    INTERSECT
        (SELECT num_tickets
        FROM compra INNER JOIN ( SELECT codigobarras_productos
            FROM contiene INNER JOIN
                ( SELECT numero, numsocio_socio
                FROM tiene INNER JOIN cupones ON numero = numero ) 
AS cupones ON cupones.numero = contiene.numero_cupones ) as p
            ON p.codigobarras_productos = compra.codigobarras_productos)
) AND num NOT IN (SELECT DISTINCT num_tickets
    FROM tickets, ( SELECT *
        FROM productos, ofertas, compra, producto_oferta
        WHERE producto_oferta.codigobarras_productos = productos.codigobarras
            AND compra.codigobarras_productos = productos.codigobarras ) as fecha
    WHERE num_tickets = num_tickets
        AND tickets.fecha BETWEEN fecha.inicio AND fecha.fin)