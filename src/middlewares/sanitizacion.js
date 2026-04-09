import sanitizeHtml from 'sanitize-html';


export function sanitizarComentario(req, res, next) {
  if (req.body.texto) {
    // Eliminar todas las etiquetas HTML y scripts
    req.body.texto = sanitizeHtml(req.body.texto, {
      allowedTags: [], // No permitir ninguna etiqueta HTML
      allowedAttributes: {}, // No permitir atributos
      textFilter: function(text) {
        return text;
      }
    });
  }
  next();
}