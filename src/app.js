// backend/src/app.js
import express from 'express'
import cors from 'cors'
import bodyParser from 'body-parser'
import { usuarioRoutes } from './rutas/usuarios.js'
import { pedidosRoutes } from './rutas/pedidos.js'
import { comentariosRoutes } from './rutas/comentarios.js';

// Crear la aplicación Express
const app = express()
// Configurar middlewares
app.use(cors())
app.use(bodyParser.json())

// Confiar en el proxy para rate limiting (importante para Docker)
app.set('trust proxy', 1);

// Configurar rutas
pedidosRoutes(app)
usuarioRoutes(app)
comentariosRoutes(app);

// Ruta de prueba
// Ruta de prueba
app.get('/', (req, res) => {
  res.json({ 
    mensaje: 'API de Pedidos y Comentarios',
    endpoints: {
      pedidos: '/api/v1/pedidos',
      comentarios: '/api/v1/comentarios'
    }
  });
});

export { app }