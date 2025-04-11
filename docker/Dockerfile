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
    if [ "${ENV_USER}" == "ubuntu" ]; then \
        echo "Using default ubuntu user."; \
    elif [ "${ENV_USER}" != "ubuntu" ] && [ ${ENV_USER_ID} -eq 1000 ]; then \
        echo "Use a different user id as the defautl ubuntu user has id 1000."; \
        exit 1; \
    else \
        echo "Creating user '${ENV_USER}' with id '${ENV_USER_ID}'"; \
        mkdir -p /home/${ENV_USER}; \
        useradd -G root -u ${ENV_USER_ID} -d /home/${ENV_USER} ${ENV_USER}; \
        chown -R ${ENV_USER}:${ENV_USER} /home/${ENV_USER}; \
    fi; \
    # Add the new user to the sudo group 
    usermod -aG sudo $ENV_USER; \
    # Allow passwordless sudo for users in the sudo group
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# # Switch to the dev user
RUN echo "Set docker user to ${ENV_USER}";
USER ${ENV_USER}
WORKDIR /home/ubuntu/workspace

# Install pyenv
RUN curl -fsSL https://pyenv.run | bash && \
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc  && \
    echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc  && \
    echo 'eval "$(pyenv init - bash)"' >> ~/.bashrc && \
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile  && \
    echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile  && \
    echo 'eval "$(pyenv init - bash)"' >> ~/.profile

RUN pwd && \
    . ~/.bashrc && \
    . ~/.profile && \
    echo "PYENV_ROOT: $PYENV_ROOT" && \
    echo "PYENV_SHELL: $PYENV_SHELL" && \
    pyenv --version

# # Allow pipx actions with --global argument
RUN pipx ensurepath && \
    pipx install pdm  && \
    pipx list

