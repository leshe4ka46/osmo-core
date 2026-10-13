FROM ubuntu:24.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    bash \
    iputils-ping \
    make \
    build-essential \
    autoconf \
    git \
    python3 \
    automake \
    libtool \
    m4 \
    liburing-dev \
    libusb-1.0-0-dev \
    libfftw3-dev \
    libbctoolbox-dev \
    libxml2 \
    libc-ares-dev \
    libpcsclite-dev \
    libtalloc-dev \
    libortp-dev \
    libsctp-dev \
    libmnl-dev \
    libdbi-dev \
    libsqlite3-dev \
    libc-ares-dev \
    libgnutls28-dev \
    && rm -rf /var/lib/apt/lists/*

ARG GIT_URL=https://gitea.osmocom.org
ENV OSMO_SRC=/tmp/osmo
ENV OSMO_BUILD=/tmp/build


RUN mkdir -p "${OSMO_SRC}"
RUN mkdir -p "${OSMO_BUILD}"
RUN git config --global --add safe.directory "*"


ARG LIBOSMOCORE_COMMIT=950430e829
RUN git clone "${GIT_URL}/osmocom/libosmocore.git" "${OSMO_SRC}/libosmocore" && \
    cd "${OSMO_SRC}/libosmocore" \
    git checkout "${LIBOSMOCORE_COMMIT}" && \
    autoupdate && \
    autoreconf -i && \
    ./configure && \
    make -j"$(nproc)" && \
    make install DESTDIR=${OSMO_BUILD} && \
    make install && \
    ldconfig -i

ARG LIBOSMO_NETIF_COMMIT=4990f9dfe3
RUN git clone "${GIT_URL}/osmocom/libosmo-netif.git" "${OSMO_SRC}/libosmo-netif" && \
    cd "${OSMO_SRC}/libosmo-netif" && \
    git checkout "${LIBOSMO_NETIF_COMMIT}" && \
    autoupdate && \
    autoreconf -i && \
    ./configure && \
    make -j"$(nproc)" && \
    make install DESTDIR=${OSMO_BUILD} && \
    make install && \
    ldconfig -i

ARG LIBOSMO_ABIS_COMMIT=898f6d8b20
RUN git clone "${GIT_URL}/osmocom/libosmo-abis.git" "${OSMO_SRC}/libosmo-abis" && \
    cd "${OSMO_SRC}/libosmo-abis" && \
    git checkout "${LIBOSMO_ABIS_COMMIT}" && \
    autoupdate && \
    autoreconf -i && \
    ./configure --disable-dahdi && \
    make -j"$(nproc)" && \
    make install DESTDIR=${OSMO_BUILD} && \
    make install && \
    ldconfig -i

ARG LIBOSMO_SIGTRAN_COMMIT=ccf552593c
RUN git clone "${GIT_URL}/osmocom/libosmo-sigtran.git" "${OSMO_SRC}/libosmo-sigtran" && \
    cd "${OSMO_SRC}/libosmo-sigtran" && \
    git checkout "${LIBOSMO_SIGTRAN_COMMIT}" && \
    autoupdate && \
    autoreconf -i && \
    ./configure && \
    make -j"$(nproc)" && \
    make install DESTDIR=${OSMO_BUILD} && \
    make install && \
    ldconfig -i

ARG LIBSMPP34_COMMIT=d6ac32fde9
RUN git clone "${GIT_URL}/cellular-infrastructure/libsmpp34.git" "${OSMO_SRC}/libsmpp34" && \
    cd "${OSMO_SRC}/libsmpp34" && \
    git checkout "${LIBSMPP34_COMMIT}" && \
    autoupdate && \
    autoreconf -i && \
    ./configure && \
    make -j"$(nproc)" && \
    make install DESTDIR=${OSMO_BUILD} && \
    make install && \
    ldconfig -i

ARG LIBASN1C_COMMIT=984b3db58c
RUN git clone "${GIT_URL}/cellular-infrastructure/libasn1c.git" "${OSMO_SRC}/libasn1c" && \
    cd "${OSMO_SRC}/libasn1c" && \
    git checkout "${LIBASN1C_COMMIT}" && \
    autoupdate && \
    autoreconf -i && \
    ./configure && \
    make -j"$(nproc)" && \
    make install DESTDIR=${OSMO_BUILD} && \
    make install && \
    ldconfig -i

ARG OSMO_MGW_COMMIT=8afbaddc53
RUN git clone "${GIT_URL}/cellular-infrastructure/osmo-mgw.git" "${OSMO_SRC}/osmo-mgw" && \
    cd "${OSMO_SRC}/osmo-mgw" && \
    git checkout "${OSMO_MGW_COMMIT}" && \
    autoupdate && \
    autoreconf -i && \
    ./configure && \
    make -j"$(nproc)" && \
    make install DESTDIR=${OSMO_BUILD} && \
    make install && \
    ldconfig -i


ARG OSMO_HLR_COMMIT=8562db3a90
RUN git clone "${GIT_URL}/cellular-infrastructure/osmo-hlr.git" "${OSMO_SRC}/osmo-hlr" && \
    cd "${OSMO_SRC}/osmo-hlr" && \
    git checkout "${OSMO_HLR_COMMIT}" && \
    autoupdate && \
    autoreconf -i && \
    ./configure && \
    make -j"$(nproc)" && \
    make install DESTDIR=${OSMO_BUILD} && \
    make install && \
    ldconfig -i

ARG OSMO_MSC_COMMIT=97eeaff2ff
RUN git clone "${GIT_URL}/cellular-infrastructure/osmo-msc.git" "${OSMO_SRC}/osmo-msc" && \
    cd "${OSMO_SRC}/osmo-msc" && \
    git checkout "${OSMO_MSC_COMMIT}" && \
    autoupdate && \
    autoreconf -i && \
    ./configure --enable-smpp && \
    make -j"$(nproc)" && \
    make install DESTDIR=${OSMO_BUILD} && \
    make install && \
    ldconfig -i

ARG OSMO_GGSN_COMMIT=20168d98fc
RUN git clone "${GIT_URL}/cellular-infrastructure/osmo-ggsn.git" "${OSMO_SRC}/osmo-ggsn" && \
    cd "${OSMO_SRC}/osmo-ggsn" && \
    git checkout "${OSMO_GGSN_COMMIT}" && \
    autoupdate && \
    autoreconf -i && \
    ./configure && \
    make -j"$(nproc)" && \
    make install DESTDIR=${OSMO_BUILD} && \
    make install && \
    ldconfig -i

ARG OSMO_SGSN_COMMIT=8972707b23
RUN git clone "${GIT_URL}/cellular-infrastructure/osmo-sgsn.git" "${OSMO_SRC}/osmo-sgsn" && \
    cd "${OSMO_SRC}/osmo-sgsn" && \
    git checkout "${OSMO_SGSN_COMMIT}" && \
    autoupdate && \
    autoreconf -i && \
    ./configure && \
    make -j"$(nproc)" && \
    make install DESTDIR=${OSMO_BUILD} && \
    make install && \
    ldconfig -i



FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# for i in /usr/local/bin/*; do ldd $i; done | grep "found" | cut -d ' ' -f1 | cut -d '      ' -f 2 | sort | uniq
RUN apt-get update && apt-get install -y --no-install-recommends gettext-base inetutils-telnet iproute2 iputils-ping \
    libtalloc2 \
    libc-ares2 \
    libmnl0 \
    libortp16 \
    libsctp1 \
    libsqlite3-0 \
    liburing2 \
    ca-certificates \
    iptables \
    && rm -rf /var/lib/apt/lists/*

COPY ./scripts /scripts
COPY --from=builder /tmp/build/ /

RUN ldconfig
