terraform{
	required_providers{
		docker = {
			source = "kreuzwerker/docker"
			version = "~> 3.0"
		}
	}
}

provider "docker"{}

variable "config_path" {
	description = "Ruta absoluta a la carpeta observabilidad/ en la VM"
	type = string
	default = "/home/admin1/observabilidad"
}

resource "docker_network" "monitoreo_net" {
	name="monitoreo_net"
}

#================================================
# NODE EXPORTER - expone metricas del sistema (cpu,ram,disco)

resource "docker_image" "metricas_node_exporter"{
	name="prom/node-exporter:latest"
}

resource "docker_container" "metricas_node_exporter" {
	name="node-exporter"
	image=docker_image.metricas_node_exporter.image_id

	networks_advanced {
		name= docker_network.monitoreo_net.name
	}
	ports{
		internal= 9100
		external= 9100
	}
}

#=================================================
# PROMETHEUS - recolecta y expone metricas

resource "docker_image" "prometheus_recolector" {
	name = "prom/prometheus:latest"
}

resource "docker_container" "prometheus_recolector"{
	name="prometheus"
	image=docker_image.prometheus_recolector.image_id
	
	networks_advanced {
		name=docker_network.monitoreo_net.name
	}
	ports{
		internal=9090
		external=9090
	}
	
	volumes{
		host_path = "${var.config_path}/prometheus/prometheus.yml"
		container_path= "/etc/prometheus/prometheus.yml"
	}
	depends_on = [docker_container.metricas_node_exporter]
}

#====================================================
# LOKI - guarda logs 

resource "docker_image" "loki_logs"{
	name="grafana/loki:latest"
}

resource "docker_container" "loki_logs"{
	name="loki"
	image=docker_image.loki_logs.image_id
	
	networks_advanced{
		name=docker_network.monitoreo_net.name
	}

	ports{
		internal=3100
		external=3100
	}
}

#====================================================
# PROMTAIL - lee logs del sistema y los envia a loki

resource "docker_image" "promtail_syslogs"{
	name="grafana/promtail:latest"
}

resource "docker_container" "promtail_syslogs"{
	name="promtail"
	image=docker_image.promtail_syslogs.image_id

	networks_advanced{
		name=docker_network.monitoreo_net.name
	}

	volumes{
		host_path = "${var.config_path}/promtail/promtail-config.yml"
		container_path="/etc/promtail/config.yml"
	}

	volumes{
		host_path ="/var/log"
		container_path="/var/log"
		read_only=true
	}

	command = ["-config.file=/etc/promtail/config.yml"]

	depends_on = [docker_container.loki_logs]
}

#=========================================================
# GRAFANA - visualizador de metricas y logs

resource "docker_image" "grafana_visualizador" {
	name="grafana/grafana:latest"
}

resource "docker_container" "grafana_visualizador" {
	name="grafana"
	image=docker_image.grafana_visualizador.image_id
	
	networks_advanced{
		name=docker_network.monitoreo_net.name
	}

	ports{
		internal=3000
		external=3000
	}

	depends_on = [
		docker_container.prometheus_recolector,
		docker_container.loki_logs
	]

}

#===========================================================
# Postgres - Base de datos

resource "docker_image" "postgres" {
	name="postgres:16"
}

resource "docker_container" "postgres" {
	name = "postgres"
	image= docker_image.postgres.image_id

	env = [
		"POSTGRES_PASSWORD=postgres",
		"POSTGRES_DB=RettenTask"	
	]

	networks_advanced{
		name=docker_network.monitoreo_net.name
	}

	volumes{
		host_path = "${var.config_path}/RettenTask-api/postgres"
		container_path= "/docker-entrypoint-initdb.d"
	}

	ports { 
		internal = 5432
		external = 5432
	}
}

#============================================================
# PostRest - API Rest

resource "docker_image" "postgrest" {
	name = "postgrest/postgrest"
}

resource "docker_container" "postgrest" {
	name = "postgrest"
	image = docker_image.postgrest.image_id

	env = [
		"PGRST_DB_URI=postgres://postgres:postgres@postgres:5432/RettenTask",
		"PGRST_DB_SCHEMAS=public",
		"PGRST_DB_ANON_ROLE=postgres"
	]

	networks_advanced {
		name=docker_network.monitoreo_net.name
	}

	ports {
		internal=3000
		external=3001
	}
}

#============================================================
# Apollo server

resource "docker_image" "apollo" {
	name="apollo-server:1.0"

	build {
		context ="${var.config_path}/RettenTask-api/apollo-server"
	}
}

resource "docker_container" "apollo" {
	name= "apollo"
	image= docker_image.apollo.image_id

	networks_advanced {
		name=docker_network.monitoreo_net.name
	}

	ports {
		internal=4000
		external=4000
	}
}

#============================================================
# NGINX - union de apollo y postrest

resource "docker_image" "nginx" {
	name="nginx:alpine"
}

resource "docker_container" "nginx" {
	name="nginx"
	image=docker_image.nginx.image_id

	networks_advanced {
		name=docker_network.monitoreo_net.name
	}

	ports {
		internal=80
		external=80
	}

	volumes {
		host_path = "${var.config_path}/RettenTask-api/nginx/nginx.conf"
		container_path = "/etc/nginx/conf.d/default.conf"
	}
}


#=============================================================
# OUTPUTS - Que muestra Terraform al final de "apply"

output "grafana_url"{
	value="http://localhost:3000"
}
output "prometheus_url"{
	value="http://prometheus:9090"
}


