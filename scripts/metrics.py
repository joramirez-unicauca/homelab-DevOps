from prometheus_client import start_http_server, Gauge
import time

tareas_pendientes=Gauge(
 "tareas_pendientes",
 "cantidad de tareas pendientes"
)

tareas_completadas = Gauge(
 "tareas_completadas",
 "cantidad de tareas completadas"
)

start_http_server(8000)

while True:

 tareas_pendientes.set(8)
 tareas_completadas.set(12)

 time.sleep(15)
