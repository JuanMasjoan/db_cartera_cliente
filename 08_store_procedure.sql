START TRANSACTION ; 

use cartera_cliente;

/* esto es para agregar clientes nuevos*/
DROP PROCEDURE IF EXISTS cartera_cliente.SP_ALTA_CLIENTES;
DELIMITER $$
CREATE PROCEDURE cartera_cliente.SP_ALTA_CLIENTES(in par_id_dni varchar(100), in par_nom_apell varchar(200), 
in par_cuit bigint, in par_representante varchar(100),in par_fecha_nac date,in par_id_estado_civil int,
in par_dir_part varchar(150),in par_dir_legal varchar(150),in par_codigo_postal int,in par_id_provincia int,
in par_tel varchar(150), in par_mail varchar(150), in observ varchar(150))
BEGIN
/* clientes */
    insert into cartera_cliente.clientes(id_dni,nom_apell,representante,fecha_nac,id_estado_civil,
        dir_part,dir_legal,codigo_postal, id_provincia, tel,mail,observ,cuit)
        values (par_id_dni,par_nom_apell,par_representante,par_fecha_nac,par_id_estado_civil,par_dir_part,
        par_dir_legal,par_codigo_postal,par_id_provincia,par_tel,par_mail,observ, par_cuit);
END
$$ DELIMITER ;

SAVEPOINT SP_ALTA_CLIENTES;

-- ordenar siniestros por lo que quiera
DROP PROCEDURE IF EXISTS CARTERA_CLIENTE.SP_ORDENAR_SINIESTROS ;
DELIMITER $$
CREATE PROCEDURE CARTERA_CLIENTE.SP_ORDENAR_SINIESTROS (INOUT column_to_orden VARCHAR(50) ,
 INOUT column_asc_desc VARCHAR(50))
BEGIN
  SET @ordenar = CONCAT('SELECT * FROM cartera_cliente.vw_siniestros stro order by ',
     column_to_orden,' ',column_asc_desc);  
  PREPARE param_stmt FROM @ordenar;
  EXECUTE param_stmt;  
  DEALLOCATE PREPARE param_ordenar;
END 
$$ DELIMITER ;

SAVEPOINT SP_ORDENAR_SINIESTROS;
/* SET @column_to_orden = 'estado_siniestro';
SET @column_asc_desc = 'asc'; 
CALL CARTERA_CLIENTE.SP_ORDENAR_SINIESTROS (@column_to_orden, @column_asc_desc); */
0
-- alta de polizas nueva 
DROP PROCEDURE IF EXISTS cartera_cliente.SP_ALTA_POLIZA;
DELIMITER $$
create PROCEDURE cartera_cliente.SP_ALTA_POLIZA (IN par_poliza varchar(40),IN par_productor int,
IN par_dni varchar(100),IN par_cia int,IN par_ramo int,IN par_descrip varchar(150),IN par_fecha_alta date,
IN par_fecha_baja date, in par_refacturacion date,IN par_forma_pago int,IN par_cuotas int,IN par_ciclo_facturacion int,
IN par_prima int,IN par_estado int,IN par_ajustado_dolar tinyint(1), IN par_cbu_tc BIGINT)
BEGIN
    insert into cartera_cliente.polizas (id_poliza, id_productor,id_dni,id_cia,id_ramo,descrip,fecha_alta,
        fecha_baja,fecha_refacturacion,id_forma_pago_clientes,id_cuotas,id_ciclo_facturacion,prima,id_estado_poliza,
        sa_ajustado_dolar, cbu_tc)
        values (par_poliza, par_productor,par_dni,par_cia,par_ramo,par_descrip,par_fecha_alta,
        par_fecha_baja,par_refacturacion,par_forma_pago,par_cuotas,par_ciclo_facturacion,par_prima,
        par_estado,par_ajustado_dolar, par_cbu_tc);
END
$$ DELIMITER;

SAVEPOINT SP_ALTA_POLIZA;

-- CARGA DE FACTURAS
DROP PROCEDURE IF EXISTS cartera_cliente.SP_CARGA_FACTURA;
DELIMITER $$
CREATE PROCEDURE cartera_cliente.SP_CARGA_FACTURA (in p_factura int,in p_fecha_factura date,in tipo_factura varchar (5),
in id_cia int,in mes_comisiones int,in monto_comisiones float,in retenciones_comisiones float,in cobrada tinyint(1))
	begin
		insert into cartera_cliente.comisiones_facturas (numero_factura,fecha_factura,tipo_factura,id_cia,mes_comisiones,
			monto_comisiones,retenciones_comisiones,cobrada)
		values (p_factura,p_fecha_factura,tipo_factura,id_cia,mes_comisiones,
			monto_comisiones,retenciones_comisiones,cobrada);
	end	
$$ DELIMITER ;

SAVEPOINT SP_CARGA_FACTURA;

