FROM ghcr.io/actions/actions-runner:latest

USER root

RUN apt-get update \
	&& apt-get install -y --no-install-recommends curl ca-certificates gnupg unzip \
	&& curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
	&& apt-get install -y --no-install-recommends nodejs \
	&& curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip \
	&& unzip -q /tmp/awscliv2.zip -d /tmp \
	&& /tmp/aws/install \
	&& rm -rf /tmp/awscliv2.zip /tmp/aws \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

USER runner
