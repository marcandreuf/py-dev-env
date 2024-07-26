# Python development environment with Pyenv

# Configure the .env file 
With your user name and user id there should not be permission problems.

# Create new virtual env for a project with: 

```bash
PY_INSTALL_VERSION=3.11 && \
PY_VENV_NAME=any-name-here && \
pyenv install $PY_INSTALL_VERSION && \
pyenv virtualenv $PY_INSTALL_VERSION $PY_VENV_NAME && \
pyenv activate $PY_VENV_NAME && \
python -V
```
> NOTE: update the PY_ variables to you project needs.

# Dev tools available
* [Pyenv](https://github.com/pyenv/pyenv)
* [PIPX](https://github.com/pypa/pipx)
* [PDM](https://pdm-project.org/en/latest/)

