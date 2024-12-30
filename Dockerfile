FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow
RUN apt-get update && \
  apt-get install -yq \
  wget sudo build-essential xz-utils cmake git ninja-build meson openocd gdb-multiarch default-jre libfuse2

# Download and configure the toolchain
ARG toolchain=_none
ARG toolchainFile=${toolchain}.tar.xz
COPY ${toolchainFile} /tmp/
RUN tar -xpJf /tmp/${toolchainFile} -C /usr/local --strip-components=1
RUN rm /tmp/${toolchainFile}

ARG jlink=JLink_Linux_V794k_x86_64.deb
COPY ${jlink} /tmp/
RUN apt-get install -yq /tmp/${jlink}; exit 0
RUN rm /tmp/${jlink}

RUN apt-get clean \
  && rm -rf /var/cache/apk/*

COPY wsl.conf /etc/
RUN useradd -ms /bin/bash -G adm,dialout,cdrom,floppy,sudo,audio,dip,video,plugdev developer
RUN echo "developer:developer" | chpasswd
USER developer
WORKDIR /home/developer

CMD [ "/bin/bash" ]