-- COMPARA LAS COMISIONES POR RAMO
DROP PROCEDURE IF EXISTS SP_COMISIONESXRAMO;
DELIMITER $$
CREATE PROCEDURE cartera_cliente.SP_COMISIONESXRAMO ( inout ramo_buscar int)
BEGIN 
-- COMPARA LAS COMISIONES POR RAMO
	select cia as compania, ramo, nombre_plan_comision, comision from vw_comision
	WHERE id_ramo = ramo_buscar
	order by comision desc
;
END
$$ DELIMITER ;

SAVEPOINT SP_COMISIONESXRAMO;

-- COMPARA LAS COMISIONES POR RAMO
DROP PROCEDURE IF EXISTS SP_COMISIONESXCIA;
DELIMITER $$
CREATE PROCEDURE cartera_cliente.SP_COMISIONESXCIA ( inout cia_buscar int)
BEGIN 
-- COMPARA LAS COMISIONES POR RAMO
	select cia as compania, ramo, nombre_plan_comision, comision from vw_comision
	WHERE id_cia = cia_buscar
	order by comision desc
;
$$ DELIMITER ;

-- buscador de certificados por poliza
DELIMITER $$
CREATE PROCEDURE cartera_cliente.SP_CERTXPOLIZA ( inout poliza_buscar int)
BEGIN 
-- buscador de certificados por poliza
	select id_dni as DNI, nom_apell as cliente, id_poliza as poliza, descripcion_certificado as descripcion,
	dni_certificado,nombre_certificado, fecha_nacimiento_certificado as nacimiento, estado_certificados, vigencia
	 from vw_cert_polizas
     where id_poliza = poliza_buscar
;
END
$$ DELIMITER ; 

SAVEPOINT SP_CERTXPOLIZA;

/* ALTA DE CERT EN POLIZA EXISTENTE*/
DROP PROCEDURE IF EXISTS cartera_cliente.SP_ALTA_CERT;
DELIMITER $$
CREATE PROCEDURE cartera_cliente.SP_ALTA_CERT (in p_dni bigint, in p_poliza bigint,
in p_numcert int, in p_desc varchar(100), in p_dni_cert int, p_nom_cert varchar(45), in p_nac_cert date)
BEGIN
	insert into cartera_cliente.certificados_polizas (id_dni,id_poliza,num_certificados,descripcion_certificado,
    dni_certificado,nombre_certificado,fecha_nacimiento_certificado,id_estado_certificados)
		values (p_dni, p_poliza, p_numcert, p_desc, p_dni_cert, p_nom_cert, p_nac_cert,1);
END
$$ DELIMITER ;


-- alta de USUARIO
DROP PROCEDURE IF EXISTS cartera_cliente.SP_ALTA_USUARIO;
DELIMITER $$
create PROCEDURE  cartera_cliente.SP_ALTA_USUARIO (IN par_user varchar(50),
IN par_pass varchar(200))
BEGIN
    insert into cartera_cliente.user (username, password)
        values (par_user,par_pass);
END
$$ DELIMITER;


-- insertar siniestro


DROP PROCEDURE IF EXISTS cartera_cliente.sp_insertar_siniestro;
DELIMITER $$
CREATE PROCEDURE sp_insertar_siniestro(IN p_numero_siniestro VARCHAR(45),IN p_id_poliza BIGINT,IN p_id_tipo_siniestro INT,
                IN p_id_estado_siniestro INT,IN p_fecha_siniestro DATETIME,IN p_comen_stro VARCHAR(300),
                IN p_descripcion_siniestro LONGTEXT, IN p_hora_stro time, IN ubicacion_siniestro VARCHAR(80) )
BEGIN
    DECLARE v_id_siniestro INT;
    
    SET descripcion_comprimido = COMPRESS(p_descripcion_siniestro);

    SET v_id_siniestro = fx_ins_stro(p_numero_siniestro,p_id_poliza,p_id_tipo_siniestro,p_id_estado_siniestro,p_fecha_siniestro,
                  p_comen_stro,descripcion_comprimido,p_hora_stro,ubicacion_siniestro);
    
    SELECT v_id_siniestro AS id_siniestro;
END;
$$
DELIMITER ;

SAVEPOINT SP_STRO_1;

-- actualizar siniestro

DROP PROCEDURE IF EXISTS cartera_cliente.sp_actualizar_siniestro;
DELIMITER $$
CREATE PROCEDURE sp_actualizar_siniestro(IN p_id_siniestro INT,IN p_id_estado_siniestro INT,
                IN p_comen_stro VARCHAR(300))
BEGIN
    DECLARE v_success BOOLEAN;
    
    SET v_success = fx_upd_stro(p_id_siniestro,p_id_estado_siniestro,p_comen_stro);
    
    SELECT v_success AS success;
END;
$$
DELIMITER ;

