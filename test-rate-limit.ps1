# test-rate-limit.ps1
# Prueba de Rate Limiting - 15 peticiones

[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   PRUEBA DE RATE LIMITING" -ForegroundColor Cyan
Write-Host "   15 peticiones en menos de 1 minuto" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$body = @{
    texto = "Test rate limit"
    puntuacion = 5
} | ConvertTo-Json

$exitosas = 0
$bloqueadas = 0

Write-Host "Enviando 15 peticiones..." -ForegroundColor Yellow
Write-Host ""

for ($i = 1; $i -le 15; $i++) {
    try {
        Invoke-RestMethod -Uri "https://localhost/api/v1/comentarios" `
            -Method Post `
            -Body $body `
            -ContentType "application/json" `
            -ErrorAction Stop | Out-Null
        
        $exitosas++
        Write-Host "Peticion $i : 201 Created" -ForegroundColor Green
        
    } catch {
        if ($_.Exception.Response.StatusCode -eq 429) {
            $bloqueadas++
            Write-Host "Peticion $i : 429 Too Many Requests" -ForegroundColor Yellow
        } else {
            Write-Host "Peticion $i : Error" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   RESULTADO" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Peticiones exitosas (201): $exitosas" -ForegroundColor Green
Write-Host "Peticiones bloqueadas (429): $bloqueadas" -ForegroundColor Yellow
Write-Host ""
Write-Host "Esperado: 10 exitosas + 5 bloqueadas" -ForegroundColor Gray
Write-Host ""

if ($bloqueadas -gt 0) {
    Write-Host "RATE LIMITING FUNCIONA CORRECTAMENTE" -ForegroundColor Green
} else {
    Write-Host "Rate limiting NO esta funcionando" -ForegroundColor Red
}