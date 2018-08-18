FROM sdwfrost/polyglot:latest

LABEL maintainer="Simon Frost <sdwfrost@gmail.com>"

USER root

ENV DEBIAN_FRONTEND noninteractive

# Configure environment
ENV CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    NB_USER=jovyan \
    NB_UID=1000 \
    NB_GID=100 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    JULIA_PKGDIR=/opt/julia \
    HOME=/home/$NB_USER \
    NIMBLE_DIR=/opt/nimble \
    SCILAB_EXECUTABLE=/usr/local/bin/scilab-adv-cli

# R packages
# RUN R -e "install.packages(c(""), dependencies=TRUE, clean=TRUE, repos='https://cran.microsoft.com/snapshot/2018-08-01')"
RUN R -e "devtools::install_github('mrc-ide/odin',upgrade = FALSE)"

# Add Julia packages.
# RUN julia -e 'Pkg.update()' && \
#   julia -e 'Pkg.add("DifferentialEquations")' && \
#    # Precompile Julia packages \
#    julia -e 'using DifferentialEquations' && \
#    rm -rf $HOME/.local && \
#    fix-permissions $JULIA_PKGDIR

# Clean up repo
RUN rm ${HOME}/Dockerfile
RUN rm ${HOME}/fix-permissions

USER ${NB_USER}

# Specify the default command to run
CMD ["jupyter", "notebook", "--ip", "0.0.0.0"]
