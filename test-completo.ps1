# test-api-simple.ps1
# Ignorar certificados SSL para pruebas
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

Write-Host "`n=== PRUEBA DE API (Modo Desarrollo) ===" -ForegroundColor Cyan

# Probar HTTP (si no redirige)
try {
    Write-Host "`n1. Probando HTTP..." -ForegroundColor Yellow
    $response = Invoke-WebRequest -Uri "http://localhost" -ErrorAction SilentlyContinue
    
    if ($response.StatusCode -eq 200) {
        Write-Host "HTTP funciona" -ForegroundColor Green
    } elseif ($response.StatusCode -eq 301) {
        Write-Host "HTTP redirige a HTTPS" -ForegroundColor Yellow
    }
} catch {
    Write-Host "Error en HTTP: $_" -ForegroundColor Red
}

# Probar HTTPS directamente
try {
    Write-Host "`n2. Probando HTTPS..." -ForegroundColor Yellow
    $response = Invoke-RestMethod -Uri "https://localhost" -ErrorAction Stop
    Write-Host "HTTPS funciona" -ForegroundColor Green
    $response | ConvertTo-Json
} catch {
    Write-Host "Error en HTTPS: $_" -ForegroundColor Red
}

# Probar crear comentario
try {
    Write-Host "`n3. Creando comentario vía HTTPS..." -ForegroundColor Yellow
    $body = @{
        texto = "Comentario de prueba"
        puntuacion = 5
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "https://localhost/api/v1/comentarios" `
        -Method Post `
        -Body $body `
        -ContentType "application/json" `
        -ErrorAction Stop
    
    Write-Host "Comentario creado: $($response.texto)" -ForegroundColor Green
} catch {
    Write-Host "Error al crear comentario: $_" -ForegroundColor Red
}

Write-Host "`n✨ Prueba completada" -ForegroundColor Green