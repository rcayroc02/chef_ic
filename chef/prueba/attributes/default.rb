# Configuración básica del servidor web
default['prueba']['app_name'] = ' Web'
default['prueba']['app_version'] = '1.0.0'
default['prueba']['server_name'] = 'my-server.local'
default['prueba']['document_root'] = '/var/www/html'
default['prueba']['port'] = 80

# Lista de paquetes a instalar
default['prueba']['packages'] = %w[
  nginx
  curl
  git
  vim
]