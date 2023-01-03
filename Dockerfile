FROM ubuntu:20.04

# Install any needed packages specified in requirements.txt
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow
RUN apt update && \
  apt install -yq \
  libncurses5 libncurses5-dev \
  libncursesw5 libncursesw5-dev \
  libssl-dev python3.8\
  wget xz-utils cmake git ninja-build \
  && rm -rf /var/cache/apk/*

# Download and configure the toolchain
ARG toolchain=arm-gnu-toolchain-11.3.rel1-x86_64-arm-none-eabi.tar.xz
COPY ${toolchain} /opt/
RUN cd /opt/ && tar -xpJf ${toolchain} && rm /opt/${toolchain}

ENV PATH "/opt/arm-gnu-toolchain-11.3.rel1-x86_64-arm-none-eabi/bin:$PATH"

WORKDIR /workdir

CMD [ "/bin/bash" ]