DROP PROCEDURE IF EXISTS cartera_cliente.sp_buscar_cliente;
DELIMITER $$

CREATE PROCEDURE sp_buscar_cliente(
    IN p_campo_busqueda VARCHAR(40), 
    IN p_valor_buscar VARCHAR(100)
)
BEGIN

    DECLARE v_result_count INT;

    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_resultados (DNI INT, titular VARCHAR(100));

    SET @sql_query = CONCAT('SELECT DNI, titular FROM vw_clientes WHERE ', p_campo_busqueda, ' LIKE CONCAT("%", ?, "%")');

   
    PREPARE stmt FROM @sql_query;
    SET @p_valor_buscar = p_valor_buscar;
    EXECUTE stmt USING @p_valor_buscar;
    DEALLOCATE PREPARE stmt;

    SELECT COUNT(*) INTO v_result_count FROM tmp_resultados;

    IF v_result_count > 0 THEN
        SELECT DNI, titular FROM tmp_resultados;
    ELSE
        SELECT NULL AS DNI, 'Cliente no encontrado' AS titular;
    END IF;

    DROP TEMPORARY TABLE IF EXISTS tmp_resultados;
END;
$$
DELIMITER ;

SAVEPOINT SP_BUSCAR_CLIENTE;

-- AUTOMATIZACION DE TAREAS 
DROP PROCEDURE IF EXISTS cartera_cliente.sp_upd_diarias;
DELIMITER $$
CREATE PROCEDURE cartera_cliente.sp_upd_diarias(IN p_fecha_avencer DATE,IN p_fecha_efect DATE, IN p_fechas_ult_upd DATE)
BEGIN
    DECLARE v_modifications_vencida INT;
    DECLARE v_modifications_avencida INT;
    DECLARE v_modifications_efect INT;
    DECLARE v_ultima_fecha_upd DATE;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT MAX(fecha_ult_upd) INTO v_ultima_fecha_upd
    FROM tg_fecha_ult_upd;

    IF v_ultima_fecha_upd = CURDATE() THEN
        SELECT 'Realizado hoy' AS mensaje;
    ELSE
        SET v_modifications_vencida = fx_poliza_vencida(1);
        SET v_modifications_avencida = fx_poliza_avencida(p_fecha_avencer);
        SET v_modifications_efect = fx_poliza_efect(p_fecha_efect, p_fecha_avencer);

        INSERT INTO cartera_cliente.tg_fecha_ult_upd (fecha_ult_upd)
        VALUES (NOW());

        SELECT 'fx_poliza_vencida' AS funcion, v_modifications_vencida AS modificaciones
        UNION ALL
        SELECT 'fx_poliza_avencida' AS funcion, v_modifications_avencida AS modificaciones
        UNION ALL
        SELECT 'fx_poliza_efect' AS funcion, v_modifications_efect AS modificaciones;
       
	END IF;

  
    COMMIT;
END;



DROP PROCEDURE IF EXISTS cartera_cliente.sp_dias_ult_upd;
DELIMITER $$
CREATE PROCEDURE sp_dias_ult_upd (IN p_realizar INT, out p_succes int)
BEGIN
    DECLARE  v_dias_ult_upd  BOOLEAN;
    
    SELECT DATEDIFF(NOW(), MAX(fecha_ult_upd)) INTO v_dias_ult_upd FROM tg_fecha_ult_upd
    
   
    
    SET  p_success = v_success ;
END;
$$
DELIMITER ;

SAVEPOINT SP_DIAS_ULT_UPD;


-- RENOVADOR DE POLIZAS

DROP PROCEDURE IF EXISTS cartera_cliente.sp_alta_pol_renov;
DELIMITER $$
CREATE PROCEDURE cartera_cliente.sp_alta_pol_renov(IN par_poliza varchar(40), IN par_productor int,
                                IN par_dni varchar(100),IN par_cia int, IN par_ramo int, IN par_descrip varchar(150),IN par_fecha_alta date,
                                IN par_fecha_baja date,IN par_refacturacion date,IN par_forma_pago int,IN par_cbu_tc varchar(1000), 
                                IN par_cuotas int,IN par_ciclo_facturacion int,IN par_prima int,IN par_estado int,
                                IN par_ajustado_dolar tinyint(1), par_poliza_renov tinyint(1),IN par_pol_renovada varchar(80),
                                IN par_estado_renov int) 

BEGIN
    DECLARE v_insert_pol_renov INT;
    DECLARE v_upd_estado INT;


    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SET v_insert_pol_renov = fx_alta_poliza_renov (par_poliza,par_productor,par_dni,par_cia,par_ramo,par_descrip,par_fecha_alta,
                                                    par_fecha_baja,par_refacturacion,par_forma_pago,par_cbu_tc,par_cuotas,
                                                    par_ciclo_facturacion,par_prima,par_estado,par_ajustado_dolar,par_poliza_renov
                                                    );

    SET v_upd_estado = fx_cambio_estado(par_pol_renovada, par_estado_renov);

    SELECT 'Poliza creada correctamente' AS funcion, v_insert_pol_renov AS modificaciones
    UNION ALL
    SELECT 'poliza renovada correctamente' AS funcion, v_upd_estado AS modificaciones;
    
    COMMIT;

