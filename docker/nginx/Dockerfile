FROM nginx:1.19.9

# Update system and install required software
RUN apt-get update && \
    apt-get install -y wget \
                       curl \
                       git \
                       build-essential \
                       autoconf \
                       libtool \
                       libpcre3 \
                       libpcre3-dev \
                       libssl-dev \
                       libgeoip-dev \
                       nginx-module-geoip
# # Install zlib 
RUN wget http://zlib.net/zlib-1.2.11.tar.gz && \
    tar -zxf zlib-1.2.11.tar.gz && \
    cd zlib-1.2.11 && \
    ./configure && \
    make && \
    make install && \
    cd ..

# Install C library for reading MaxMind DB files
# Resource: https://github.com/maxmind/libmaxminddb
RUN git clone --recursive https://github.com/maxmind/libmaxminddb.git &&\
    cd libmaxminddb &&\
    ./bootstrap &&\
    ./configure &&\
    make &&\
    make check &&\
    make install &&\
    echo /usr/local/lib  >> /etc/ld.so.conf.d/local.conf && \
    ldconfig

ARG MAX_MIND_KEY

# Download MaxMind GeoLite2 databases
RUN mkdir -p /usr/share/GeoIP/
COPY docker/nginx/GeoLite2-City_20210406.tar.gz ./
COPY docker/nginx/GeoLite2-Country_20210413.tar.gz ./

RUN tar -xf GeoLite2-City_20210406.tar.gz &&\
    ls . &&\
    mv GeoLite2-City_20210406/GeoLite2-City.mmdb /usr/share/GeoIP/ &&\
    tar -xf GeoLite2-Country_20210413.tar.gz &&\
    mv GeoLite2-Country_20210413/GeoLite2-Country.mmdb /usr/share/GeoIP/
    
# Download Nginx and the Nginx geoip2 module
ENV nginx_version 1.19.9
RUN curl http://nginx.org/download/nginx-$nginx_version.tar.gz | tar xz &&\
    git clone https://github.com/leev/ngx_http_geoip2_module.git

WORKDIR /nginx-$nginx_version

# Compile Nginx
RUN ./configure \
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --http-client-body-temp-path=/var/cache/nginx/client_temp \
    --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
    --user=nginx \
    --group=nginx \
    --with-http_ssl_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_sub_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_stub_status_module \
    --with-http_auth_request_module \
    --with-threads \
    --with-stream \
    --with-stream_ssl_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-file-aio \
    --with-cc-opt='-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2' \
    --with-ld-opt='-Wl,-z,relro -Wl,--as-needed' \
    --with-ipv6 \
    --with-zlib=../zlib-1.2.11 \
    --add-module=/ngx_http_geoip2_module && \
    make &&\
    make install

