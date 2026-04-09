#!/bin/bash

echo "🧪 Iniciando pruebas de seguridad de la API..."

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# URL base (usar -k para ignorar verificación de certificado autofirmado)
BASE_URL="https://localhost"

echo -e "\n${YELLOW}📋 Prueba 1: Verificar redirección HTTP → HTTPS${NC}"
HTTP_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost)
if [ "$HTTP_RESPONSE" = "301" ]; then
    echo -e "${GREEN}✅ Redirección 301 funciona correctamente${NC}"
else
    echo -e "${RED}❌ Error: Redirección no funciona (código: $HTTP_RESPONSE)${NC}"
fi

echo -e "\n${YELLOW}📋 Prueba 2: Verificar TLS 1.3${NC}"
TLS_VERSION=$(curl -s -k -o /dev/null -w "%{ssl_version}" https://localhost)
if [[ "$TLS_VERSION" == *"TLSv1.3"* ]]; then
    echo -e "${GREEN}✅ TLS 1.3 activado correctamente${NC}"
else
    echo -e "${RED}❌ Error: TLS 1.3 no está activo (versión: $TLS_VERSION)${NC}"
fi

echo -e "\n${YELLOW}📋 Prueba 3: Prueba de inyección XSS${NC}"
XSS_RESPONSE=$(curl -s -k -X POST https://localhost/api/v1/comentarios \
  -H "Content-Type: application/json" \
  -d '{"texto":"<script>alert(\"hack\")</script>", "puntuacion":5}')
  
if [[ "$XSS_RESPONSE" != *"<script>"* ]] && [[ "$XSS_RESPONSE" != *"alert"* ]]; then
    echo -e "${GREEN}✅ Script XSS sanitizado correctamente${NC}"
    echo "Respuesta: $XSS_RESPONSE"
else
    echo -e "${RED}❌ Error: Script XSS no fue sanitizado${NC}"
fi

echo -e "\n${YELLOW}📋 Prueba 4: Validación de longitud de texto (201 caracteres)${NC}"
LENGTH_RESPONSE=$(curl -s -k -X POST https://localhost/api/v1/comentarios \
  -H "Content-Type: application/json" \
  -d "{\"texto\":\"$(printf 'a%.0s' {1..201})\", \"puntuacion\":5}")
  
if [[ "$LENGTH_RESPONSE" == *"no puede superar los 200 caracteres"* ]]; then
    echo -e "${GREEN}✅ Validación de longitud funciona${NC}"
else
    echo -e "${RED}❌ Error: Validación de longitud falló${NC}"
fi

echo -e "\n${YELLOW}📋 Prueba 5: Validación de puntuación entera${NC}"
INT_RESPONSE=$(curl -s -k -X POST https://localhost/api/v1/comentarios \
  -H "Content-Type: application/json" \
  -d '{"texto":"Comentario válido", "puntuacion":4.5}')
  
if [[ "$INT_RESPONSE" == *"número entero"* ]] || [[ "$INT_RESPONSE" == *"isInt"* ]]; then
    echo -e "${GREEN}✅ Validación de entero funciona${NC}"
else
    echo -e "${RED}❌ Error: Validación de entero falló${NC}"
fi

echo -e "\n${YELLOW}📋 Prueba 6: Rate Limiting (11 peticiones rápidas)${NC}"
echo "Enviando 11 peticiones en rápida sucesión..."
COUNT=0
for i in {1..11}; do
    RESPONSE=$(curl -s -k -o /dev/null -w "%{http_code}" -X POST https://localhost/api/v1/comentarios \
      -H "Content-Type: application/json" \
      -d '{"texto":"Test rate limit", "puntuacion":5}')
    if [ "$RESPONSE" = "429" ]; then
        COUNT=$((COUNT + 1))
    fi
    echo -n "."
done
echo ""

if [ $COUNT -gt 0 ]; then
    echo -e "${GREEN}✅ Rate limiting funciona ($COUNT respuestas 429)${NC}"
else
    echo -e "${RED}❌ Error: Rate limiting no está funcionando${NC}"
fi

echo -e "\n${YELLOW}📋 Prueba 7: Comentario válido${NC}"
VALID_RESPONSE=$(curl -s -k -X POST https://localhost/api/v1/comentarios \
  -H "Content-Type: application/json" \
  -d '{"texto":"Este es un comentario válido y seguro", "puntuacion":5}')
  
if [[ "$VALID_RESPONSE" == *"Este es un comentario válido y seguro"* ]]; then
    echo -e "${GREEN}✅ Comentario válido aceptado${NC}"
    echo "Respuesta: $VALID_RESPONSE"
else
    echo -e "${RED}❌ Error: Comentario válido rechazado${NC}"
fi

echo -e "\n${GREEN}✨ Pruebas completadas ✨${NC}"