#!/usr/bin/env bash
set -e -x

GIT_URL=https://gitea.osmocom.org/

PWD=/tmp
OSMO_SRC=${PWD}/osmo
CHROOT_PATH=${PWD}/chroot

mkdir -p ${OSMO_SRC}
mkdir -p ${CHROOT_PATH}

declare -A urls=(
  [libosmocore]="osmocom/libosmocore.git"
  [libosmo-netif]="osmocom/libosmo-netif.git"
  [libosmo-abis]="osmocom/libosmo-abis.git"
  [libosmo-sigtran]="osmocom/libosmo-sigtran.git"
  [libsmpp34]="cellular-infrastructure/libsmpp34.git"
  [libasn1c]="cellular-infrastructure/libasn1c.git"
  [osmo-mgw]="cellular-infrastructure/osmo-mgw.git"
  [osmo-hlr]="cellular-infrastructure/osmo-hlr.git"
  [osmo-msc]="cellular-infrastructure/osmo-msc.git"
  [osmo-ggsn]="cellular-infrastructure/osmo-ggsn.git"
  [osmo-sgsn]="cellular-infrastructure/osmo-sgsn.git"
)

declare -A commits=(
  [libosmocore]="950430e829"
  [libosmo-netif]="4990f9dfe3"
  [libosmo-abis]="898f6d8b20"
  [libosmo-sigtran]="ccf552593c"
  [libsmpp34]="d6ac32fde9"
  [libasn1c]="984b3db58c"
  [osmo-mgw]="8afbaddc53"
  [osmo-hlr]="8562db3a90"
  [osmo-msc]="97eeaff2ff"
  [osmo-ggsn]="20168d98fc"
  [osmo-sgsn]="8972707b23"
)

declare -A args=(
  [libosmocore]=""
  [libosmo-netif]=""
  [libosmo-abis]="--disable-dahdi"
  [libosmo-sigtran]=""
  [libsmpp34]=""
  [libasn1c]=""
  [osmo-mgw]=""
  [osmo-hlr]=""
  [osmo-msc]="--enable-smpp"
  [osmo-ggsn]=""
  [osmo-sgsn]=""
)


build_order=(
  libosmocore
  libosmo-netif
  libosmo-abis
  libosmo-sigtran
  libsmpp34
  libasn1c
  osmo-mgw
  osmo-hlr
  osmo-msc
  osmo-ggsn
  osmo-sgsn
)

git config --global --add safe.directory "*"

for repo in "${build_order[@]}"; do
  echo "Building $repo ..."
  git clone ${GIT_URL}${urls[${repo}]} ${OSMO_SRC}/$repo
  cd "${OSMO_SRC}/${repo}"
  git checkout ${commits[${repo}]} 
  echo "99" > .tarball-version 
  autoupdate
  autoreconf -i
  ./configure ${args[$repo]} || cat config.log || false
  make -j $(nproc)
  make install
  ldconfig -i
  cd "${OSMO_SRC}"
done

