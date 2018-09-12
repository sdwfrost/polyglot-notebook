FROM sdwfrost/polyglot-base:latest

LABEL maintainer="Simon Frost <sdwfrost@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

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
    'spatial'), dependencies=TRUE, clean=TRUE, repos='https://cran.microsoft.com/snapshot/2018-08-14')" && \
    R -e "devtools::install_github('mrc-ide/odin',upgrade=FALSE)"

# Python libraries
RUN pip install \
    cython \
    gr \
    ipywidgets \
    matplotlib \
    nteract_on_jupyter \
    numba \
    numexpr \
    pandas \
    papermill \
    plotly \
    scipy \
    seaborn \
    sympy && \
    # Activate ipywidgets extension in the environment that runs the notebook server
    jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
    npm cache clean --force && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    rm -rf /home/$NB_USER/.node-gyp && \
    fix-permissions /home/$NB_USER

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions /home/$NB_USER

RUN cd /tmp && \
    git clone https://github.com/robclewley/pydstool && \
    cd pydstool && \
    python setup.py install && \
    cd /tmp && \
    rm -rf pydstool

# Julia packages
RUN julia -e 'Pkg.update()' && \
    julia -e 'Pkg.add("DataFrames")' && \
    julia -e 'Pkg.add("Feather")' && \
    julia -e 'Pkg.add("Gadfly")' && \
    julia -e 'Pkg.add("GR")' && \
    julia -e 'Pkg.add("Plots")' && \
    julia -e 'Pkg.add("DifferentialEquations")' && \
    julia -e 'Pkg.add("NamedArrays")' && \
    julia -e 'Pkg.add("RandomNumbers")' && \
    julia -e 'Pkg.add("Gillespie")' && \
    julia -e 'Pkg.add("PyCall")' && \
    julia -e 'Pkg.add("PyPlot")' && \
    julia -e 'Pkg.add("PlotlyJS")' && \
    julia -e 'Pkg.add("SymPy")' && \
    # Precompile Julia packages \
    julia -e 'using DataFrames' && \
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
    julia -e 'using PlotlyJS' && \
    julia -e 'using SymPy' && \
    rm -rf $HOME/.local && \
    fix-permissions $JULIA_PKGDIR

# Javascript
RUN npm install -g \
    @redfish/agenscript \
    plotly-notebook-js \
    ode-rk4

RUN cd ${HOME}
