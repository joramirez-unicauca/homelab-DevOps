const resolvers = {
	Query: {
		proyectos: async ()=> {

			const response = await fetch("http://postgrest:3000/proyectos");

			if (!response.ok) {

				throw new Error("Error al consultar proyectos con PostRest");

			}

			return response.json();

		}

	},

	Proyecto: {
		tareas: async (proyecto) => {

			const response = await fetch(

				`http://postgrest:3000/tareas?proyecto_id=eq.${proyecto.id}`

			);

			if (!response.ok){

				throw new Error("Error al consultar tareas");

			}

			return response.json();
		}

	},

	Tarea: {

		subtareas: async (tarea) =>{

			const response =await fetch(

				`http://postgrest:3000/subtareas?tarea_id=eq.${tarea.id}`

			);

			if (!response.ok){

				throw new Error("Error al consultar las subtareas");

			}

			return response.json();
		}

	      }
};

export default resolvers;
