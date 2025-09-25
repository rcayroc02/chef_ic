FROM ubuntu:20.04


ENV DEBIAN_FRONTEND=noninteractive

# instalar Chef y dependencias básicas para la prueba de iac
RUN apt-get update && \
    apt-get install -y wget curl gnupg2 && \
    wget -O- https://packages.chef.io/chef.asc | apt-key add - && \
    echo "deb https://packages.chef.io/repos/apt/stable focal main" > /etc/apt/sources.list.d/chef-stable.list && \
    apt-get update && \
    apt-get install -y chef && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


WORKDIR /cookbooks


COPY . /cookbooks/prueba/


CMD ["/bin/bash"]