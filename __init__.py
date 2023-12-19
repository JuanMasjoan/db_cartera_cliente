import mysql.connector
import os
from dotenv import load_dotenv

load_dotenv()

# funcion para crear archivos sql para la creacion de la base de datos
def ejecutar_script_mysql(archivo, conexion):
    try:
        with open(archivo, 'r') as file:
            consulta = file.read()
            cursor = conexion.cursor()
            cursor.execute(consulta, multi=True) 
            conexion.commit()
            print(f'Se ha ejecutado el script {archivo} correctamente.')
    except FileNotFoundError:
        print(f'El archivo {archivo} no se encontró.')
    except mysql.connector.Error as error:
        print(f'Error al ejecutar el script {archivo}: {error.msg}')
        try:
            # linea donde se produce el error
            ultima_linea = consulta.splitlines()[-1]
            print(f'Última línea ejecutada: {ultima_linea}')
        except IndexError:
            print('No se pudo obtener la última línea ejecutada.')
        finally:
            try:
                # rollback último savepoint
                cursor.execute("ROLLBACK TO SAVEPOINT sp;")
                print('Último savepoint recuperado correctamente.')
            except mysql.connector.Error as rollback_error:
                print(f'Error al recuperar el último savepoint: {rollback_error.msg}')


HOST = os.getenv('HOST')
USER = os.getenv('USUARIO')
PASSWORD = os.getenv('CONTRASEÑA')
DATABASE = os.getenv('BASE_DE_DATOS')

# Conexión a la base de datos
try:
    conexion = mysql.connector.connect(
        host=HOST,
        user=USER,
        password=PASSWORD,
        database=DATABASE
    )

    # Ejecutar scripts SQL
    archivos_sql = [
        '01_db_cartera_cliente_TDinamicas',
        '02_db_cartera_cliente_TEstaticas',
        '03_script_insert_cartera_cliente',
        '04_vw_cartera_cliente',
        '05_fx_cartera_cliente_upd_auditoria',
        '06_fx_cartera_cliente_modificaciones',
        '07_trigger_Cartera_cliente',
        '08_store_procedure'
    ]

    for archivo in archivos_sql:
        ejecutar_script_mysql(archivo, conexion)

except mysql.connector.Error as error:
    print(f'Error de conexión a MySQL: {error}')

finally:
    if conexion.is_connected():
        conexion.close()
        print('Conexión cerrada.')
