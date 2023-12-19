/*trigger para que ante una poliza nueva con ajusta_dolar TRUE guarde en tabla contacto_cliente  como uno nuevo contacto para 
tener  en esta tabla para el control de la posventa. 
*/

START TRANSACTION;

USE cartera_cliente;


DELIMITER $$
CREATE TRIGGER insert_contacto_cliente_aft_poliza_nueva
AFTER INSERT ON polizas
FOR EACH ROW
BEGIN
    IF NEW.sa_ajustado_dolar = 1 THEN
        INSERT INTO contacto_cliente ( Ultimo_Contacto_Cliente, comentarios, id_poliza)
        VALUES (CURDATE(), 'alta nueva',NEW.id_poliza);
    END IF;
END;
$$
DELIMITER ;


--- triger para fecha de carga automatico en contacto_cliente
DELIMITER //

CREATE TRIGGER insert_default_date_contacto_cliente
BEFORE INSERT ON contacto_cliente
FOR EACH ROW
BEGIN
    IF NEW.utlimo_contacto_cliente IS NULL THEN
        SET NEW.utlimo_contacto_cliente = CURDATE();
    END IF;
END;
//

DELIMITER ;