START TRANSACTION ;

-- INSERT INCICIAL DE BD 
-- insert en tablas sin relaciones (FK)

INSERT INTO cartera_cliente.productor (productor, matricula, organizador)
    VALUES ('Roberto Masjoan','91994','Grupo PAS'),
        ('Juan Cruz Masjoan','96266','Elegi tu Seguro')
;

INSERT INTO cartera_cliente.cia (cia, ejecutivo, telefono, correo, codigo_cia)
    values ('SANCOR','PEIRETTI DIEGO', '3515586634','dppeiretti@sancorseguros.com','227933'),
       ('LA PERSEVERANCIA','JULIAN G CAVALLO', '3513623098','juliancavallo@lps.com.ar','8145'),
       ('ORBIS','GISELA A LONG', '3516116427','glong@orbiseguros.com.ar','6120901'),
       ('RIO URUGUAY','MICA - GRUPO PAS', '0001','sis@riouruguay.com.ar','14218676'),
       ('RIVADAVIA','ORGANIZACION', '000','ORGANIZACION GRUPO PAS','002'),
       ('BBVA SEGUROS','ERIK BLAES', '000','ERIK BLAES','001'),    
       ('INSUR - CAUCION','VIRGINIA BOSIO','3516016576','vbosio@segurosinsur.com.ar','1095')
;   
 
INSERT INTO cartera_cliente.estado_civil (estado_civil)
    values ('CASADO/A'),
        ('DIVORCIADO/A'),
        ('SOLTERO/A'),
        ('VIUDO/A')
;

SAVEPOINT ins_1trio;

INSERT INTO cartera_cliente.provincia (provincia) 
    VALUES  ('Buenos Aires'),
        ('Buenos Aires-GBA'),
        ('Capital Federal'),
        ('Catamarca'),
        ('Chaco'),
        ('Chubut'),
        ('Cordoba'),
        ('Corrientes'),
        ('Entre Rios'),
        ('Formosa')
;
INSERT INTO cartera_cliente.provincia (provincia) 
    VALUES  ('Jujuy'),
        ('La Pampa'),
        ('La Rioja'),
        ('Mendoza'),
        ('Misiones'),
        ('Neuquen'),
        ('Rio Negro'),
        ('Salta'),
        ('San Juan')
;
INSERT INTO cartera_cliente.provincia (provincia) 
    VALUES  
        ('San Luis'),
        ('Santa Cruz'),
        ('Santa Fe'),
        ('Santiago del Estero'),
        ('Tierra del Fuego'),
        ('Tucuman')
;

SAVEPOINT ins_2trio;

INSERT into cartera_cliente.ramo (ramo)
    values ('ACCIDENTES PERSONALES'),
        ('AP AUTOMOTOR'),
        ('AP MOTOVEHICULO'),
        ('AUTOMOVIL'),
        ('MOTOVEHICULO'),
        ('INTEGRAL DE COMERCIO'),
        ('COMBINADO FAMILIAR'),
        ('SEGURO TECNICO'),
        ('RESPONSABILIDAD CIVIL'),
        ('INCENDIO')
;
INSERT into cartera_cliente.ramo (ramo)
    values('CAUCION'),
        ('ASISTENCIA AL VIAJERO'),
        ('RAMOS ESPECIALES - UNIONES'),
        ('ART'),
        ('PREVENCION SALUD'),
        ('VIDA COLECTIVO'),
        ('AGROPECUARIO')
        ('CALULAR'),
        ('bicicleta'),
        ('TRO'),
        ('CALULAR'),
        ('RC')
;

INSERT INTO cartera_cliente.cia_premio_prima( cia_premio_prima )
    values ('PREMIO'),
        ('PRIMA')
;

SAVEPOINT ins_3trio;

INSERT into cartera_cliente.ciclo_facturacion ( ciclo_facturacion)
    values ('MENSUAL'),
        ('BIMESTRAL'),
        ('TRIMESTRAL'),
        ('CUATRIMESTRAL'),
        ('SEMESTRAL'),
        ('ANUAL'),
        ('POR COSECHA'),
        ('PLAZOS ESPECIALES')