END;

-- SP cases

DELIMITER $$

CREATE PROCEDURE vw_busc_case1(IN p_vw_buscar VARCHAR(100))
BEGIN
    SELECT *
    FROM p_vw_buscar;
END $$

CREATE PROCEDURE vw_busc_case2(IN p_vw_buscar VARCHAR(100), IN p_id VARCHAR(100), IN p_dato_buscar VARCHAR(100))
BEGIN
    SELECT *
    FROM p_vw_buscar
    WHERE p_id = p_dato_buscar;
END $$

CREATE PROCEDURE vw_busc_case3(IN p_vw_buscar VARCHAR(100), IN p_id VARCHAR(100), IN p_dato_buscar VARCHAR(100))
BEGIN
    SELECT *
    FROM p_vw_buscar
    WHERE p_id LIKE CONCAT('%', p_dato_buscar, '%');
END $$

CREATE PROCEDURE vw_busc_case4(IN p_vw_buscar VARCHAR(100), IN p_id VARCHAR(100), IN p_dato_buscar VARCHAR(100), IN p_dato_buscar2 VARCHAR(100))
BEGIN
    SELECT *
    FROM p_vw_buscar
    WHERE (p_id BETWEEN p_dato_buscar AND p_dato_buscar2) OR (p_id = p_dato_buscar);
END $$

CREATE PROCEDURE vw_busc_case5(IN p_vw_buscar VARCHAR(100), IN p_id VARCHAR(100), IN p_dato_buscar VARCHAR(100), IN p_id2 VARCHAR(100), IN p_dato_buscar2 VARCHAR(100))
BEGIN
    SELECT *
    FROM p_vw_buscar
    WHERE p_id = p_dato_buscar AND p_id2 = p_dato_buscar2;
END $$

DELIMITER ;

SAVEPOINT SP_VW_BUSC_CASE3;

-- sp uso de case 
DELIMITER $$

CREATE PROCEDURE sp_busc_vw(IN p_vw_buscar VARCHAR(100),IN p_filtro INT, IN p_id VARCHAR(100), 
                    IN p_dato_buscar VARCHAR(100), IN p_dato_buscar2 VARCHAR(100),IN p_id2 VARCHAR(100))
BEGIN
    DECLARE custom_error CONDITION FOR SQLSTATE '45000';
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET @custom_error_message = 'Valor de filtro no válido';
        SIGNAL custom_error;
    END;

    CASE p_filtro
        WHEN 1 THEN
            CALL vw_busc_case1(p_vw_buscar);
        WHEN 2 THEN
            CALL vw_busc_case2(p_vw_buscar, p_id, p_dato_buscar);
        WHEN 3 THEN
            CALL vw_busc_case3(p_vw_buscar, p_id, p_dato_buscar);
        WHEN 4 THEN
            CALL vw_busc_case4(p_vw_buscar, p_id, p_dato_buscar, p_dato_buscar2);
        WHEN 5 THEN
            CALL vw_busc_case5(p_vw_buscar, p_id, p_dato_buscar, p_id2, p_dato_buscar2);
        ELSE
            SIGNAL custom_error;
    END CASE;
END $$

DELIMITER ;

-- upd panel cliente 1
DELIMITER $$
CREATE PROCEDURE cartera_cliente.sp_panel_cliente_pol(
    IN p_dni VARCHAR(70)
)
BEGIN
    DECLARE v_cliente_pol INT;
    
    SELECT COUNT(*) INTO v_cliente_pol
    FROM cartera_cliente.vw_pol_act
    WHERE id_dni = p_dni;

    IF v_cliente_pol > 0 THEN
        SELECT *
        FROM cartera_cliente.vw_pol_act
        WHERE id_dni = p_dni;
    ELSE
        SELECT 'No posee polizas activas' AS resultado;
    END IF;
END;
$$
DELIMITER ;

-- upd panel cliente 2
DROP PROCEDURE IF EXISTS cartera_cliente.sp_panel_cliente_pol2;

DELIMITER $$
CREATE PROCEDURE cartera_cliente.sp_panel_cliente_pol2(
    IN p_dni VARCHAR(70)
)
BEGIN
    DECLARE v_cliente_pol INT;
    
    SELECT COUNT(*) INTO v_cliente_pol
    FROM cartera_cliente.vw_polizas
    WHERE id_dni = p_dni;

    IF v_cliente_pol > 0 THEN
        SELECT *
        FROM cartera_cliente.vw_polizas
        WHERE id_dni = p_dni
		AND id_estado_poliza NOT IN (1 , 10);
    ELSE
        SELECT 'Sin Polizas Historicas' AS resultado; 
    END IF;
