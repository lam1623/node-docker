# Utiliza una imagen base de Ubuntu 22.04
FROM ubuntu:22.04

# Información del mantenedor
LABEL maintainer="Lino Alfonso <lleisdier.alfonso@gmail.com>"

# Configuración de variables de entorno para evitar interacción con el frontend de Debian
ARG DEBIAN_FRONTEND=noninteractive

# Actualiza el sistema y luego instala las dependencias del sistema
RUN apt-get update && apt-get install -y \
    python2 \
    wget \
    gcc \
    g++ \
    make \
    zip \
    unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Directorio donde se instalará nvm
ARG NVM_DIR=/usr/local/nvm
ARG NODE_VERSION

# Instala nvm y node
RUN mkdir -p $NVM_DIR && wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash \
    && . $NVM_DIR/nvm.sh && nvm install $NODE_VERSION

# Configuración de variables de entorno relacionadas con Node.js
ENV NODE_DIR $NVM_DIR/versions/node/v$NODE_VERSION
ENV NODE_PATH $NODE_DIR/lib/node_modules
ENV PATH $NODE_DIR/bin:$PATH

# Instala gulp
RUN npm install --global gulp-cli@2.2.0

# Crea un usuario no root para ejecutar la aplicación
RUN useradd -m myuser
USER myuser

# Crea el directorio para scripts de entrada
RUN mkdir /docker-entrypoint.d/

# Configura el script de entrada
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Comando de inicio por defecto (se ejecutará al correr el contenedor)
ENTRYPOINT ["/docker-entrypoint.sh"]

# Comando por defecto para el contenedor (se ejecutará si no se proporciona otro comando al ejecutar el contenedor)
CMD ["/bin/bash"]
