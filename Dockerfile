FROM debian:stable-slim
LABEL maintainer="David Parrish <daveparrish@tutanota.com"

ARG LOCAL_USER_ID=9999
ARG LOCAL_GROUP_ID=9999

RUN apt-get update && apt-get install --no-install-recommends -yq \
      ca-certificates=* git=* python3-all-dev=* python3-pip=* sudo=* \
      python3-setuptools=* gettext-base=* \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && pip3 install wheel===0.34.2 \
  && pip3 install base58 \
  && git clone https://github.com/jgarzik/python-bitcoinrpc.git /tmp/python-bitcoinrpc \
  && groupadd -g "$LOCAL_GROUP_ID" user \
  && useradd -m -u "$LOCAL_USER_ID" -g "$LOCAL_GROUP_ID" user \
  && chown user: /home/user

COPY config.py /tmp/config.py
COPY entrypoint.sh /root/entrypoint.sh

WORKDIR /tmp/python-bitcoinrpc
RUN sed -i "s/'bitcoinrpc'/'bitcoinrpc','jsonrpc'/g" setup.py && python3 setup.py install

WORKDIR /home/user
RUN git clone https://github.com/luke-jr/eloipool.git \
  && ln -s /home/user/eloipool_data/config.py /home/user/eloipool/config.py
WORKDIR /home/user/eloipool

ENTRYPOINT [ "/root/entrypoint.sh" ]
