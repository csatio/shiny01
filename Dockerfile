FROM rocker/r-base:latest

RUN apt-get update -qq && apt-get -y --no-install-recommends install \
libxml2-dev \
libcairo2-dev \
libsqlite3-dev \
libmariadbd-dev \
libpq-dev \
libssh2-1-dev \
unixodbc-dev \
libcurl4-openssl-dev \
libssl-dev

RUN R -e 'install.packages("remotes")'
RUN Rscript -e 'remotes::install_version("glue",upgrade="never", version = "1.4.2")'
RUN Rscript -e 'remotes::install_version("processx",upgrade="never", version = "3.5.2")'
RUN Rscript -e 'remotes::install_version("htmltools",upgrade="never", version = "0.5.1.1")'
RUN Rscript -e 'remotes::install_version("httr",upgrade="never", version = "1.4.2")'
RUN Rscript -e 'remotes::install_version("pkgload",upgrade="never", version = "1.2.1")'
RUN Rscript -e 'remotes::install_version("knitr",upgrade="never", version = "1.31")'
RUN Rscript -e 'remotes::install_version("attempt",upgrade="never", version = "0.3.1")'
RUN Rscript -e 'remotes::install_version("testthat",upgrade="never", version = "3.0.2")'
RUN Rscript -e 'remotes::install_version("shiny",upgrade="never", version = "1.6.0")'
RUN Rscript -e 'remotes::install_version("config",upgrade="never", version = "0.3.1")'
RUN Rscript -e 'remotes::install_version("spelling",upgrade="never", version = "2.2")'
RUN Rscript -e 'remotes::install_version("rmarkdown",upgrade="never", version = "2.8")'
RUN Rscript -e 'remotes::install_version("golem",upgrade="never", version = "0.3.1")'
RUN Rscript -e 'remotes::install_version("ggplot2",upgrade="never", version = "3.3.3")'
RUN Rscript -e 'remotes::install_version("DT",upgrade="never", version = "0.18")'
RUN Rscript -e 'remotes::install_version("shinydashboard", version = "0.7.1")'
RUN R -e 'install.packages("tidyverse")'
RUN R -e 'install.packages("tidymodels")'
RUN R -e 'install.packages("vip")'
RUN R -e 'install.packages("jsonlite")'
RUN R -e 'install.packages("workflows")'
RUN R -e 'install.packages("magrittr")'
RUN R -e 'install.packages("recipes")'
RUN R -e 'install.packages("glmnet")'
RUN mkdir /build_zone
ADD . /build_zone
WORKDIR /build_zone
RUN R -e 'remotes::install_local(upgrade="never")'
EXPOSE 80
CMD R -e "options('shiny.port'=80,shiny.host='0.0.0.0');shiny01::run_app()"
