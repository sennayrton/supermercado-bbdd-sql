-- GRUPOS --
CREATE GROUP administrador;
CREATE GROUP cajero;
CREATE GROUP gestor;
CREATE GROUP socio;
CREATE GROUP trabajadores;

-- PERMISOS --
GRANT ALL PRIVILEGES ON DATABASE super TO administrador;
GRANT SELECT, UPDATE, INSERT, DELETE ON tickets, compra, devuelve, productos, socio, cajero TO cajero;
GRANT SELECT, UPDATE, INSERT, DELETE 
ON tienda, trabajadores, cajero, reponedor, tickets, socio, productos, ofertas, cupones, opinion, contiene, 
producto_oferta,compra, devuelve, tiene, evalua
TO gestor;
GRANT SELECT ON socio TO socio;
GRANT SELECT, UPDATE, INSERT ON cajero,reponedor TO trabajadores;

-- USUARIOS --
CREATE USER adminis
WITH PASSWORD 'admin' IN GROUP administrador SUPERUSER;
CREATE USER Maria
WITH PASSWORD 'maria' IN GROUP cajero;
CREATE USER Patricia
WITH PASSWORD 'patricia' IN GROUP cajero;
CREATE USER Alberto
WITH PASSWORD 'alberto' IN GROUP cajero;
CREATE USER gestor1
WITH PASSWORD 'gestor1' IN GROUP gestor;
CREATE USER gestor2
WITH PASSWORD 'gestor2' IN GROUP gestor;
CREATE USER Pedro
WITH PASSWORD 'pedro' IN GROUP socio;
CREATE USER Pablo
WITH PASSWORD 'pablo' IN GROUP socio;
CREATE USER Elena
WITH PASSWORD 'elena' IN GROUP socio;
CREATE USER Estefania
WITH PASSWORD 'estefania' IN GROUP socio;
CREATE USER Alvaro
WITH PASSWORD 'alvaro' IN GROUP socio;
CREATE USER trabajador1
WITH PASSWORD 'luis' IN GROUP trabajadores;
CREATE USER trabajador2
WITH PASSWORD 'angel' IN GROUP trabajadores;