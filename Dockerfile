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
    HOME=/home/$NB_USER

# Add Julia packages.
RUN julia -e 'Pkg.update()' && \
    julia -e 'Pkg.add("DifferentialEquations")' && \
    # Precompile Julia packages \
    julia -e 'using DifferentialEquations' && \
    rm -rf $HOME/.local && \
    fix-permissions $JULIA_PKGDIR

# USER ${NB_USER}

# Specify the default command to run
CMD ["jupyter", "notebook", "--ip", "0.0.0.0"]
