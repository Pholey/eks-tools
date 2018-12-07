FROM alpine AS base

ARG KUBECTL_VERSION=v1.13.0
ARG HELM_VERSION=2.11.0
ARG aws-iam-authenticator

RUN apk add --update --no-cache curl ca-certificates openssl

WORKDIR /work
RUN curl -LO https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz
RUN tar xvf helm-v${HELM_VERSION}-linux-amd64.tar.gz

WORKDIR /prepared
RUN cp /work/linux-amd64/tiller .
RUN cp /work/linux-amd64/helm .
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl
RUN curl -LO https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/linux/amd64/heptio-authenticator-aws
RUN chmod +x *
RUN mv heptio-authenticator-aws aws-iam-authenticator

FROM alpine
RUN apk add --update --no-cache ca-certificates openssl git
COPY --from=base /prepared /usr/bin
