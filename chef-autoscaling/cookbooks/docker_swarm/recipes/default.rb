#  Docker está corriendo
powershell_script 'check_docker' do
  code <<-EOH
    try {
      docker info 2>&1 | Out-Null
      exit 0
    }
    catch {
      Write-Error "Docker no está corriendo"
      exit 1
    }
  EOH
  action :run
end

# Inicializar Docker Swarm (ignorando si ya existe)
powershell_script 'initialize_swarm' do
  code <<-EOH
    $swarmStatus = docker info 2>&1 | Select-String "Swarm: active"
    if (-not $swarmStatus) {
      Write-Host "Inicializando Docker Swarm..."
      docker swarm init --advertise-addr 127.0.0.1 2>&1 | Out-Null
      if ($LASTEXITCODE -eq 0 -or $LASTEXITCODE -eq 1) {
        Write-Host "Swarm inicializado correctamente"
        exit 0
      }
      else {
        Write-Error "Error al inicializar Swarm"
        exit 1
      }
    }
    else {
      Write-Host "Swarm ya está activo"
      exit 0
    }
  EOH
  action :run
end

# Crear red overlay (ignorando si ya existe)
powershell_script 'create_overlay_network' do
  code <<-EOH
    $networkExists = docker network ls 2>&1 | Select-String "webapp-network"
    if (-not $networkExists) {
      Write-Host "Creando red overlay webapp-network..."
      docker network create -d overlay webapp-network 2>&1 | Out-Null
      if ($LASTEXITCODE -eq 0 -or $LASTEXITCODE -eq 1) {
        Write-Host "Red creada correctamente"
        exit 0
      }
      else {
        Write-Error "Error al crear red"
        exit 1
      }
    }
    else {
      Write-Host "Red webapp-network ya existe"
      exit 0
    }
  EOH
  action :run
end