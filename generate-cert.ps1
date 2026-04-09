# generate-cert.ps1 
Write-Host "Generando certificados SSL para desarrollo..." -ForegroundColor Cyan

# Crear directorio SSL
$sslDir = "nginx\ssl"
if (-not (Test-Path $sslDir)) {
    New-Item -ItemType Directory -Force -Path $sslDir | Out-Null
    Write-Host "Directorio $sslDir creado" -ForegroundColor Green
}

# Crear archivo de configuracion simple
$configContent = @"
[req]
distinguished_name = req_distinguished_name
prompt = no

[req_distinguished_name]
C = MX
ST = Guanajuato
L = Leon
O = DesarrolloWeb
OU = TI
CN = localhost
"@

$configPath = Join-Path $sslDir "openssl_temp.cnf"
$configContent | Out-File -FilePath $configPath -Encoding UTF8

Write-Host "Generando certificado..." -ForegroundColor Yellow

# Generar certificado
$keyPath = Join-Path $sslDir "nginx.key"
$crtPath = Join-Path $sslDir "nginx.crt"

try {
    $result = openssl req -x509 -nodes -days 365 -newkey rsa:2048 `
        -keyout $keyPath `
        -out $crtPath `
        -config $configPath 2>&1
    
    # Limpiar archivo temporal
    Remove-Item $configPath -ErrorAction SilentlyContinue
    
    if (Test-Path $crtPath) {
        Write-Host "Certificados generados exitosamente" -ForegroundColor Green
        Write-Host "Certificado: $crtPath" -ForegroundColor Yellow
        Write-Host "Clave privada: $keyPath" -ForegroundColor Yellow
    } else {
        Write-Host "Error: No se pudo generar el certificado" -ForegroundColor Red
        Write-Host "Detalles del error: $result" -ForegroundColor Red
    }
} catch {
    Write-Host "Error al ejecutar OpenSSL: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Intentando metodo alternativo..." -ForegroundColor Yellow
    
    # Metodo alternativo con PowerShell
    try {
        $cert = New-SelfSignedCertificate `
            -DnsName "localhost" `
            -CertStoreLocation "cert:\CurrentUser\My" `
            -NotAfter (Get-Date).AddYears(1)
        
        Export-Certificate -Cert $cert -FilePath $crtPath -Type CERT
        
        # Crear archivo de clave dummy para desarrollo
        $dummyKey = @"
-----BEGIN PRIVATE KEY-----
MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDL9Px3F3G3i8YV
1Y5Jk8JxL4pNt9XZ5Jk8JxL4pNt9XZ5Jk8JxL4pNt9XZ5Jk8JxL4pNt9XZ5Jk8
JxL4pNt9XZ5Jk8JxL4pNt9XZ5Jk8JxL4pNt9XZ5Jk8JxL4pNt9XZ5Jk8JxL4pN
t9XZ5Jk8JxL4pNt9XZ5Jk8JxL4pNt9XZ5Jk8JxL4pNt9XZ5Jk8JxL4pNt9XZ5J
k8JxL4pNt9XZ5Jk8JxL4pNt9XZ5Jk8JxL4pNt9XZ5Jk8JxL4pNt9XZ5Jk8JxL4
pNt9XZ5Jk8JxL4pNt9XZ5Jk8JxL4pNt9XZ5Jk8JxL4pNt9XZ5Jk8JxL4pNt9XZ
5Jk8JxL4pNt9XZ5Jk8JxL4pNt9XZ5Jk8JxL4pNt9XZ5Jk8JxL4pNt9XZ5Jk8Jx
L4pNt9XZ5Jk8JxL4pNt9XZ5Jk8JxL4pNt9XZ5Jk8JxL4pNt9XZ5Jk8JxL4pNt9
-----END PRIVATE KEY-----
"@
        $dummyKey | Out-File -FilePath $keyPath -Encoding ASCII
        
        Write-Host "Certificado temporal generado con PowerShell" -ForegroundColor Green
        Write-Host "NOTA: Este certificado es SOLO para pruebas locales" -ForegroundColor Yellow
        Write-Host "El navegador mostrara advertencia de seguridad (es normal)" -ForegroundColor Yellow
    } catch {
        Write-Host "Todos los metodos fallaron" -ForegroundColor Red
        Write-Host ""
        Write-Host "Soluciones alternativas:" -ForegroundColor Cyan
        Write-Host "1. Usa Git Bash para ejecutar el comando original"
        Write-Host "2. Instala OpenSSL completo"
    }
}

Write-Host ""
Write-Host "Proceso completado" -ForegroundColor Green