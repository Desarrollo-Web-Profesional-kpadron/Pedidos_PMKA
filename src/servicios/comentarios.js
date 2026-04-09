import { Comentario } from "../bd/modelos/comentario.js";

/**
 * Función para crear un nuevo comentario
 * @param {Object} comentarioData - Datos del comentario
 * @returns {Promise<Comentario>} - El comentario creado
 */
export async function crearComentario({ texto, puntuacion }) {
  const comentario = new Comentario({
    texto,
    puntuacion
  });
  return await comentario.save();
}

/**
 * Función para obtener todos los comentarios
 * @returns {Promise<Array>} - Lista de comentarios
 */
export async function listarComentarios() {
  return await Comentario.find().sort({ fecha: -1 });
}