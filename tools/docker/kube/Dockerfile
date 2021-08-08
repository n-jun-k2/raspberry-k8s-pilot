FROM ubuntu:20.10 AS base

ENV KUBECTL_VERSION 1.21.3
ENV SKAFFOLD_VERSION 1.29.0
ENV K9S_VERSION 0.24.14

RUN apt-get update && apt-get install --no-install-recommends -y  \
    ca-certificates \
    curl

# install kubectl
RUN curl -LO "https://dl.k8s.io/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
  && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# install k9s
RUN curl -L https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_x86_64.tar.gz > k9s.tar.gz \
  && tar xvf k9s.tar.gz \
  && mv k9s /usr/local/bin \
  && chmod +x /usr/local/bin/k9s

# install skaffold
RUN curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64 \
  && chmod +x skaffold \
  && mv skaffold /usr/local/bin

FROM ubuntu:20.10 AS stage1

COPY --from=base /usr/local/bin /usr/bin
CMD []
ENTRYPOINT [ "k9s" ]
