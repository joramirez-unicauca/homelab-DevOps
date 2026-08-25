const query = `
    query {
        proyectos {
            id
            nombre
            color
            tareas {
                id
                titulo
                descripcion
                completada
                prioridad
                fecha_vencimiento
                subtareas {
                    id
                    titulo
                    completada
                }
            }
        }
    }
`;

async function cargarProyectos() {
    console.log("1. cargarProyectos() se está ejecutando");

    try {
        console.log("2. Antes del fetch");

        const response = await fetch("http://10.10.10.10:4000/graphql", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                query: query
            })
        });

        console.log("3. HTTP:", response.status);

        const resultado = await response.json();

        console.log("4. Respuesta GraphQL:", resultado);

        if (resultado.errors) {
            console.error("5. Errores GraphQL:", resultado.errors);
            return;
        }

        mostrarProyectos(resultado.data.proyectos);

    } catch (error) {
        console.error("7. Error haciendo fetch:", error);
    }
}


function mostrarProyectos(proyectos) {
    const contenedor = document.getElementById("proyectos");

    contenedor.innerHTML = "";

    proyectos.forEach(proyecto => {

        // Contenedor principal del proyecto
        const proyectoElement = document.createElement("div");

        proyectoElement.className = "proyecto-card";

        // Color del proyecto
        const color = proyecto.color || "#2383e2";

        proyectoElement.style.setProperty("--proyecto-color", color);

        proyectoElement.innerHTML = `
            <div class="proyecto-header">
                <div class="proyecto-icon" style="background: ${color}">
                    ${proyecto.nombre.charAt(0).toUpperCase()}
                </div>

                <div class="proyecto-info">
                    <h2>${escapeHTML(proyecto.nombre)}</h2>
                    <span>${proyecto.tareas.length} tareas</span>
                </div>

                <button class="proyecto-menu">•••</button>
            </div>

            <div class="tareas">
            </div>
        `;

        const tareasContainer = proyectoElement.querySelector(".tareas");

        // Crear tareas
        proyecto.tareas.forEach(tarea => {

            const tareaElement = document.createElement("div");

            tareaElement.className = "tarea";

            if (tarea.completada) {
                tareaElement.classList.add("completada");
            }

            tareaElement.innerHTML = `
                <div class="tarea-principal">

                    <button
                        class="checkbox ${tarea.completada ? "checked" : ""}"
                        aria-label="Completar tarea"
                    >
                        ${tarea.completada ? "✓" : ""}
                    </button>

                    <div class="tarea-contenido">

                        <div class="tarea-titulo">
                            ${escapeHTML(tarea.titulo)}
                        </div>

                        ${
                            tarea.descripcion
                                ? `
                                    <div class="tarea-descripcion">
                                        ${escapeHTML(tarea.descripcion)}
                                    </div>
                                `
                                : ""
                        }

                        <div class="tarea-meta">

                            ${
                                tarea.prioridad
                                    ? `
                                        <span class="prioridad prioridad-${tarea.prioridad.toLowerCase()}">
                                            ${escapeHTML(tarea.prioridad)}
                                        </span>
                                    `
                                    : ""
                            }

                            ${
                                tarea.fecha_vencimiento
                                    ? `
                                        <span class="fecha">
                                            📅 ${escapeHTML(tarea.fecha_vencimiento)}
                                        </span>
                                    `
                                    : ""
                            }

                            ${
                                tarea.subtareas.length
                                    ? `
                                        <span class="subtareas-count">
                                            ☷ ${tarea.subtareas.length}
                                        </span>
                                    `
                                    : ""
                            }

                        </div>

                    </div>

                    <button class="tarea-menu">•••</button>
                </div>

                <div class="subtareas">
                </div>
            `;

            // Agregar subtareas
            const subtareasContainer =
                tareaElement.querySelector(".subtareas");

            tarea.subtareas.forEach(subtarea => {

                const subtareaElement = document.createElement("div");

                subtareaElement.className = "subtarea";

                subtareaElement.innerHTML = `
                    <button
                        class="sub-checkbox ${
                            subtarea.completada ? "checked" : ""
                        }"
                    >
                        ${subtarea.completada ? "✓" : ""}
                    </button>

                    <span class="${
                        subtarea.completada ? "sub-completada" : ""
                    }">
                        ${escapeHTML(subtarea.titulo)}
                    </span>
                `;

                subtareasContainer.appendChild(subtareaElement);
            });

            tareasContainer.appendChild(tareaElement);
        });

        // Botón para nueva tarea
        const nuevaTarea = document.createElement("button");

        nuevaTarea.className = "nueva-tarea";

        nuevaTarea.innerHTML = `
            <span>＋</span>
            Nueva tarea
        `;

        tareasContainer.appendChild(nuevaTarea);

        contenedor.appendChild(proyectoElement);
    });
}


/*
 * Evita insertar directamente HTML proveniente
 * del servidor.
 */
function escapeHTML(text) {
    const div = document.createElement("div");
    div.textContent = text ?? "";
    return div.innerHTML;
}


cargarProyectos();