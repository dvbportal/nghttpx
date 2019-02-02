FROM alpine:edge
MAINTAINER hs <dvbportal@gmail.com
RUN \
 NGHTTP2_VERSION='1.36.0' \
 BUILD_DEPS='wget libc-dev gcc g++ make' \
 RUN_DEPS='ca-certificates libstdc++ openssl-dev libev-dev zlib-dev jansson-dev libxml2-dev c-ares-dev openssl python' \
 && apk --no-cache add $BUILD_DEPS $RUN_DEPS \
 && cd /tmp \
 && wget -qO- "https://github.com/tatsuhiro-t/nghttp2/releases/download/v${NGHTTP2_VERSION}/nghttp2-${NGHTTP2_VERSION}.tar.gz" | tar -xz \
 && cd /tmp/nghttp2-$NGHTTP2_VERSION \
 && ./configure \
 && make \
 && make install \
 && apk del $BUILD_DEPS \
 && rm -rf /tmp/* 
