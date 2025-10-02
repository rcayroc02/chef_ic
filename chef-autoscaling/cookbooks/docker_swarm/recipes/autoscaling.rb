# directorio para logs
directory 'C:\chef-autoscaling\logs' do
  recursive true
  action :create
end

# deploy script de autoscaling
template 'C:\chef-autoscaling\autoscaler.ps1' do
  source 'autoscaler.ps1.erb'
  variables(
    min_replicas: 2,
    max_replicas: 8,
    cpu_threshold_high: 70,
    cpu_threshold_low: 30
  )
  action :create
end

# Ejecutar el autoscaler mediante tarea de windows
windows_task 'docker_autoscaler' do
  command 'powershell.exe -ExecutionPolicy Bypass -File "C:\chef-autoscaling\autoscaler.ps1"'
  cwd 'C:\chef-autoscaling'
  run_level :highest
  frequency :minute
  frequency_modifier 1
  action [:create, :enable]
end
