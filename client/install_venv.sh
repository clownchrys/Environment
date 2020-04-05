#!/bin/bash

# Help
if [ "${1}" == '--help' -o "${1}" == '-h' -o "$#" -eq 0 ]; then
    printf "[Help]\ninstall_venv.sh [VENV_VER] [VENV_NAME] (REQUIREMENTS)\n"
    exit
fi

# Description
VENV_VER=$1
VENV_NAME=$2
REQUIREMENTS=$3

if [ "${VENV_NAME}" == '' ]; then
    echo "'VENV_NAME' must be specified"
    exit
fi
if [ "${REQUIREMENTS}" == '' ]; then
    REQUIREMENTS='-'
fi

printf "[Description]\nVersion: ${VENV_VER}\nName: ${VENV_NAME}\nRequirements: ${REQUIREMENTS}\n\n"

# Installation
echo '[Installation]'
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pyenv virtualenv ${VENV_VER} ${VENV_NAME} &&
pyenv activate ${VENV_NAME} &&
pip install -U pip &&
pip install ipykernel &&
python -m ipykernel install --user --name ${VENV_NAME} &&

if [ "${REQUIREMENTS}" != '-' ]; then
    pip install -r ${REQUIREMENTS}
fi &&

pyenv deactivate &&

# Complete
printf '\n[Complete]\nVirtualenv Installed!\n'
exit