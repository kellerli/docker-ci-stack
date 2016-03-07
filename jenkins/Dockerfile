FROM jenkins:1.642.1

USER root
RUN apt-get update \
      && apt-get install -y sudo \
      && rm -rf /var/lib/apt/lists/*
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
USER jenkins

COPY plugins.txt /var/jenkins_home/plugins.txt
RUN /usr/local/bin/plugins.sh /var/jenkins_home/plugins.txt

# SSH Keys & Credentials
COPY keys/credentials.xml /usr/share/jenkins/ref/credentials.xml
COPY keys/id_rsa /usr/share/jenkins/ref/.ssh/id_rsa
COPY keys/id_rsa.pub /usr/share/jenkins/ref/.ssh/id_rsa.pub