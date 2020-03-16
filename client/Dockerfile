FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=0

# APT & PIP Kakao Server
RUN \
mkdir -p /etc/apt && \
mkdir -p /root/.pip
ADD ./requirements/apt/sources.list /etc/apt
ADD ./requirements/pip/pip.conf /root/.pip

# Locale
RUN apt update && \
apt install -y locales && \
locale-gen ko_KR.UTF-8

# Timezone
ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
echo $TZ > /etc/timezone

# Installation base tools
RUN apt install -y \
apt-utils \
curl \
wget \
git

# PYENV installation
ENV PYENV_ROOT="/.pyenv" \
    PATH="/.pyenv/bin:/.pyenv/shims:$PATH"

RUN apt install -y \
make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
libsqlite3-dev llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev

RUN curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash && \
pyenv update && \
echo '\n#pyenv\neval "$(pyenv virtualenv-init -)"\neval "$(pyenv init -)"' >> /root/.bashrc

# Python version & pip
ENV PYENV_PYTHON_MIRROR_URL="http://npm.taobao.org/mirrors/python"
RUN pyenv install 3.8.1 && \
pyenv global 3.8.1 && \
pip3 install -U pip

# Jupyter installation
RUN pip install \
ipykernel==5.1.4 \
jupyter==1.0.0 \
jupyter-client==6.0.0 \
jupyter-console==6.1.0 \
jupyter-core==4.6.3 \
jupyterlab==1.2.6 \
jupyterlab-server==1.0.7 \
nbconvert==5.6.1

# Python kernel installation
RUN python -m ipykernel install --user

# R kernel installation
RUN apt install -y r-base=3.4.4-1ubuntu1 && \
Rscript -e "install.packages(c('repr', 'IRkernel', 'IRdisplay'), type='source')" && \
Rscript -e "IRkernel::installspec()"

# nodejs (For labextension)
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash && \
apt install -y nodejs

# Jupyter build
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build && \
jupyter labextension install @jupyterlab/toc --no-build && \
jupyter labextension install jupyterlab-drawio --no-build && \
jupyter lab build

# Jupyter-nbconvert installation
ADD ./nbconvert/base.tplx /.pyenv/versions/3.8.1/lib/python3.8/site-packages/nbconvert/templates/latex/
RUN apt install -y \
jupyter-nbconvert=5.3.1-1 \
pandoc=1.19.2.4~dfsg-1build4 \
texlive-xetex=2017.20180305-1 \
texlive-fonts-recommended=2017.20180305-1 \
texlive-generic-recommended=2017.20180305-1 \
texlive-generic-extra=2017.20180305-1 \
texlive-extra-utils=2017.20180305-2 \
ko.tex fonts-nanum fonts-nanum-extra

# APT installation
WORKDIR /requirements/apt
ADD ./requirements/apt/requirements.txt .
RUN sed 's/#.*//' requirements.txt | xargs apt install -y

# PIP installation
WORKDIR /requirements/pip
ADD ./requirements/pip/requirements.txt .
RUN pip install -r requirements.txt

# additional kernelspec (ref. https://jupyter-client.readthedocs.io/en/stable/kernels.html)
RUN \
/bin/bash -i -c \
'VENV_VER="3.8.1" && \
VENV_NAME="test" && \
source /root/.bashrc && \
pyenv virtualenv $VENV_VER $VENV_NAME && \
pyenv activate $VENV_NAME && \
pip install ipykernel && \
python -m ipykernel install --user --name $VENV_NAME && \
pyenv deactivate'

# RUN jupyter kernelspec list
# RUN jupyter kernelspec remove test

# Run Jupyter
WORKDIR /root/workspace
CMD ["jupyter", "lab"]