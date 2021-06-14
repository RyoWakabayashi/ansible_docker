FROM centos:centos7

ARG HTTP_PROXY
ARG HTTPS_PROXY

RUN echo proxy=$HTTP_PROXY >> /etc/yum.conf

ENV http_proxy $HTTP_PROXY
ENV https_proxy $HTTPS_PROXY

RUN yum -y install openssh-clients
RUN yum install epel-release -y && \
    yum install ansible -y && \
    yum install rsync -y && \
    yum clean all && \
    curl -sL https://bootstrap.pypa.io/pip/2.7/get-pip.py | python && \
    pip install pywinrm

RUN mkdir /playbooks
RUN mkdir -p /root/.ssh

ENV LANG ja_JP.UTF-8

COPY ssh-config /root/.ssh/config