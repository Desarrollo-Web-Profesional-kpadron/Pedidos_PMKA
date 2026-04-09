FROM node:20-alpine

# Instalar dumb-init
RUN apk add --no-cache dumb-init

# Crear usuario no root
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

WORKDIR /app

# Copiar package.json
COPY package*.json ./

# Instalar solo dependencias de producción
RUN npm install --only=production --ignore-scripts

# Copiar código fuente
COPY --chown=nodejs:nodejs . .

# Cambiar a usuario no root
USER nodejs

EXPOSE 3001

ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "src/index.js"]