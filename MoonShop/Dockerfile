FROM ubuntu

WORKDIR /install

# This is giantic unoptimized docker image for dev

RUN apt update && apt install -y build-essential libreadline-dev unzip curl wget openssl libssl-dev m4 libreadline-dev

RUN curl -R -O http://www.lua.org/ftp/lua-5.1.5.tar.gz && \
tar -zxf lua-5.1.5.tar.gz && \
cd lua-5.1.5 && \
make linux test && \
make install && \
cd -

RUN wget https://luarocks.org/releases/luarocks-3.8.0.tar.gz && \
tar zxpf luarocks-3.8.0.tar.gz && \
cd luarocks-3.8.0 && \
./configure && \
make && \
make install


RUN wget https://sqlite.org/2023/sqlite-autoconf-3420000.tar.gz && \
tar -zxf sqlite-autoconf-3420000.tar.gz && \
cd sqlite-autoconf-3420000 && ./configure && \
make && make install

RUN echo "deb http://openresty.org/package/ubuntu focal main" > /etc/apt/sources.list.d/openresty.list && \
wget -O - https://openresty.org/package/pubkey.gpg | apt-key add -

RUN apt-get update & \
apt-get -y install --allow-unauthenticated openresty

RUN luarocks --lua-version=5.1 install busted && \
	luarocks --lua-version=5.1 install lpeg && \
	luarocks --lua-version=5.1 install moonscript && \
	luarocks --lua-version=5.1 install https://luarocks.org/manifests/gvvaughan/luaposix-33.4.0-1.rockspec && \
	luarocks --lua-version=5.1 install http && \
    luarocks --lua-version=5.1 install lapis && \
	luarocks --lua-version=5.1 install lsqlite3

RUN luarocks --lua-version=5.1 path > /root/.bashrc
RUN echo 'export PATH="/usr/local/bin:$PATH"' >> /root/.bashrc
WORKDIR /app
COPY ./shop /app
RUN useradd web && chown -R web /app 
USER web

