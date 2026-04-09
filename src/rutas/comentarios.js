import rateLimit from 'express-rate-limit';
import { body, validationResult } from 'express-validator';
import { crearComentario, listarComentarios } from '../servicios/comentarios.js';
import { sanitizarComentario } from '../middlewares/sanitizacion.js';

// Configurar rate limiter: 10 peticiones por minuto por IP
const comentariosLimiter = rateLimit({
  windowMs: 60 * 1000, // 1 minuto
  max: 10, // máximo 10 peticiones
  message: { 
    error: 'Demasiadas peticiones desde esta IP, por favor intente nuevamente en un minuto.' 
  },
  standardHeaders: true,
  legacyHeaders: false,
});

// Reglas de validación
const validarComentario = [
  body('texto')
    .isString()
    .isLength({ max: 200 })
    .withMessage('El texto no puede superar los 200 caracteres')
    .notEmpty()
    .withMessage('El texto es requerido'),
  
  body('puntuacion')
    .isInt({ min: 1, max: 5 })
    .withMessage('La puntuación debe ser un número entero entre 1 y 5')
];

/**
 * Función que define las rutas para comentarios
 * @param {Express} app - Aplicación Express
 */
export function comentariosRoutes(app) {
  // Listar comentarios
  app.get('/api/v1/comentarios', async (req, res) => {
    try {
      const comentarios = await listarComentarios();
      return res.json(comentarios);
    } catch (err) {
      console.error('Error listando comentarios', err);
      return res.status(500).end();
    }
  });

  // Crear comentario con rate limiting, sanitización y validación
  app.post('/api/v1/comentarios', 
    comentariosLimiter,
    sanitizarComentario,
    validarComentario,
    async (req, res) => {
      // Verificar errores de validación
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
      }

      try {
        const comentario = await crearComentario(req.body);
        return res.status(201).json(comentario);
      } catch (err) {
        console.error('Error creando comentario', err);
        
        // Manejar errores de validación de Mongoose
        if (err.name === 'ValidationError') {
          return res.status(400).json({ 
            error: 'Error de validación',
            detalles: err.message 
          });
        }
        
        return res.status(500).end();
      }
    }
  );
}