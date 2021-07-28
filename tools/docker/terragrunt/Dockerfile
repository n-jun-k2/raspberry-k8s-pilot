FROM ubuntu:20.10 AS base

ENV TERRAFORM_VERSION 1.0.0
ENV TERRAGRUNT_VERSION 0.31.0

RUN apt-get update && apt-get install --no-install-recommends -y \
  wget \
  unzip

WORKDIR /tmp

# install terraform..
RUN wget --no-check-certificate https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  cp terraform /usr/local/bin

# install terragunt
RUN wget --no-check-certificate https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 -O terragrunt && \
  cp terragrunt /usr/local/bin && \
  chmod a+x /usr/local/bin/terragrunt

FROM busybox:1.33 AS stage1

WORKDIR /terraform
COPY --from=base /usr/local/bin /usr/bin/
CMD [ ]
ENTRYPOINT [ "terragrunt" ]
