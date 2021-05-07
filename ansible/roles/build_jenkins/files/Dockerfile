FROM jenkins/jenkins:2.277.4

LABEL maintainer="Robert Piecyk <robert_piecyk@outlook.com"

ARG JAVA_OPTS

# install docker
USER root

RUN apt-get -y update && \
    apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get -y install docker-ce docker-ce-cli containerd.io flake8

# install docker-compose
RUN curl -L "https://github.com/docker/compose/releases/download/$(curl https://github.com/docker/compose 2>/dev/null | \
    awk -F'tag\/|\">' '/releases\/tag/ { print $2 } ')/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

RUN groupadd -g 998 docker2 &&\
    usermod -aG docker jenkins &&\
    usermod -aG docker2 jenkins

USER jenkins

COPY configs/plugins_extra.txt /usr/share/jenkins/ref/plugins_extra.txt

ENV JENKINS_HOME /var/jenkins_home
ENV JAVA_OPTS "-Djenkins.install.runSetupWizard=false ${JAVA_OPTS:-}"

RUN xargs /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins_extra.txt
