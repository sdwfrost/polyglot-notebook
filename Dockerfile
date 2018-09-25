FROM sdwfrost/polyglot-base:latest

LABEL maintainer="Simon Frost <sdwfrost@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

# Configure environment
ENV SHELL=/bin/bash \
    NB_USER=jovyan \
    NB_UID=1000 \
    NB_GID=100 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

ENV HOME=/home/$NB_USER

USER root   

# Python
RUN pip install \
    EoN \
    pydstool \
    pygom \
    salabim \
    simpy \
    tzlocal && \
    fix-permissions /home/$NB_USER /usr/local/lib/python3.6

# R packages

RUN R -e "setRepositories(ind=1:2);install.packages(c(\
    'adaptivetau', \
    'boot', \
    'cOde', \
    'deSolve',\
    'devtools', \
    'ddeSolve', \
    'feather', \
    'GillespieSSA', \
    'git2r', \
    'ggplot2', \
    'FME', \
    'KernSmooth', \
    'magrittr', \
    'odeintr', \
    'PBSddesolve', \
    'plotly', \
    'pomp', \
    'pracma', \
    'ReacTran', \
    'reticulate', \
    'rmarkdown', \
    'rodeo', \
    'Rcpp', \
    'rpgm', \
    'simecol', \
    'simmer', \
    'spatial'), dependencies=TRUE, clean=TRUE, repos='https://cran.microsoft.com/snapshot/2018-08-14')" && \
    R -e "devtools::install_github('mrc-ide/odin',upgrade=FALSE)" && \
    fix-permissions /usr/local/lib/R

# Julia packages
# Takes a long time to download, so spread over multiple commands
RUN julia -e 'Pkg.update()'
RUN julia -e 'Pkg.add("DataFrames")'
RUN julia -e 'Pkg.add("Feather")'
RUN julia -e 'Pkg.add("Gadfly")'
RUN julia -e 'Pkg.add("GR")'
RUN julia -e 'Pkg.add("Plots")'
RUN julia -e 'Pkg.add("DifferentialEquations")'
RUN julia -e 'Pkg.add("NamedArrays")'
RUN julia -e 'Pkg.add("RandomNumbers")'
RUN julia -e 'Pkg.add("Gillespie")'
RUN julia -e 'Pkg.add("PyCall")'
RUN julia -e 'Pkg.add("PyPlot")'
RUN julia -e 'Pkg.add("RCall")'
RUN julia -e 'Pkg.add("SymPy")'
# Precompile Julia packages \
RUN julia -e 'using DataFrames' && \
    julia -e 'using Feather' && \
    julia -e 'using Gadfly' && \
    julia -e 'using GR' && \
    julia -e 'using Plots' && \
    julia -e 'using DifferentialEquations' && \
    julia -e 'using NamedArrays' && \
    julia -e 'using RandomNumbers' && \
    julia -e 'using Gillespie' && \
    julia -e 'using PyCall' && \
    julia -e 'using PyPlot' && \
    julia -e 'using RCall' && \
    julia -e 'using SymPy' && \
    rm -rf $HOME/.local && \
    fix-permissions $JULIA_PKGDIR

ENV PATH=/opt/cling/cling*/bin:$PATH
RUN cd $HOME && \
    git clone https://github.com/QuantStack/xeus-cling && \
    #cd xeus-cling && \
    #mkdir build && \
    #cd build && \
    #cmake -DCMAKE_INSTALL_PREFIX=/usr/local  -DLLVM_CONFIG=/opt/cling/cling*/bin/llvm-config .. && \
    #make && \
    #make install && \
    #cd /tmp && \
    #rm -rf xeus-cling && \
    fix-permissions /opt/cling

USER $NB_USER

# Javascript
RUN npm install -g \
    @redfish/agentscript \
    ode-rk4 \
    plotly-notebook-js \
    rmath

RUN cd ${HOME}
