FROM rocker/shiny-verse

# Instalar bibliotecas para o tidyverse
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
  build-essential \
  libcurl4-gnutls-dev \
  libxml2-dev \
  libssl-dev \
  r-cran-curl \
  r-cran-openssl \
  curl \
  gnupg1 \
  r-cran-xml2

RUN R -e 'install.packages("tidyverse")'
RUN R -e 'install.packages("tidymodels")'
RUN R -e 'install.packages("vip")'
RUN R -e 'install.packages("jsonlite")'
RUN R -e 'install.packages("workflows")'
RUN R -e 'install.packages("magrittr")'
RUN R -e 'install.packages("recipes")'
RUN R -e 'install.packages("glmnet")'

# Instalar seu próprio app (e suas dependências)
COPY ./ /tmp/app/
RUN R -e "remotes::install_local('/tmp/app/')"

# Copiar arquivos para o lugar certo
EXPOSE 80/tcp
RUN rm /srv/shiny-server/index.html
COPY ./inst/app /srv/shiny-server/
COPY ./inst/app/shiny-server.conf /etc/shiny-server/shiny-server.conf

# Run
CMD ["/usr/bin/shiny-server.sh"]
