ARG ALMA_VERSION=9.1

FROM almalinux:$ALMA_VERSION
ARG ALMA_VERSION
ARG KERNEL_VERSION=5.14.0-162.6.1.el9_1
ARG DRIVER_VERSION=4.50.0.2
ARG DRIVER_RELEASE=1

LABEL description="Docker image intended for building rpm packages of utimacto's CryptoServer driver"
LABEL maintainer="pablo@evicertia.com"
LABEL vendor="evicertia"

VOLUME /outputs
WORKDIR /var/tmp

# Install base stuff..

ENV TZ=UTC
ENV KERNEL_VERSION=$KERNEL_VERSION
ENV DRIVER_VERSION=$DRIVER_VERSION
ENV DRIVER_RELEASE=$DRIVER_RELEASE
RUN yum -y install epel-release
RUN yum -y install \
    gcc make cpio kmod perl bzip2 \
    vim-enhanced  rpmdevtools \
    kernel-devel-$KERNEL_VERSION

RUN curl -LO https://github.com/goreleaser/nfpm/releases/download/v2.26.0/nfpm_2.26.0_Linux_x86_64.tar.gz \
 && tar -xvzf nfpm_2.26.0_Linux_x86_64.tar.gz \
 && mv nfpm /usr/local/bin

#ADD non-free/cryptoserver-driver-v${DRIVER_VERSION}-linux.tgz /var/tmp/

CMD ["/bin/bash"]
