#
# Cookbook:: prueba
# Recipe:: webserver
#
# Configuración básica de Nginx
#

log 'configurando_nginx' do
  message 'Configurando servidor web Nginx...'
  level :info
end

# Nginx esté instalado
package 'nginx' do
  action :install
end

# crear configuración básica de Nginx
template '/etc/nginx/sites-available/default' do
  source 'nginx.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    server_name: node['prueba']['server_name'],
    document_root: node['prueba']['document_root'],
    port: node['prueba']['port']
  )
  notifies :reload, 'service[nginx]', :delayed
end

# crear página web personalizada
template "#{node['prueba']['document_root']}/index.html" do
  source 'index.html.erb'
  owner 'www-data'
  group 'www-data'
  mode '0644'
  variables(
    app_name: node['prueba']['app_name'],
    app_version: node['prueba']['app_version'],
    server_name: node['prueba']['server_name'],
    node_info: {
      hostname: node['hostname'],
      platform: "#{node['platform']} #{node['platform_version']}",
      memory: node['memory'] ? "#{(node['memory']['total'].to_i / 1024 / 1024)} GB" : 'N/A',
      cpu: node['cpu'] ? node['cpu']['total'] : 'N/A',
      deployment_time: Time.now.strftime('%Y-%m-%d %H:%M:%S')
    }
  )
end

# Asegurar Nginx esté corriendo
service 'nginx' do
  action [:enable, :start]
  supports restart: true, reload: true, status: true
end

# Verificar que Nginx responda
execute 'verificar_nginx' do
  command 'curl -f http://localhost/ > /dev/null'
  retries 3
  retry_delay 2
  action :run
  only_if 'systemctl is-active nginx'
end

log 'nginx_configurado' do
  message 'Servidor web Nginx configurado y funcionando'
  level :info
end