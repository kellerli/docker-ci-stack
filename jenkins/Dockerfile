FROM jenkins:1.642.1

USER root
RUN apt-get update \
      && apt-get install -y sudo \
      && rm -rf /var/lib/apt/lists/*
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
ADD ./add_jenkins.sh /usr/share/jenkins/create_jenkins_user_in_gitlab.sh
RUN chmod +x /usr/share/jenkins/create_jenkins_user_in_gitlab.sh \
	&& chown jenkins:jenkins /usr/share/jenkins/create_jenkins_user_in_gitlab.sh 

USER jenkins


COPY plugins.txt /var/jenkins_home/plugins.txt
RUN /usr/local/bin/plugins.sh /var/jenkins_home/plugins.txt

############################################
# Configure Jenkins
############################################
# Jenkins config
COPY config/config.xml /usr/share/jenkins/ref/config.xml

# Jenkins Settings, Maven
COPY config/hudson.tasks.Maven.xml /usr/share/jenkins/ref/hudson.tasks.Maven.xml
COPY config/maven-global-settings-files.xml /usr/share/jenkins/ref/maven-global-settings-files.xml

# SSH Keys & Credentials
COPY keys/credentials.xml /usr/share/jenkins/ref/credentials.xml
COPY keys/id_rsa /usr/share/jenkins/ref/.ssh/id_rsa
COPY keys/id_rsa.pub /usr/share/jenkins/ref/.ssh/id_rsa.pub

CMD /usr/share/jenkins/create_jenkins_user_in_gitlab.sh && /bin/tini -- /usr/local/bin/jenkins.sh 