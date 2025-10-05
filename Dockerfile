FROM ubuntu:22.04

ARG samp_url=https://gta-multiplayer.cz/downloads/samp037svr_R2-2-1.tar.gz

ENV TZ="Europe/Budapest"
ENV APP_ROOT="/samp03"
ENV FS="${APP_ROOT}/filterscripts"
ENV GM="${APP_ROOT}/gamemodes"
ENV SF="${APP_ROOT}/scriptfiles"
ENV PL="${APP_ROOT}/plugins"

VOLUME $FS
VOLUME $GM
VOLUME $SF
VOLUME $PL

RUN dpkg --add-architecture i386 \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && apt update \
    && apt upgrade -yy \
    && apt install -yy --no-install-recommends \
       wget \
       apt-utils \
       ca-certificates \
       libstdc++6 \
       libc6:i386 \
       libncurses5:i386 \
       libstdc++6:i386 \
       procps \
       libtbb1:i386 \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /tmp/samp_download ${APP_ROOT}

WORKDIR /tmp/samp_download

RUN wget ${samp_url} -O server.tar.gz \
    && tar xf server.tar.gz \
    && rm server.tar.gz

RUN mv ./samp03/* ${APP_ROOT}/ \
    && rm -rf ./samp03 \
    && rm -rf ${APP_ROOT}/include ${APP_ROOT}/npcmodes/ ${APP_ROOT}/filterscripts/ ${APP_ROOT}/gamemodes/ \
    && chmod +x ${APP_ROOT}/samp03svr \
    && ln -sf /dev/stdout ${APP_ROOT}/server_log.txt

WORKDIR ${APP_ROOT}
EXPOSE 7777

COPY start.sh ./start.sh

RUN chmod +x ./start.sh

STOPSIGNAL SIGINT
ENTRYPOINT ["./start.sh"] 