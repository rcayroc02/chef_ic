# Construir la imagen de la aplicación
powershell_script 'build_webapp_image' do
  code <<-EOH
    $imageExists = docker images --format "{{.Repository}}:{{.Tag}}" | Select-String "webapp-demo:v1"
    if (-not $imageExists) {
      Write-Host "Construyendo imagen webapp-demo:v1..."
      $currentPath = Get-Location
      Set-Location "#{ENV['USERPROFILE']}\\Desktop\\chef-autoscaling\\webapp"
      docker build -t webapp-demo:v1 .
      Set-Location $currentPath
      if ($LASTEXITCODE -eq 0) {
        Write-Host "Imagen construida exitosamente"
        exit 0
      }
      else {
        Write-Error "Error al construir la imagen"
        exit 1
      }
    }
    else {
      Write-Host "Imagen webapp-demo:v1 ya existe"
      exit 0
    }
  EOH
  action :run
end

# Desplegar servicio en Swarm con réplicas iniciales
powershell_script 'deploy_webapp_service' do
  code <<-EOH
    $serviceExists = docker service ls --format "{{.Name}}" | Select-String "^webapp$"
    if (-not $serviceExists) {
      Write-Host "Desplegando servicio webapp..."
      docker service create `
        --name webapp `
        --replicas 2 `
        --publish published=80,target=80 `
        --limit-cpu 0.25 `
        --reserve-cpu 0.1 `
        --limit-memory 128M `
        --reserve-memory 64M `
        --update-parallelism 1 `
        --update-delay 10s `
        webapp-demo:v1 2>&1 | Out-Null
      
      if ($LASTEXITCODE -eq 0) {
        Write-Host "Servicio desplegado exitosamente"
        exit 0
      }
      else {
        Write-Error "Error al desplegar servicio"
        exit 1
      }
    }
    else {
      Write-Host "Servicio webapp ya existe"
      exit 0
    }
  EOH
  action :run
end

# Esperar a que el servicio esté listo
powershell_script 'wait_for_service' do
  code <<-EOH
    Write-Host "Esperando a que el servicio esté listo..."
    Start-Sleep -Seconds 10
    $replicas = docker service ls --filter name=webapp --format "{{.Replicas}}"
    Write-Host "Estado del servicio: $replicas"
    exit 0
  EOH
  action :run
end