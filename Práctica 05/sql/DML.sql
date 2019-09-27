-- UPDATES
UPDATE manejar SET fechafin = '2021-01-12' WHERE idconductor = 2;
UPDATE persona SET direccion = '55270 Ecatepec CDMX' WHERE idpersona = 25;
UPDATE personacorreo SET correo = 'diegoe@ciencias.unam.mx' WHERE idpersona = 1;
UPDATE personacorreo SET correo = 'uncorre@quenoes.falso' WHERE idpersona = 5;
UPDATE personatelefono SET telefono = '5532470293' WHERE idpersona = 9;
UPDATE personatelefono SET telefono = '5532321343' WHERE idpersona = 12;
UPDATE persona SET nombre = 'Diego' WHERE idpersona = 1;

-- DELETES
DELETE FROM formadepago WHERE idviaje = 60;
DELETE FROM viaje WHERE idviaje = 60;
DELETE FROM formadepago USING viaje WHERE formadepago.idviaje = viaje.idviaje AND viaje.idcliente = 7;
DELETE FROM viaje WHERE idcliente = 7;
DELETE FROM tarjeta WHERE idcliente = 7;
DELETE FROM cliente WHERE idcliente = 7;
