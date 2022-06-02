FROM centos:centos7

ENV NGINX_VERSION 1.18.0
ENV UPLOAD_MODULE_VERSION 2.3.0

# Install tools
RUN yum -y update && yum -y install \
    gcc \
    gcc-c++ \
    autoconf \
    automake \
    make \
    zlib \
    zlib-devel \
    openssl* \
    pcre* \
    wget \
    lua-devel \
    unzip \
    vim \
    curl

# Compile
RUN useradd -M -s /sbin/nologin nginx
RUN CONFIG="\
        --prefix=/etc/nginx \
        --user=nginx \
        --group=nginx \
        --with-http_ssl_module \
        --sbin-path=/usr/sbin/nginx \
        --with-http_stub_status_module \
        --conf-path=/etc/nginx/nginx.conf \
        --modules-path=/usr/lib/nginx/modules \
        --error-log-path=/workspace/logs/error.log \
        --http-log-path=/workspace/logs/access.log \
        --add-module=/usr/src/nginx-upload-module-$UPLOAD_MODULE_VERSION \
    " \
    && curl -fSL https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz -o nginx.tar.gz \
    && mkdir -p /usr/src \
    && tar -zxC /usr/src -f nginx.tar.gz \
    && rm -rf nginx.tar.gz \
    && cd /usr/src/nginx-$NGINX_VERSION \
    && curl -fSL https://github.com/fdintino/nginx-upload-module/archive/$UPLOAD_MODULE_VERSION.tar.gz -o /usr/src/nginx_upload.tar.gz \
    && tar xvzf /usr/src/nginx_upload.tar.gz -C /usr/src/ \
    && rm -rf nginx_upload.tar.gz /usr/src/nginx_upload.tar.gz \
    && ./configure $CONFIG --with-debug \
    && make \
    && make install \
    && mkdir /etc/nginx/conf.d/ \
    && mkdir -p /usr/share/nginx/html/ \
    && ln -s ../../usr/lib/nginx/modules /etc/nginx/modules \
    && cp objs/nginx /usr/local/bin/

COPY nginx.conf /etc/nginx/nginx.conf
WORKDIR /workspace

EXPOSE 80

CMD ["nginx","-g","daemon off;"]
