FROM ubuntu:latest

# Default non root user in ubuntu official images.
ARG ENV_USER=ubuntu
ARG ENV_USER_ID=1000

ENV DEFAULT_IMG_USER="ubuntu"

# Install build tools
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl git \
    libncursesw5-dev xz-utils tk-dev libxml2-dev \
    libxmlsec1-dev libffi-dev liblzma-dev pipx

# Set default shell to bash
SHELL ["/bin/bash", "-c"]

# Setup dev user.
RUN echo "Arg user: ${ENV_USER} , id: ${ENV_USER_ID}" && \    
    if [ "$ENV_USER_ID" -eq 1000 ]; then \
        echo "Use a different user id as the defautl ubuntu user has id 1000."; \
        exit 1; \        
    else \
        echo "Creating user '${ENV_USER}' with id '${ENV_USER_ID}'"; \
        mkdir -p /home/${ENV_USER}; \
        useradd -G www-data,root -u ${ENV_USER_ID} -d /home/${ENV_USER} ${ENV_USER}; \
        chown -R ${ENV_USER}:${ENV_USER} /home/${ENV_USER}; \
    fi; \
    # Add the new user to the sudo group 
    usermod -aG sudo $ENV_USER; \
    # Allow passwordless sudo for users in the sudo group
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# # Switch to the dev user
RUN echo "Set docker user to ${ENV_USER}";
USER ${ENV_USER}
WORKDIR /ws

# Install pyenv
RUN curl https://pyenv.run | bash && \
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc && \
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc && \
echo 'eval "$(pyenv init -)"' >> ~/.bashrc && \
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile && \
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile && \
echo 'eval "$(pyenv init -)"' >> ~/.profile


# Allow pipx actions with --global argument
RUN pipx ensurepath && \
    pipx install pdm  && \
    pipx list

# Install python 3.12.1
RUN source ~/.bashrc && \
    pyenv install 3.12.1 && \
    pyenv virtualenv 3.12.1 devenv && \
    pyenv activate devenv && \
    python3.12 -m pip install --upgrade pip && \
    python -V
    
# Uncomment the following lines to make the python3.12.1 the  
# default python version in the container.
# RUN pyenv global 3.12.1
