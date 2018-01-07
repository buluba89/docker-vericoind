FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    libssl-dev \
    libdb++-dev \
    libboost-all-dev \
    libqrencode-dev \
    libcurl4-gnutls-dev \
    libminizip-dev \
    libminiupnpc-dev \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/* 

RUN git clone --depth 1 https://github.com/vericoin/vericoin.git \
    && cd vericoin/src \
    && make -f makefile.unix \
    && strip vericoind \
    && mv vericoind /usr/local/bin \
    && cd / \
    && rm -rf vericoin

RUN mkdir -p /data 

ADD start.sh .

VOLUME ["/data"]

EXPOSE 58683

WORKDIR /data

HEALTHCHECK --retries=10 CMD /usr/local/bin/vericoind -conf=/data/vericoin.conf getinfo || exit 1

CMD ["/start.sh"]    