END;
$$
DELIMITER ;

SAVEPOINT SP_PANEL_CLIENTE_POL2;


-- upd panel cliente info
DROP PROCEDURE IF EXISTS cartera_cliente.sp_panel_cliente_info;

DELIMITER $$
CREATE PROCEDURE cartera_cliente.sp_panel_cliente_info(
    IN p_dni VARCHAR(70)
)
BEGIN
    DECLARE v_cliente_info INT;
    
    SELECT COUNT(*) INTO v_cliente_info
    FROM cartera_cliente.vw_clientes
    WHERE DNI = p_dni;

    IF v_cliente_info > 0 THEN
        SELECT *
        FROM cartera_cliente.vw_clientes
        WHERE DNI = p_dni;
    ELSE
        SELECT 'Cliente no encontrado' AS resultado; 
    END IF;
END;
$$
DELIMITER ;


-- insert facturas
DROP PROCEDURE IF EXISTS cartera_cliente.sp_ins_factura;
DELIMITER $$
    CREATE PROCEDURE cartera_cliente.sp_ins_factura(
        IN  p_numero_factura INT,IN p_fecha_factura DATE,IN p_tipo_factura VARCHAR(10),
        IN p_id_cia INT, IN p_mes_comisiones INT, IN p_monto_comisiones INT,IN p_retenciones_comisiones INT,
        IN P_cobrada BOOLEAN,IN p_ano_comision INT, IN p_pto_venta INT,IN p_titular_factura VARCHAR(200))

BEGIN

    DECLARE v_factura_insert INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SET v_factura_insert = fx_carga_factura(p_numero_factura, p_fecha_factura, p_tipo_factura, p_id_cia,
                                    p_mes_comisiones, p_monto_comisiones, p_retenciones_comisiones,
                                    p_cobrada, p_ano_comision, p_pto_venta, p_titular_factura);

    SELECT  v_factura_insert AS resultado;
    
    COMMIT;
END;
$$
DELIMITER ;


DROP PROCEDURE IF EXISTS cartera_cliente.sp_fact_cia;

DELIMITER $$
CREATE PROCEDURE cartera_cliente.sp_fact_cia()
BEGIN
    SELECT * FROM vw_adm_fac_tot;
    
    SELECT * FROM vw_adm_sum_fac_cia;
    
END $$

DELIMITER ;

SAVEPOINT SP_FACT_CIA;


-- cobro de factura
DELIMITER $$

CREATE PROCEDURE sp_actualizar_cobro(p_fact INT)
BEGIN 

	SELECT fx_fact_cobrada(p_fact);
    
END;
$$

DELIMITER ;


-- fx mod de polizas en panel de clientr
DROP PROCEDURE IF EXISTS cartera_cliente.sp_mod_pan_cl;
DELIMITER $$
CREATE PROCEDURE cartera_cliente.sp_mod_pan_cl (IN p_fecha_avencer bigint,IN p_fecha_efect float)
BEGIN
    DECLARE v_modifications_vencida INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT MAX(fecha_ult_upd) INTO v_ultima_fecha_upd
    FROM tg_fecha_ult_upd;

    IF v_ultima_fecha_upd = CURDATE() THEN
        SELECT 'Realizado hoy' AS mensaje;
    ELSE
        SET v_modifications_vencida = fx_poliza_vencida(1);
        SET v_modifications_avencida = fx_poliza_avencida(p_fecha_avencer);
        SET v_modifications_efect = fx_poliza_efect(p_fecha_efect, p_fecha_avencer);

        INSERT INTO cartera_cliente.tg_fecha_ult_upd (fecha_ult_upd)
        VALUES (NOW());

        SELECT 'fx_poliza_vencida' AS funcion, v_modifications_vencida AS modificaciones
        UNION ALL
        SELECT 'fx_poliza_avencida' AS funcion, v_modifications_avencida AS modificaciones
        UNION ALL
        SELECT 'fx_poliza_efect' AS funcion, v_modifications_efect AS modificaciones;
       
	END IF;

  
    COMMIT;
END;


-- FX mod prima
DROP PROCEDURE IF EXISTS cartera_cliente.sp_mod_prima;
DELIMITER $$
    CREATE PROCEDURE cartera_cliente.sp_mod_prima(IN p_polizas bigint ,IN p_prima float)
BEGIN

    DECLARE v_mod_prima INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SET v_mod_prima = fx_mod_prima( p_polizas, p_prima);

    SELECT  v_mod_prima AS resultado;
    
    COMMIT;
END;
$$
DELIMITER ;


