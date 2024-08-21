FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow
RUN apt-get update && \
  apt-get install -yq \
  wget build-essential xz-utils cmake git ninja-build meson openocd gdb-multiarch default-jre libfuse2

# Download and configure the toolchain
ARG toolchain=_none
ARG toolchainFile=${toolchain}.tar.xz
COPY ${toolchainFile} /opt/
RUN cd /opt/ && tar -xpJf ${toolchainFile} && rm /opt/${toolchainFile}

ENV PATH="/opt/${toolchain}/bin:$PATH"

ARG jlink=JLink_Linux_V794k_x86_64.deb
COPY ${jlink} /tmp/
RUN apt-get install -yq /tmp/${jlink}; exit 0
RUN rm /tmp/${jlink}

RUN apt-get clean \
  && rm -rf /var/cache/apk/*

USER ubuntu
WORKDIR /workspace

CMD [ "/bin/bash" ]
