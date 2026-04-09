import mongoose, { Schema } from "mongoose";

/**
 * @typedef {Object} Comentario
 * @property {string} texto - Texto del comentario (max 200 caracteres)
 * @property {number} puntuacion - Puntuación entera
 * @property {Date} fecha - Fecha de creación
 */

const comentarioSchema = new Schema(
  {
    texto: { 
      type: String, 
      required: true, 
      maxlength: 200 
    },
    puntuacion: { 
      type: Number, 
      required: true,
      min: 1,
      max: 5,
      validate: {
        validator: Number.isInteger,
        message: 'La puntuación debe ser un número entero'
      }
    },
    fecha: { 
      type: Date, 
      default: Date.now 
    }
  },
  { timestamps: true }
);

export const Comentario = mongoose.model("comentario", comentarioSchema);