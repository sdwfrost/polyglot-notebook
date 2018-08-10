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
    NIMBLE_DIR=/opt/nimble

# Scilab
ENV SCILAB_VERSION=6.0.1
ENV SCILAB_EXECUTABLE=/usr/local/bin/scilab-adv-cli
RUN mkdir /opt/scilab-${SCILAB_VERSION} && \
    cd /tmp && \
    wget http://www.scilab.org/download/6.0.1/scilab-${SCILAB_VERSION}.bin.linux-x86_64.tar.gz && \
    tar xvf scilab-${SCILAB_VERSION}.bin.linux-x86_64.tar.gz -C /opt/scilab-${SCILAB_VERSION} --strip-components=1 && \
    rm /tmp/scilab-${SCILAB_VERSION}.bin.linux-x86_64.tar.gz && \
    ln -fs /opt/scilab-${SCILAB_VERSION}/bin/scilab-adv-cli /usr/local/bin/scilab-adv-cli && \
    ln -fs /opt/scilab-${SCILAB_VERSION}/bin/scilab-cli /usr/local/bin/scilab-cli && \
    pip install scilab_kernel

# XPP
RUN mkdir /opt/xppaut && \
    cd /tmp && \
    wget http://www.math.pitt.edu/~bard/bardware/binary/latest/xpplinux.tgz && \
    tar xvf xpplinux.tgz -C /opt/xppaut --strip-components=1 && \
    rm /tmp/xpplinux.tgz && \
    ln -fs /opt/xppaut/xppaut /usr/local/bin/xppaut

# R packages
RUN R -e "install.packages(c('pomp','deSolve','ddeSolve','simecol','FME','GillespieSSA'), dependencies=TRUE, clean=TRUE, repos='https://cran.microsoft.com/snapshot/2018-08-01')"

# Add Julia packages.
# RUN julia -e 'Pkg.update()' && \
#   julia -e 'Pkg.add("DifferentialEquations")' && \
#    # Precompile Julia packages \
#    julia -e 'using DifferentialEquations' && \
#    rm -rf $HOME/.local && \
#    fix-permissions $JULIA_PKGDIR

USER ${NB_USER}

# Specify the default command to run
CMD ["jupyter", "notebook", "--ip", "0.0.0.0"]
