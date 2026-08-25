-- Tabla de proyectos

CREATE TABLE proyectos (
	id SERIAL PRIMARY KEY,
	nombre VARCHAR(100) NOT NULL,
	color VARCHAR(20) DEFAULT 'gris',
	fecha_creacion TIMESTAMP DEFAULT NOW()
);

-- Tabla de tareas
CREATE TABLE tareas(
	id SERIAL PRIMARY KEY,
	titulo VARCHAR(150) NOT NULL,
	descripcion TEXT,
	completada BOOLEAN DEFAULT FALSE,
	prioridad VARCHAR(10) DEFAULT 'media' CHECK (prioridad IN ('baja', 'media', 'alta')),
	fecha_vencimiento DATE,
	fecha_creacion TIMESTAMP DEFAULT NOW(),
	proyecto_id INTEGER REFERENCES proyectos(id) ON DELETE CASCADE
);

-- Tabla de subtareas
CREATE TABLE subtareas (
	id SERIAL PRIMARY KEY,
	titulo VARCHAR(150) NOT NULL,
	completada BOOLEAN DEFAULT FALSE,
	tarea_id INTEGER REFERENCES tareas(id) ON DELETE CASCADE
);

INSERT INTO proyectos (nombre, color) VALUES 
	('Homelab', 'azul'),
	('Personal','verde');

INSERT INTO tareas (titulo,descripcion,prioridad,fecha_vencimiento,proyecto_id) VALUES
	('Terminar paso 4 del homelab', 'Postgres + PostRest + Apollo + Nginx', 'alta','2026-08-20',1),
	('Practicar Aleman', 'Ver video en aleman nativo con subs', 'alta','2026-08-21',1),
	('Comprar mercado',NULL,'baja',NULL,2);

INSERT INTO subtareas (titulo, completada, tarea_id) VALUES
	('Levantar Postgres',TRUE,1),
	('Levantar PostRest',FALSE,1),
	('Escribir servidor Apollo', FALSE, 1),
	('comprar carnes y patatas', TRUE,2);
