import time
import psycopg2

from prometheus_client import start_http_server, Gauge


tareas_pendientes = Gauge(
    "tareas_pendientes",
    "Cantidad de tareas pendientes"
)

tareas_completadas = Gauge(
    "tareas_completadas",
    "Cantidad de tareas completadas"
)

def esperar_postgres():
    while True:
        try:
            conexion = psycopg2.connect(
                host="postgres",
                port=5432,
                database="RettenTask",
                user="postgres",
                password="postgres"
            )

            conexion.close()

            print("PostgreSQL está listo")
            break

        except psycopg2.OperationalError:
            print("Esperando PostgreSQL...")
            time.sleep(3)


def consultar_tareas():

    conexion = psycopg2.connect(
        host="postgres",
        port=5432,
        database="RettenTask",
        user="postgres",
        password="postgres"
    )

    cursor = conexion.cursor()

    cursor.execute("""
        SELECT COUNT(*)
        FROM tareas
        WHERE completada = false;
    """)

    pendientes = cursor.fetchone()[0]

    cursor.execute("""
        SELECT COUNT(*)
        FROM tareas
        WHERE completada = true;
    """)

    completadas = cursor.fetchone()[0]

    cursor.close()
    conexion.close()

    return pendientes, completadas


start_http_server(8000)


while True:

    pendientes, completadas = consultar_tareas()

    tareas_pendientes.set(pendientes)
    tareas_completadas.set(completadas)

    time.sleep(15)
