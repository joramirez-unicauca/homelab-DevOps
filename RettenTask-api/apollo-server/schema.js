const typeDefs = `#graphql

	type Proyecto {
		id:ID!
		nombre:String!
		color:String
		fecha_creacion:String!
		tareas:[Tarea!]!
	}

	type Tarea {
		id: ID!
		titulo: String!
		descripcion: String
		completada: Boolean!
		prioridad: String!
		fecha_vencimiento: String
		subtareas: [Subtarea!]!

	}

	type Subtarea {
		id: ID!
		titulo: String!
		completada:Boolean!
	}
	type Query {
		proyectos: [Proyecto!]!
	}
`;

export default typeDefs;

