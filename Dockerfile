FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

# Install common packages
ARG PACKAGES="\
    build-essential \
    cmake \
    git \
    htop \
    locales \
    make \
    openssh-server \
    sudo \
    vim \
    zsh \
"
RUN apt-get update \
    && apt-get install -y ${PACKAGES} \
    && apt-get clean \
    && rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/*

# Configure locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales

# Create dev user
RUN addgroup --gid 1000 dev \
    && adduser --shell /bin/zsh --uid 1000 --gecos "" --gid 1000 --disabled-password dev \
    && usermod -aG sudo dev

# Install oh-my-zsh
USER dev
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
RUN echo "export TZ=Asia/Shanghai" >> /home/dev/.zshrc

# Setup entrypoint
USER root
COPY ./entrypoint.sh /entrypoint.sh
COPY ./pause.sh /pause.sh
RUN chmod +x /*.sh
ENTRYPOINT [ "/entrypoint.sh" ]