;

INSERT INTO cartera_cliente.cuotas_pago (id_cuotas,cantidad_cuotas)
    values (1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10)
;
INSERT INTO cartera_cliente.cuotas_pago (id_cuotas,cantidad_cuotas)
    values (11,11),(12,12),(20,20),(50,'CONVENIOS')
;

SAVEPOINT ins_4trio;

INSERT INTO cartera_cliente.forma_pago_clientes (forma_pago_cliente)
    values (' EFECTIVO '),
        ('TARJETA DE CREDITO'),
        ('CBU'),
        ('CANJE'),
        ('DESCUENTO DE COMISIONES'),
        (' CHEQUE '),
        (' CONVENIOS ')
;

INSERT into cartera_cliente.estado_poliza (estado_poliza)
    values (' VIGENTE '),
        ('ANULADA POR CIA'),
        ('ANULADA'),
        ('RENOVADA'),
        ('NO RENOVADA POR SOCIO'),
        ('VENCIDA'),
        ('BAJA POR MORA'),
        ('VENTA / INEXISTENCIA DEL BIEN'),
        ('FUERA DE COBERTURA'),
        ('EN MORA')
;

INSERT INTO cartera_cliente.estado_certificados (estado_certificados)
    values (' ACTIVO '),
        ('BAJAS'),
        ('MODIFICACIONES'),
        ('RENOVACIONES')
;

SAVEPOINT ins_5trio;

INSERT into cartera_cliente.estado_siniestro (estado_siniestro)
    values ('PENDIENTE DE RESPUESTA'),
        ('TASADOR A CONTACTAR'),
        ('CON TASADOR'),
        ('ENVIO DE PROPUESTA'),
        ('PENDIENTE DE LIQUIDACION'),
        ('PENDIENTE DE DOCUMENTACION'),
        ('LIQUIDADA'),
        ('DESISTIDO POR LA CIA'),
        ('DESISTIDO POR EL CLIENTE'),
        ('RECHAZADO')
;
INSERT into cartera_cliente.estado_siniestro (estado_siniestro)
    values ('DE TERCEROS'),
        ('REALIZADO')
;

INSERT INTO cartera_cliente.tipo_siniestro( tipo_siniestro )
    values (' CHOQUE '),
        ('ROTURA PARCIAL'),
        ('ROBO'),
        ('ROBO PARCIAL'),
        ('HURTO'),
        ('INCENDIO'),
        ('DESTRUCCION TOTAL'),
        ('CRISTALES'),
        ('RECLAMO POR COBRO'),
        ('RECLAMO POR TRASLADO'),
        ('RECLAMO POR DESCUENTO')
;
INSERT INTO cartera_cliente.tipo_siniestro( tipo_siniestro )
    values         
        ('RECLAMO POR DOCUMENTACION'),
        ('ACCIDENTES PERSONALES'),
        ('LESIONES A PERSONAS'),
        ('GRANIZO'),
        ('ELECTRO HOGAR')
;

SAVEPOINT ins_6trio;

--- POR AHORA UTILIZAR LAS FK COMO TABLAS SEPARADAS EN TABLA POLIZA.
/*INSERT INTO cartera_cliente.pago_cliente (id_forma_pago_clientes , id_cuotas)
    values (1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10),(1,11),(1,12),
        (2,1),(2,2),(2,3),(2,4),(2,5),(2,6),(2,7),(2,8),(2,9),(2,10),(2,11),(2,12),
        (3,1),(3,2),(3,3),(3,4),(3,5),(3,6),(3,7),(3,8),(3,9),(3,10),(3,11),(3,12),
        (4,1),
        (5,1),(5,2),(5,3),(5,4),(5,5),(5,6),(5,7),(5,8),(5,9),(5,10),(5,11),(5,12),
        (6,1),(6,2),(6,3),(6,4),(6,5),(6,6),(6,7),(6,8),(6,9),(6,10),(6,11),(6,12)
;
*/

--- insert de formas de pago de la comision dependiendo cia NO ESTA EN CODER
insert into cartera_cliente.forma_pago_comision_cia (id_cia, id_cia_premio_prima, paga_cobranza)
 values (1,2,1);
