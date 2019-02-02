# nghttpx
(built from https://github.com/nghttp2/nghttp2)

[![](https://images.microbadger.com/badges/version/jetlabs/nghttpx.svg)](https://microbadger.com/images/jetlabs/nghttpx "Get your own version badge on microbadger.com") 
[![](https://images.microbadger.com/badges/image/jetlabs/nghttpx.svg)](https://microbadger.com/images/jetlabs/nghttpx "Get your own image badge on microbadger.com")

Docker based image for [nghttp2 HTTP/2](https://nghttp2.org/) C library client, server, proxy and h2load testing tool for HTTP/2 on Alpine Linux.

Run docker container and from there you can launch the nghttp client or the h2load load tool. See the documentation at https://nghttp2.org/documentation/.

## Client, Server and Proxy programs
### nghttp - client

nghttp is a HTTP/2 client. It can connect to the HTTP/2 server with prior knowledge, HTTP Upgrade and NPN/ALPN TLS extension.
    docker run -ti --name nghttp jetlabs/nghttpx sh

    / # nghttp -s -v -n https://google.com
    [  0.017] Connected
    The negotiated protocol: h2
    [  0.023] recv SETTINGS frame <length=18, flags=0x00, stream_id=0>
    ...

### nghttpd - server

nghttpd is a multi-threaded static web server.

By default, it uses SSL/TLS connection. Use --no-tls option to disable it.

nghttpd only accepts HTTP/2 connections via NPN/ALPN or direct HTTP/2 connections. No HTTP Upgrade is supported.

The -p option allows users to configure server push.

Just like nghttp, it has a verbose output mode for framing information. Here is sample output from nghttpd:

    $ docker run -it --rm  --name nghttpd -p 8080:8080 jetlabs/nghttpx nghttpd --no-tls -v 8080
    IPv4: listen 0.0.0.0:8080
    [id=1] [  5.655] send SETTINGS frame <length=6, flags=0x00, stream_id=0>
          (niv=1)
          [SETTINGS_MAX_CONCURRENT_STREAMS(0x03):100]
    [id=1] [  5.655] closed

### nghttpx - proxy

nghttpx is a multi-threaded reverse proxy for HTTP/2, and HTTP/1.1, and powers http://nghttp2.org and supports HTTP/2 server push.

We reworked nghttpx command-line interface, and as a result, there are several incompatibles from 1.8.0 or earlier. This is necessary to extend its capability, and secure the further feature enhancements in the future release. Please read Migration from nghttpx v1.8.0 or earlier to know how to migrate from earlier releases.

nghttpx implements important performance-oriented features in TLS, such as session IDs, session tickets (with automatic key rotation), OCSP stapling, dynamic record sizing, ALPN/NPN, forward secrecy and HTTP/2. nghttpx also offers the functionality to share session cache and ticket keys among multiple nghttpx instances via memcached.

nghttpx has 2 operation modes:

|Mode option                |Frontend                    |Backend                   |Note                    |
|---                                   |---                                 |---                               |---                         |
|default mode               |HTTP/2, HTTP/1.1     |HTTP/1.1, HTTP/2    |Reverse proxy   |
|``--http2-proxy``       |HTTP/2, HTTP/1.1     |HTTP/1.1, HTTP/2    |Forward proxy |

### Benchmarking tool

The h2load program is a benchmarking tool for HTTP/2. The UI of h2load is heavily inspired by weighttp (https://github.com/lighttpd/weighttp). The typical usage is as follows:

    $ h2load -n100000 -c100 -m100 https://localhost:8443/
    starting benchmark...
    spawning thread #0: 100 concurrent clients, 100000 total requests
    Protocol: TLSv1.2
    Cipher: ECDHE-RSA-AES128-GCM-SHA256
    Server Temp Key: ECDH P-256 256 bits
    progress: 10% done
    progress: 20% done
    ...

## License

The MIT License
