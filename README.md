docker swarm init

# Ejecutar todo el stack completo

chef-client -z -j runlist.json

# Verificar todo está funcionando
docker service ls
docker service ps webapp
Get-ScheduledTask -TaskName "docker_autoscaler"


Demostración completa del autoscaling
# Terminal 1: Monitorear réplicas en tiempo real
docker service ps webapp --format "table {{.ID}}\t{{.Name}}\t{{.CurrentState}}" | Out-Host; while($true) { cls; docker service ps webapp --format "table {{.ID}}\t{{.Name}}\t{{.CurrentState}}"; Start-Sleep 5 }


# Terminal 2: Monitorear logs del autoscaler
Get-Content C:\chef-autoscaling\logs\autoscaler.log -Wait -Tail 10
o
docker stats

# En Ubuntu WSL
ab -n 50000 -c 200 http://localhost/



# Terminal 4: Ver estado del servicio
while($true) { cls; docker service ls; docker service ps webapp; Start-Sleep 3 }



docker service rm webapp
docker swarm leave --force



