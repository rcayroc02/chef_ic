#
# Cookbook:: prueba
# Recipe:: default
#
# Copyright:: 2025, The Authors, All Rights Reserved.


log 'inicio_deployment' do
  message '[--- begin deployment con Chef ---]'
  level :info
end

# updat 
apt_update 'update_sources' do
  action :update
  only_if { platform_family?('debian') }
end


package 'instalar_paquetes_basicos' do
  package_name node['prueba']['packages']
  action :install
end


directory node['prueba']['document_root'] do
  owner 'www-data'
  group 'www-data'
  mode '0755'
  recursive true
  action :create
end


include_recipe 'prueba::webserver'

# Crear un archivo de información del sistema
file '/tmp/chef_deployment.log' do
  content <<~LOG
    Deployment completado: #{Time.now}
    Cookbook: #{cookbook_name}
    Nodo: #{node['fqdn']}
    Plataforma: #{node['platform']} #{node['platform_version']}
    Aplicación: #{node['prueba']['app_name']}
    Versión: #{node['prueba']['app_version']}
  LOG
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

log 'fin_deployment' do
  message '=== Deployment completado exitosamente ==='
  level :info
end