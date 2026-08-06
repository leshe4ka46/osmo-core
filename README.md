# osmocom core in docker containers

Запуск основных компонентов для опорной сети GERAN в докере

Настройки портов выполняются в файле `.env`

Порты, выносимые наружу хоста:

```
osmo-stp: * ${OSMOSTP_PORT} - SCTP - GSM A
osmo-mgw: ${EXTERNAL_OSMOMGW_IP} 16002..16501 - UDP - RTP
osmo-sgsn: ${EXTERNAL_OSMOSGSN_IP} ${OSMOSGSN_PORT} - UDP - GPRS-NS
```

## Локальная сборка

```
docker compose build
```

Для сборки без доступа к интернету можно добавить аргумент `GIT_URL` с своим зеркалом (`docker compose build --build-arg GIT_URL=https://git.some.tld/some-gitea-osmo-mirror`)

Необходимые рерозитории:

```
osmocom/libosmocore.git
osmocom/libosmo-netif.git
osmocom/libosmo-abis.git
osmocom/libosmo-sigtran.git
cellular-infrastructure/libsmpp34.git
cellular-infrastructure/libasn1c.git
cellular-infrastructure/osmo-mgw.git
cellular-infrastructure/osmo-hlr.git
cellular-infrastructure/osmo-msc.git
cellular-infrastructure/osmo-ggsn.git
cellular-infrastructure/osmo-sgsn.git
```

## HLR

Перед запуском можно переместить существующую `hlr.db` (`/var/lib/osmocom/hlr.db`) в `hlr/hlr.db`

HLR настроен автоматически регестрировать абонентов с MSISDN := IMSI

## Запуск

Необходимо поменять EXTERNAL_OSMOMGW_IP и EXTERNAL_OSMOSGSN_IP на внешний айпишник хоста, откуда будет происходить подключение BSC

```
cp .env.example .env
$EDITOR .env
```

```
docker compose down && docker compose up -d
```
