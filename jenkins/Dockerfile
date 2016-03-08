FROM jenkins:1.642.1

USER root
RUN apt-get update \
      && apt-get install -y sudo \
      && rm -rf /var/lib/apt/lists/*
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
ADD ./add_jenkins.sh /add_jenkins.sh
RUN chmod +x /add_jenkins.sh && chown jenkins:jenkins /add_jenkins.sh 

USER jenkins


COPY plugins.txt /var/jenkins_home/plugins.txt
RUN /usr/local/bin/plugins.sh /var/jenkins_home/plugins.txt

# SSH Keys & Credentials
COPY keys/credentials.xml /usr/share/jenkins/ref/credentials.xml
COPY keys/id_rsa /usr/share/jenkins/ref/.ssh/id_rsa
COPY keys/id_rsa.pub /usr/share/jenkins/ref/.ssh/id_rsa.pub

CMD /add_jenkins.sh && /bin/tini -- /usr/local/bin/jenkins.sh 