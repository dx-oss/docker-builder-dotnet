ARG DOCKER_IMAGE=mcr.microsoft.com/dotnet/core/sdk:2.2
FROM gittools/gitversion:5.0.2-linux-ubuntu-16.04-netcoreapp2.2 as gitversion
FROM csakshaug/of-watchdog-wrapper as  wrapper
FROM openfaas/of-watchdog:0.7.7 as watchdog
FROM dxcn/ssht:0.0.2 as ssht
FROM dxdx/env-tester:v0.0.9 as env-tester
FROM migrate/migrate as migrate
FROM ${DOCKER_IMAGE} as base
ARG TRACKMAN_VERSION=1.0.4
ARG SECRETHUB_VERSION=v0.42.1
ARG SECRETHUB_VERSION_PKG=secrethub-${SECRETHUB_VERSION}-linux-amd64.deb
ARG TINI_VERSION=v0.18.0
ARG GITHUB_RELEASE=v0.8.1
ARG SEMVER_BASH=3.0.0
USER root
COPY --from=gitversion /app /gitversion
COPY --from=watchdog /fwatchdog /usr/bin/fwatchdog
COPY --from=wrapper /usr/bin/of-watchdog-wrapper /usr/bin/of-watchdog-wrapper
COPY --from=ssht /usr/bin/ssht /usr/bin/ssht
COPY --from=env-tester /usr/bin/env-tester /usr/bin/env-tester
COPY --from=migrate /usr/local/bin/migrate /usr/bin/migrate
# We only add bumpver.sh for 2.2 right now
ADD bumpver.sh /usr/local/bin/bumpver.sh
COPY init_ssh.sh /usr/local/bin
RUN apt-get update \
    && apt-get install -y unzip bzip2 ssh git ca-certificates libcurl3 \
    && curl -sSL https://github.com/cloud66-oss/trackman/releases/download/${TRACKMAN_VERSION}/linux_amd64_${TRACKMAN_VERSION} -o /usr/local/bin/trackman \
    && chmod +x /usr/local/bin/trackman \
    && curl -sSL https://github.com/secrethub/secrethub-cli/releases/download/${SECRETHUB_VERSION}/${SECRETHUB_VERSION_PKG} -o /tmp/${SECRETHUB_VERSION_PKG} \
    && dpkg -i /tmp/${SECRETHUB_VERSION_PKG} && rm /tmp/${SECRETHUB_VERSION_PKG} \   
    && curl -Lfs -o /sbin/tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini \
    && chmod +x /sbin/tini \
    && wget https://github.com/github-release/github-release/releases/download/${GITHUB_RELEASE}/linux-amd64-github-release.bz2 \
    && bzip2 -d linux-amd64-github-release.bz2 \
    && mv linux-amd64-github-release /sbin/github-release \
    && chmod +x /sbin/github-release \
    && curl -sSLO https://github.com/fsaintjacques/semver-tool/archive/${SEMVER_BASH}.zip \
    && unzip ${SEMVER_BASH}.zip \
    && mv semver-tool-${SEMVER_BASH}/src/semver /usr/bin/semver \
    && chmod +x /usr/bin/semver \
    && rm -rf semver-tool-${SEMVER_BASH} \
    && rm ${SEMVER_BASH}.zip \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /root/.ssh \
    && chmod +x /usr/local/bin/bumpver.sh \
    && chmod +x /usr/local/bin/init_ssh.sh
CMD ["dotnet", "--list-runtimes"]
