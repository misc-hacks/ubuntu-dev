FROM --platform=${TARGETPLATFORM} ubuntu:20.04

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

# Create dev user
RUN addgroup --gid 1000 dev \
    && adduser --shell /bin/zsh --uid 1000 --gecos "" --gid 1000 --disabled-password dev \
    && usermod -aG sudo dev

# Install oh-my-zsh
USER dev
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
USER root

# Configure timezone and locales
RUN echo "export TZ=Asia/Shanghai" >> /home/dev/.zshrc

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
RUN echo "\
export LANG=en_US.UTF-8\n\
export LANGUAGE=en_US:en\n\
export LC_ALL=en_US.UTF-8\n\
" >> /home/dev/.zshrc \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales

# Setup entrypoint
COPY ./entrypoint.sh /entrypoint.sh
COPY ./pause.sh /pause.sh
RUN chmod +x /*.sh
ENTRYPOINT [ "/entrypoint.sh" ]
