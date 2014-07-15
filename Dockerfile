FROM ubuntu:14.04
MAINTAINER Simo Kinnunen

# Build from source.
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get -y install build-essential wget && \
    cd /tmp/ && \
    wget --progress=dot:mega \
      http://www.haproxy.org/download/1.5/src/haproxy-1.5.2.tar.gz && \
    tar xzf haproxy-* && \
    rm haproxy-*.tar.gz && \
    cd haproxy-* && \
    make TARGET=linux2628 && \
    make install && \
    rm -rf /tmp/haproxy-* && \
    useradd --system haproxy --shell /usr/sbin/nologin \
      --home-dir /nonexistent && \
    apt-get clean

# Expose a data volume for misc (e.g. caching) purposes, and the usual
# config folder for user configuration.
VOLUME ["/data", "/etc/haproxy"]

# Expose commonly used ports.
EXPOSE 80
EXPOSE 443

# Default command. Use shell so that Ctrl+C works.
CMD haproxy -f /etc/haproxy/haproxy.cfg