insert into cartera_cliente.forma_pago_comision_cia (id_cia, id_cia_premio_prima, paga_cobranza)
 values (2,2,0);
insert into cartera_cliente.forma_pago_comision_cia (id_cia, id_cia_premio_prima, paga_cobranza)
 values (3,1,0);

SAVEPOINT ins_7trio;

insert into cartera_cliente.forma_pago_comision_cia (id_cia, id_cia_premio_prima, paga_cobranza) 
values (4,2,0);
insert into cartera_cliente.forma_pago_comision_cia (id_cia, id_cia_premio_prima, paga_cobranza)
 values (8,2,0);
insert into cartera_cliente.forma_pago_comision_cia (id_cia, id_cia_premio_prima, paga_cobranza) 
 values (9,2,0);

SAVEPOINT ins_8trio;

-- insert comisiones
insert into comision (id_cia, id_plan_comision, id_ramo, comision)
 values ( 1 , 2, 1, 17) ,
 (1 , 2, 2 , 12.5),
 (1 , 2, 3 , 19),
 (1 , 2 , 4 , 13 ),
 (1 , 2, 5 , 13 )
;

insert into comision (id_cia, id_plan_comision, id_ramo, comision)
values  (1 , 2, 7 , 20),
 (1 , 2, 9 , 14),
 (1 , 2 , 10 , 22 ),
 (1 , 1, 13 , 25 ),
 (1 , 1, 15 , 16 ),
 (1 , 1, 17 , 8 )
;

insert into comision (id_cia, id_plan_comision, id_ramo, comision)
values  (2 , 2, 1 , 32),
	(2 , 2, 4 , 30),
    (2 , 2, 5 , 30),
    (2 , 2, 6 , 28),
    (2 , 2, 7 , 28),
    (2 , 2, 8 , 25 ),
    (2 , 2, 9 , 25),
    (2 , 2, 10 , 39)
;

SAVEPOINT ins_9trio;

insert into comision (id_cia, id_plan_comision, id_ramo, comision)
 values  (3 , 3 , 1 , 15),
	(3 , 4 , 1 , 20),
    (3 , 5 , 1 , 25)
;
insert into comision (id_cia, id_plan_comision, id_ramo, comision)
 values 
    (3 , 6 , 1 , 30),
    (3 , 7 , 4 , 20.5),
    (3 , 8 , 4 , 17.5),
    (3 , 9 , 4 , 14.5),
	(3 , 10 , 5 , 15),
    (3 , 11 , 5 , 20),
    (3 , 10 , 6 , 15),
    (3 , 11 , 6 , 20),
    (3 , 10 , 7 , 15),
    (3 , 11 , 7 , 20)
;

SAVEPOINT ins_10trio;

insert into comision (id_cia, id_plan_comision, id_ramo, comision)
 values  (4 , 2 , 2 , 7.5),
	(4 , 2 , 4 , 12),
    (4 , 2 , 5 , 12),
    (4 , 2 , 10 , 20),
    (4 , 2 , 6 , 13),
    (4 , 2 , 7 , 14.5)
;

insert into comision (id_cia, id_plan_comision, id_ramo, comision)
 values  (8 , 2 , 15 , 3.5),
  (9 , 2 , 14 , 3.5)
;

SAVEPOINT ins_11trio;

-- Insert planes para pago de comision
insert into cartera_cliente.plan_comision (nombre_plan_comision) 
 values ('UNICO'),
    ('PLAN 50'),
    ('PLAN 51'),
    ('PLAN 52'),
    ('PLAN 53'),
    ('PLAN 12'),
    ('PLAN 1'),
    ('PLAN 9')
;

insert into cartera_cliente.plan_comision (nombre_plan_comision) 
 values
    ('PLAN 15'),
    ('PLAN 20'),
    ('ACUERDOS ESPECIALES')
;

-
SAVEPOINT ins_2t2rio;

-- SACAR RAMO REPETIDO
DELETE FROM cartera_cliente.ramo WHERE (id_ramo = 21);

SAVEPOINT ins_end;


COMMIT;