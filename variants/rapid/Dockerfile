FROM ghcr.io/actions/actions-runner:latest

ARG POSTGRESQL_VERSION=17.11
ARG PLAYWRIGHT_VERSION=1.64.1
ARG NODE_MAJOR=24
ARG PNPM_VERSION=10.34.8
ARG PYTHON_VERSION=3.14
ARG UV_VERSION=0.13.7
ARG ACTIONLINT_VERSION=1.7.12
ARG SKAFFOLD_VERSION=2.16.1

USER root

ENV COREPACK_HOME=/usr/local/share/corepack

RUN apt-get update \
	&& apt-get install -y --no-install-recommends curl ca-certificates gnupg unzip sudo software-properties-common locales \
	&& echo "runner ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/runner-nopasswd \
	&& chmod 0440 /etc/sudoers.d/runner-nopasswd \
	&& locale-gen en_US.UTF-8 \
	\
	&& install -d /usr/share/postgresql-common/pgdg \
	&& curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc \
	&& . /etc/os-release \
	&& echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt ${VERSION_CODENAME}-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends "postgresql-17=${POSTGRESQL_VERSION}*" \
	\
	&& curl -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR}.x | bash - \
	&& apt-get install -y --no-install-recommends nodejs \
	&& corepack enable \
	&& corepack install -g pnpm@${PNPM_VERSION} \
	&& chmod -R a+rX "${COREPACK_HOME}" \
	\
	&& add-apt-repository -y ppa:deadsnakes/ppa \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends python${PYTHON_VERSION} python${PYTHON_VERSION}-venv \
	&& curl -LsSf https://astral.sh/uv/${UV_VERSION}/install.sh | env UV_INSTALL_DIR=/usr/local/bin sh \
	\
	&& curl -fsSL "https://github.com/rhysd/actionlint/releases/download/v${ACTIONLINT_VERSION}/actionlint_${ACTIONLINT_VERSION}_linux_amd64.tar.gz" -o /tmp/actionlint.tar.gz \
	&& tar -xzf /tmp/actionlint.tar.gz -C /usr/local/bin actionlint \
	&& rm -f /tmp/actionlint.tar.gz \
	\
	&& curl -fsSL "https://storage.googleapis.com/skaffold/releases/v${SKAFFOLD_VERSION}/skaffold-linux-amd64" -o /usr/local/bin/skaffold \
	&& chmod +x /usr/local/bin/skaffold \
	\
	&& curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip \
	&& unzip -q /tmp/awscliv2.zip -d /tmp \
	&& /tmp/aws/install \
	&& rm -rf /tmp/awscliv2.zip /tmp/aws \
	\
	&& npx --yes playwright@${PLAYWRIGHT_VERSION} install-deps chromium \
	\
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

ENV PATH="/usr/lib/postgresql/17/bin:${PATH}"

USER runner

RUN npx --yes playwright@${PLAYWRIGHT_VERSION} install chromium