-- FX mod Estado poliza
DROP PROCEDURE IF EXISTS cartera_cliente.sp_mod_estado;
DELIMITER $$
    CREATE PROCEDURE cartera_cliente.sp_mod_estado(IN p_polizas bigint ,IN p_estado int)
BEGIN

    DECLARE v_mod_estado INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SET v_mod_estado = fx_cambio_estado( p_polizas, p_estado);

    SELECT  v_mod_estado AS resultado;
    
    COMMIT;
END;
$$
DELIMITER ;

SAVEPOINT SP_MOD_ESTADO;


-- FX mod Estado poliza
DROP PROCEDURE IF EXISTS cartera_cliente.sp_mod_descrip;
DELIMITER $$
    CREATE PROCEDURE cartera_cliente.sp_mod_descrip(IN p_polizas bigint ,IN p_descrip varchar(200))
BEGIN

    DECLARE v_mod_descrip INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SET v_mod_descrip = fx_mod_desc_poliza( p_polizas, p_descrip);

    SELECT  v_mod_descrip AS resultado;
    
    COMMIT;
END;
$$
DELIMITER ;


-- INFO PARA DAR DE ALTA UNA POLIZA
DROP PROCEDURE if exists cartera_cliente.sp_info_inser_poliza;
DELIMITER $$
CREATE PROCEDURE sp_info_inser_poliza()
BEGIN

    SELECT 'SEPARADOR' AS separador;
    
    SELECT id_productor, productor FROM productor;    
    SELECT 'SEPARADOR' AS separador;
	
    SELECT id_ramo, ramo FROM ramo;    
    SELECT 'SEPARADOR' AS separador;
    
    SELECT id_cia, cia FROM cia;
    SELECT 'SEPARADOR' AS separador;
    
	SELECT id_forma_pago_clientes, forma_pago_cliente FROM forma_pago_clientes;
    SELECT 'SEPARADOR' AS separador;
    
    SELECT id_ciclo_facturacion, ciclo_facturacion FROM ciclo_facturacion;
    SELECT 'SEPARADOR' AS separador;
    
    SELECT id_estado_poliza, estado_poliza FROM estado_poliza;
   
END
$$
DELIMITER ;

-- FX mod Estado poliza
DROP PROCEDURE IF EXISTS cartera_cliente.sp_mod_form_pago;
DELIMITER $$
CREATE PROCEDURE cartera_cliente.sp_mod_form_pago(IN p_polizas bigint ,IN p_forma_pago varchar(200))
BEGIN

    DECLARE v_forma_pago INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SET v_forma_pago = fx_mod_froma_pago( p_polizas, p_forma_pago);

    SELECT  v_forma_pago AS resultado;
    
    COMMIT;
END;
$$
DELIMITER ;

SAVEPOINT SP_MOD_FORM_PAGO;


-- FX mod Cliente
/* CASE 1 DIRECCION PARTICULAR
    CASE 2 DIRECCION LEGAL
    CASE 3 Codigo Postal
    CASE 4 Telefono
    CASE 5 Email

*/
DROP PROCEDURE IF EXISTS cartera_cliente.sp_mod_cliente;
DELIMITER $$
    CREATE PROCEDURE cartera_cliente.sp_mod_cliente(IN p_dato INT,IN p_dni bigint ,IN p_dato_insert varchar(200))
BEGIN

    DECLARE v_mod_cliente INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    CASE 
        WHEN p_dato = 1 THEN 
            
                SET v_mod_cliente = fx_mod_dir_part( p_dni, p_dato_insert);
        WHEN p_dato = 2 THEN
                SET v_mod_cliente = fx_mod_dir_legal( p_dni, p_dato_insert);
        WHEN p_dato = 3 THEN
                SET v_mod_cliente =fx_mod_cod_posta( p_dni, p_dato_insert);
        WHEN p_dato = 4 THEN
                SET v_mod_cliente = fx_mod_tel( p_dni, p_dato_insert);
        WHEN p_dato = 5 THEN
                SET v_mod_cliente = fx_mod_mail( p_dni, p_dato_insert);
        ELSE
            SET v_mod_cliente = 0;
    END CASE;

    SELECT  v_mod_cliente AS resultado;
    
    COMMIT;
END;
$$
DELIMITER ;


-- INFO PARA DAR DE ALTA UNA POLIZA
DROP PROCEDURE if exists cartera_cliente.sp_info_inser_cliente ;
DELIMITER $$
CREATE PROCEDURE sp_info_inser_poliza()
BEGIN

    SELECT 'SEPARADOR' AS separador;
    
    SELECT id_provincia, provincia FROM provincia;    
    SELECT 'SEPARADOR' AS separador;
	
    SELECT id_estado_civil, estado_civil FROM estado_civil;    
    
    
END
$$
DELIMITER ;



