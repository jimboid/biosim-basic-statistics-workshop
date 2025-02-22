# Start with BioSim base image.
ARG BASE_IMAGE=latest
FROM ghcr.io/jimboid/biosim-jupyterhub-base:$BASE_IMAGE

LABEL maintainer="James Gebbie-Rayet <james.gebbie@stfc.ac.uk>"
LABEL org.opencontainers.image.source=https://github.com/jimboid/biosim-basic-statistics-workshop
LABEL org.opencontainers.image.description="A container environment for the ccpbiosim workshop on basic statistics."
LABEL org.opencontainers.image.licenses=MIT

# Switch to jovyan user.
USER $NB_USER
WORKDIR $HOME

# Install workshop deps
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
      conda config --env --set subdir osx-arm64; \
    fi
RUN conda install mdtraj matplotlib numpy -y
RUN conda install ipywidgets -c conda-forge -y

# Get workshop files and move them to jovyan directory.
RUN git clone https://github.com/CCPBioSim/basic-statistics-workshop.git && \
    mv basic-statistics-workshop/* . && \
    rm -r AUTHORS LICENSE README.md basic-statistics-workshop

# Copy lab workspace
COPY --chown=1000:100 default-37a8.jupyterlab-workspace /home/jovyan/.jupyter/lab/workspaces/default-37a8.jupyterlab-workspace

# UNCOMMENT THIS LINE FOR REMOTE DEPLOYMENT
COPY jupyter_notebook_config.py /etc/jupyter/

# Always finish with non-root user as a precaution.
USER $NB_USER
