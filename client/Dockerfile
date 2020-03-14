FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=0

# APT src
RUN mkdir -p /etc/apt
ADD ./requirements/apt/sources.list /etc/apt

# PIP src
RUN mkdir -p /root/.pip
ADD ./requirements/pip/pip.conf /root/.pip

# locale
RUN apt update
RUN apt install -y locales
RUN locale-gen ko_KR.UTF-8

# timezone
ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# APT installation
WORKDIR /requirements
ADD ./requirements/apt/requirements_apt.txt .
RUN sed 's/#.*//' requirements_apt.txt | xargs apt install -y
RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
RUN apt install -y nodejs

# PIP installation
WORKDIR /requirements
ADD ./requirements/pip/requirements_pip.txt .
RUN pip3 install -U pip
RUN pip install -r requirements_pip.txt

# Default python version3
WORKDIR /usr/bin
RUN ln -sf python3 python

# Jupyter build & run
WORKDIR /root/workspace
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build
RUN jupyter labextension install @jupyterlab/toc --no-build
RUN jupyter labextension install jupyterlab-drawio --no-build
RUN jupyter lab build

CMD ["jupyter", "lab"]