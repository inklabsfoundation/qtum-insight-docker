FROM qtum/qtum
ENV DEBIAN_FRONTEND noninteractive
ADD conf/sources.list /etc/apt/sources.list
RUN mkdir /work
WORKDIR /work
RUN apt-get update
RUN apt-get install -y g++ gcc bzip2 build-essential git python-software-properties
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash
RUN apt-get update
RUN apt-get install -y nodejs 
RUN apt-get install -y libtool pkg-config autoconf automake uuid-dev 
RUN apt-get install -y libzmq3-dev
RUN npm config set registry https://registry.npm.taobao.org
RUN npm install qtumcore-node
RUN node_modules/qtumcore-node/bin/qtumcore-node create qtum-api
WORKDIR qtum-api
RUN apt-get install -y gettext
RUN ../node_modules/qtumcore-node/bin/qtumcore-node install qtum-insight-api
VOLUME /work/qtum-api/data
ADD conf/qtumcore-node.json qtumcore-node.json
ADD conf/qtum.conf data/qtum.conf
CMD envsubst < /work/qtum-api/qtumcore-node.json > /work/qtum-api/qtumcore-node.json && /work/node_modules/qtumcore-node/bin/qtumcore-node start
