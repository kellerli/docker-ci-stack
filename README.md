# docker-ci-stack
This repository helps you to build a docker continuous integration stack.. using jenkins, sonar, nexus, gitlab and docker registry

# using volumes
mkdir -p /var/docker/volumes/postgresql
chcon -Rt svirt_sandbox_file_t /var/docker/volumes/postgresql
