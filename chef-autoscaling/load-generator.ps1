
param(
    [int]$Requests = 10000,
    [int]$Concurrent = 100,
    [string]$Url = "http://localhost/"
)

Write-Host "Iniciando generador de carga..." -ForegroundColor Yellow
Write-Host "   Requests: $Requests" -ForegroundColor Cyan
Write-Host "   Concurrent: $Concurrent" -ForegroundColor Cyan
Write-Host "   URL: $Url" -ForegroundColor Cyan
Write-Host ""

# Función para hacer requests
$jobs = @()
$completedRequests = 0

1..$Concurrent | ForEach-Object {
    $jobs += Start-Job -ScriptBlock {
        param($url, $requestsPerJob)
        1..$requestsPerJob | ForEach-Object {
            try {
                Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 2 | Out-Null
            }
            catch {
                # Ignorar errores de timeout
            }
        }
    } -ArgumentList $Url, ([Math]::Ceiling($Requests / $Concurrent))
}

Write-Host " $Concurrent jobs iniciados" -ForegroundColor Green
Write-Host " Esperando ..." -ForegroundColor Yellow

# Monitorear progreso
while ($jobs | Where-Object { $_.State -eq 'Running' }) {
    $completed = ($jobs | Where-Object { $_.State -eq 'Completed' }).Count
    $progress = [Math]::Round(($completed / $Concurrent) * 100, 2)
    Write-Progress -Activity "Generando carga" -Status "$progress% completado" -PercentComplete $progress
    Start-Sleep -Seconds 2
}

# Limpiar jobs
$jobs | Remove-Job

Write-Host ""
Write-Host "Generacion de carga completada" -ForegroundColor Green
