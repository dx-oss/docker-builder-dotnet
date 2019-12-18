ARG DOCKER_IMAGE=mcr.microsoft.com/dotnet/core/sdk:3.0
FROM csakshaug/of-watchdog-wrapper as  wrapper
FROM openfaas/of-watchdog:0.7.2 as watchdog
FROM dxcn/ssht:v0.0.1 as ssht
FROM ${DOCKER_IMAGE} as base
ARG TRACKMAN_VERSION=1.0.1
ARG SECRETHUB_VERSION=v0.31.0
ARG SECRETHUB_VERSION_PKG=secrethub-${SECRETHUB_VERSION}-linux-amd64.deb
ARG TINI_VERSION=v0.18.0
USER root
COPY --from=watchdog /fwatchdog /usr/bin/fwatchdog
COPY --from=wrapper /usr/bin/of-watchdog-wrapper /usr/bin/of-watchdog-wrapper
COPY --from=ssht /usr/bin/ssht /usr/bin/ssht
COPY init_ssh.sh /usr/local/bin
RUN curl -sSL https://github.com/cloud66-oss/trackman/releases/download/${TRACKMAN_VERSION}/linux_amd64_${TRACKMAN_VERSION} -o /usr/local/bin/trackman \
    && chmod +x /usr/local/bin/trackman \
    && curl -sSL https://github.com/secrethub/secrethub-cli/releases/download/${SECRETHUB_VERSION}/${SECRETHUB_VERSION_PKG} -o /tmp/${SECRETHUB_VERSION_PKG} \
    && dpkg -i /tmp/${SECRETHUB_VERSION_PKG} && rm /tmp/${SECRETHUB_VERSION_PKG} \
    && curl -Lfs -o /sbin/tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini \
    && chmod +x /sbin/tini \
    && apt-get update \
    && apt-get install -y unzip ssh git ca-certificates libcurl4 \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /root/.ssh \
    && chmod +x /usr/local/bin/init_ssh.sh
CMD ["dotnet", "--list-runtimes"]