-- INFO PARA DAR DE ALTA UNA POLIZA
DROP PROCEDURE if exists cartera_cliente.sp_info_inser_stro ;
DELIMITER $$
CREATE PROCEDURE sp_info_inser_stro()
BEGIN

    SELECT 'SEPARADOR' AS separador;
    select id_estado_siniestro, estado_siniestro from estado_siniestro ;

    SELECT 'SEPARADOR' AS separador;
	
    select id_tipo_siniestro,tipo_siniestro from tipo_siniestro;
    
    
END
$$
DELIMITER ;

SAVEPOINT SP_INFO_INSER_STRO;

-- upd panel Diario 1 -- en mora 
DROP PROCEDURE IF EXISTS cartera_cliente.sp_panel_diario_1;

DELIMITER $$
CREATE PROCEDURE cartera_cliente.sp_panel_diario_1()
BEGIN
    DECLARE v_cliente_pol_mora INT;
    
    SELECT COUNT(*) INTO v_cliente_pol_mora
    FROM cartera_cliente.vw_polizas_enmora;

    IF v_cliente_pol_mora > 0 THEN
        SELECT *
        FROM cartera_cliente.vw_polizas_enmora;
    ELSE
        SELECT 'Sin Polizas en mora' AS resultado; 
    END IF;
END;
$$
DELIMITER ;



-- upd panel Diario 2 -- A vencer
DROP PROCEDURE IF EXISTS cartera_cliente.sp_panel_diario_2;

DELIMITER $$
CREATE PROCEDURE cartera_cliente.sp_panel_diario_2()
BEGIN
    DECLARE v_cliente_pol_avencer INT;
    
    SELECT COUNT(*) INTO v_cliente_pol_avencer
    FROM cartera_cliente.vw_polizas_avencer;

    IF v_cliente_pol_avencer > 0 THEN
        SELECT *
        FROM cartera_cliente.vw_polizas_avencer;
    ELSE
        SELECT 'Sin Polizas a Vencer' AS resultado; 
    END IF;
END;
$$
DELIMITER ;


-- upd panel Diario 3-- Vencida
DROP PROCEDURE IF EXISTS cartera_cliente.sp_panel_diario_3;

DELIMITER $$
CREATE PROCEDURE cartera_cliente.sp_panel_diario_3()
BEGIN
    DECLARE v_cliente_pol_vencer INT;
    
    SELECT COUNT(*) INTO v_cliente_pol_vencer
    FROM cartera_cliente.vw_polizas_vencida;

    IF v_cliente_pol_vencer > 0 THEN
        SELECT *
        FROM cartera_cliente.vw_polizas_vencida;
    ELSE
        SELECT 'Sin Polizas Vencidas' AS resultado; 
    END IF;
END;
$$
DELIMITER ;

SAVEPOINT SP_PANEL_DIARIO_3;


-- upd panel Diario 4-- ajustado a dolar
DROP PROCEDURE IF EXISTS cartera_cliente.sp_panel_diario_4;

DELIMITER $$
CREATE PROCEDURE cartera_cliente.sp_panel_diario_4(IN p_fecha_consultar DATE)
BEGIN
    DECLARE v_cliente_pol_ajustado_dolar INT;
    
    SELECT COUNT(*) INTO v_cliente_pol_ajustado_dolar
    FROM cartera_cliente.vw_polizas_vencida;

    IF v_cliente_pol_ajustado_dolar > 0 THEN
        SELECT *
        FROM cartera_cliente.vw_poliza_sadolar
        WHERE vencimiento_contacto_cliente < p_fecha_consultar ;
    ELSE
        SELECT 'Sin Polizas para contactas' AS resultado; 
    END IF;
END;
$$
DELIMITER ;


-- INFO PARA DAR DE ALTA UNA POLIZA
DROP PROCEDURE if exists cartera_cliente.sp_info_panel_diario_1 ;
DELIMITER $$
CREATE PROCEDURE sp_info_panel_diario_1()
BEGIN

    -- SELECT 'SEPARADOR' AS separador;
    select * from vw_t_estado_poliza ;

    
END
$$
DELIMITER ;


-- modificar estado de la poliza
DROP PROCEDURE IF EXISTS cartera_cliente.sp_mod_estado_poliza;
DELIMITER $$
    CREATE PROCEDURE cartera_cliente.sp_mod_estado_poliza(IN btn_cambio_estado BIGINT,IN p_valor_estado INT)
BEGIN

    DECLARE v_mod_cliente INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
    SET v_mod_cliente = fx_cambio_estado( btn_cambio_estado, p_valor_estado);

    SELECT  v_mod_cliente AS resultado;
    
    COMMIT;
END;
$$
DELIMITER ;

SAVEPOINT SP_MOD_ESTADO_POLIZA;

