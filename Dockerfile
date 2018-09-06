FROM ubuntu:16.04

MAINTAINER Monerador <monerador@superpools.online>
LABEL maintainer="Monerador <monerador@superpools.online>"

ARG USER_ID
ARG GROUP_ID

ENV HOME /sumokoin

# add user with specified (or default) user/group ids
ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -g ${GROUP_ID} sumokoin \
        && useradd -u ${USER_ID} -g sumokoin -s /bin/bash -m -d /sumokoin sumokoin

RUN echo "fs.file-max = 65535" > /etc/sysctl.conf

RUN set -x \
        && apt-get update && apt-get install -y --no-install-recommends \
                ca-certificates \
                git \
                sudo \
                wget \
                unzip \
                build-essential cmake libboost-all-dev libssl-dev pkg-config net-tools

RUN echo "sumokoin ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
    chmod 0440 /etc/sudoers.d/user
# On Debian/Ubuntu libgtest-dev only includes sources and headers. You must build the library binary manually. 
RUN apt-get install libgtest-dev && cd /usr/src/gtest && cmake . && make && mv libg* /usr/lib/
# Compile
RUN su - sumokoin -c "git clone https://github.com/sumoprojects/sumokoin.git && cd sumokoin && make"
RUN su - sumokoin -c "mv ~/sumokoin/build/release/bin ~/ && rm -rf ~/sumokoin && mkdir ~/.sumokoin"

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*


EXPOSE 19733/tcp 19734/tcp

WORKDIR /sumokoin
VOLUME /sumokoin/.sumokoin

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
