FROM rocker/r-ver:4.4.2
WORKDIR /app

COPY install_packages.R .
RUN Rscript install_packages.R

COPY model.R .
CMD ["Rscript", "model.R"]