-- cambiar comentarios en contacto_cliente
DROP PROCEDURE IF EXISTS cartera_cliente.sp_mod_contacto_cliente;
DELIMITER $$
    CREATE PROCEDURE cartera_cliente.sp_mod_contacto_cliente(
        IN par_utlimo_contacto_cliente DATE, 
        IN  par_comentarios varchar(150),
        IN par_id_poliza BIGINT)

BEGIN
    DECLARE v_mod__contacto_cliente varchar(20);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SET v_mod__contacto_cliente = fx_mod_contacto_cliente( par_utlimo_contacto_cliente, par_comentarios, 
                        par_id_poliza);

    SELECT  v_mod__contacto_cliente AS resultado;
    
    COMMIT;
END;
$$
DELIMITER ;


-- cambiar vencimiento en contacto_cliente
DROP PROCEDURE IF EXISTS cartera_cliente.sp_mod_contacto_cliente_vencimiento;
DELIMITER $$
    CREATE PROCEDURE cartera_cliente.sp_mod_contacto_cliente_vencimiento(
        IN par_utlimo_contacto_cliente DATE, 
        IN  par_comentarios varchar(150),
        IN par_id_poliza BIGINT,
        IN par_vencimiento_contacto DATE)

BEGIN
    DECLARE v_mod__contacto_cliente varchar(20);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SET v_mod__contacto_cliente = fx_mod_contacto_cliente_vencimiento( par_utlimo_contacto_cliente, par_comentarios, 
                        par_id_poliza, par_vencimiento_contacto);

    SELECT  v_mod__contacto_cliente AS resultado;
    
    COMMIT;
END;
$$
DELIMITER ;


DROP PROCEDURE IF EXISTS sp_consulta_info_cantidad_polizas_ramo;
-- pasar la info para ver las polizas x ramo
DELIMITER //
CREATE PROCEDURE sp_consulta_info_cantidad_polizas_ramo(
)
BEGIN

    -- Consulta 1: Contar cantidad por ramo
    SELECT ramo, COUNT(ramo) AS Cantidad_ramo
    FROM vw_pol_act
    GROUP BY ramo
	ORDER BY Cantidad_ramo desc;
    
        -- Consulta 2: Contar cantidad por cia
    SELECT cia, COUNT(cia) AS Cantidad_cia
    FROM vw_pol_act
    GROUP BY cia 
	ORDER BY Cantidad_cia desc;
    
    -- consulta 3 : info para las cias
    SELECT * 
    FROM cia;
    
    -- consulta 4 : info para las ramas
    SELECT * 
    FROM RAMO;
    
END//

DELIMITER ;

SAVEPOINT sp_consulta_info_cantidad_polizas_ramo;

-- consulta para filtrar por ramo y cia
DROP PROCEDURE IF EXISTS sp_consulta_cartera_personalizada;

DELIMITER $$

CREATE PROCEDURE sp_consulta_cartera_personalizada( 
    IN p_dato INT, 
    IN par_consultar1 INT,
    IN par_consultar2 INT)
BEGIN
    DECLARE total_registros INT;


    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    CASE 
        -- OPCION PARA FILTRAR SOLO POR RAMO
        WHEN p_dato = 1 THEN 
            -- Consulta 1: Contar registros
            SELECT COUNT(*) AS total_registros
            FROM vw_pol_act
            WHERE id_ramo = par_consultar1;

            -- Consulta 2: Obtener polizas
            SELECT cia, id_poliza, id_dni, nom_apell, descrip, fecha_baja, estado_poliza, prima
            FROM vw_pol_act
            WHERE id_ramo = par_consultar1
            ORDER BY fecha_baja;

        -- OPCION PARA FILTRAR POR CIA
        WHEN p_dato = 2 THEN

            -- Consulta 1: Contar registros
            SELECT COUNT(*) AS total_registros
            FROM vw_pol_act
            WHERE id_cia = par_consultar2;

            -- Consulta 2: Obtener polizas
            SELECT ramo, id_poliza, id_dni, nom_apell, descrip, fecha_baja, estado_poliza, prima
            FROM vw_pol_act
            WHERE id_cia = par_consultar2
            ORDER BY fecha_baja;

        WHEN p_dato = 3 THEN
            -- Consulta 1: Contar registros
            SELECT COUNT(*) AS total_registros
            FROM vw_pol_act
            WHERE id_ramo = par_consultar1
            AND id_cia = par_consultar2;

            -- Consulta 2: Obtener polizas
            SELECT cia, id_poliza, id_dni, nom_apell, descrip, fecha_baja, estado_poliza, prima
            FROM vw_pol_act
            WHERE id_ramo = par_consultar1
            AND id_cia = par_consultar2
            ORDER BY fecha_baja;
            

    END CASE;

    SELECT total_registros AS total_registros;
    
    COMMIT;
END;
$$
DELIMITER ;

SAVEPOINT sp_consulta_cartera_personalizada;

SAVEPOINT SP_END;

COMMIT;