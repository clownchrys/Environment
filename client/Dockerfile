FROM ubuntu:18.04

ARG HOME=/root
ARG DEBIAN_FRONTEND=noninteractive
ARG PYTHONUNBUFFERED=0

# APT & PIP Kakao Server
COPY .config/sources.list /etc/apt/sources.list
COPY .config/pip.conf ${HOME}/.pip/pip.conf

# APT & PIP Requirements
ARG REQUIREMENTS_PATH=${HOME}/requirements
COPY ./requirements/apt/* ${REQUIREMENTS_PATH}/apt/
COPY ./requirements/pip/* ${REQUIREMENTS_PATH}/pip/

# Essential APT Pacakages
RUN apt update
RUN sed 's/#.*//' ${REQUIREMENTS_PATH}/apt/requirements_essentials.txt | xargs apt install -y && apt update

# Locale & Timezone
ARG LANG=ko_KR.UTF-8
ARG TIMEZONE=Asia/Seoul
RUN locale-gen ${LANG}
RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && echo ${TIMEZONE} > /etc/timezone

# PYENV installation
ENV PYENV_ROOT="${HOME}/.pyenv"
ENV PATH="$PYENV_ROOT/shims:$PYENV_ROOT/plugins/pyenv-virtualenv/shims:$PYENV_ROOT/bin:$PATH"
RUN sed 's/#.*//' ${REQUIREMENTS_PATH}/apt/requirements_pyenv.txt | xargs apt install -y
RUN curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
RUN \
echo '' >> ${HOME}/.bashrc && \
echo '#[PYENV]' >> ${HOME}/.bashrc && \
echo 'eval "$(pyenv init -)"' >> ${HOME}/.bashrc && \
echo 'eval "$(pyenv virtualenv-init -)"' >> ${HOME}/.bashrc
RUN pyenv update

# Python version & pip
ARG PYTHON_MAJOR=3.8
ARG PYTHON_VERSION=3.8.2
COPY ./pyenv-cache/* ${PYENV_ROOT}/cache/
RUN pyenv install ${PYTHON_VERSION} && pyenv global ${PYTHON_VERSION}
RUN pip install -U pip

# Jupyter installation
RUN pip install -r ${REQUIREMENTS_PATH}/pip/requirements_jupyter.txt
RUN python -m ipykernel install --user

# R kernel installation (3.4.4-1ubuntu1)
RUN apt install -y r-base
RUN Rscript -e "install.packages(c('repr', 'IRkernel', 'IRdisplay'), type='source')"
RUN Rscript -e "IRkernel::installspec()"

# Jupyter build
ARG NODEJS_VERSION=12
RUN curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION}.x | bash && apt install -y nodejs
RUN \
jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build && \
jupyter labextension install @jupyterlab/toc --no-build && \
jupyter labextension install jupyterlab-drawio --no-build && \
jupyter lab build

# Jupyter-nbconvert installation
COPY \
./nbconvert-templates/* \
${PYENV_ROOT}/versions/${PYTHON_VERSION}/lib/python${PYTHON_MAJOR}/site-packages/nbconvert/templates/latex/
RUN sed 's/#.*//' ${REQUIREMENTS_PATH}/apt/requirements_nbconvert.txt | xargs apt install -y

# APT & PIP Installation (Common Applications)
RUN sed 's/#.*//' ${REQUIREMENTS_PATH}/apt/requirements.txt | xargs apt install -y
RUN pip install -r ${REQUIREMENTS_PATH}/pip/requirements.txt

# Additional kernelspec (ref. https://jupyter-client.readthedocs.io/en/stable/kernels.html)
ARG VENV_VER=3.7.5
ARG VENV_NAME=opencv3
RUN pyenv install ${VENV_VER}
RUN /bin/bash -i -c \
'pyenv virtualenv ${VENV_VER} ${VENV_NAME} && \
pyenv activate ${VENV_NAME} && \
pip install -U pip && pip install ipykernel && \
python -m ipykernel install --user --name ${VENV_NAME} && \
pip install -r ${REQUIREMENTS_PATH}/pip/venv_${VENV_NAME}.txt && \
pyenv deactivate'

# Run Jupyter
WORKDIR ${HOME}/Workspace
ENTRYPOINT [ "jupyter", "lab" ]