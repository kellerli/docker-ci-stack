#!/bin/bash
until $(curl --output /dev/null --silent --head --fail http://${GITLAB_ENV_GITLAB_HOST}:${GITLAB_ENV_GITLAB_PORT}); do
    printf '.'
    sleep 5
done
# get private token
authtoken=$(curl  http://${GITLAB_ENV_GITLAB_HOST}:${GITLAB_ENV_GITLAB_PORT}/api/v3/session --data 'login=root&password=rootroot' | sed -e 's/[{}]/''/g' | awk -v RS=',"' -F: '/^private_token/ {print $2}' | sed -e 's/["]/''/g')

 jenkins_exist=$(curl --header "PRIVATE-TOKEN: $authtoken"  -X GET  "http://${GITLAB_ENV_GITLAB_HOST}:${GITLAB_ENV_GITLAB_PORT}/api/v3/users?username=jenkins2")

if [ $jenkins_exist != "[]" ]; then
	printf "JENKINS ALREADY EXSIT!"
else
	printf "BEGIN JENKINS USER CREATION IN GITLAB!"
	# Add user
	jenkins=$(curl --header "PRIVATE-TOKEN: $authtoken" -H "Content-Type: application/json" -X POST -d '{"email":"jenkins@mail.com","password":"Jenkins123","username":"jenkins","name":"jenkins","confirm":"no"}' "http://${GITLAB_ENV_GITLAB_HOST}:${GITLAB_ENV_GITLAB_PORT}/api/v3/users")

	# Delete user
	#jenkins=$(curl --header "PRIVATE-TOKEN: $authtoken"  -X DELETE  "http://${GITLAB_ENV_GITLAB_HOST}:${GITLAB_ENV_GITLAB_PORT}/api/v3/users/34")

	# Get jenkins id
	jenkins_id=$(echo $jenkins | sed -e 's/[{}]/''/g' | awk -v RS=',"' -F: '/^id/ {print $2}' | sed -e 's/\[\|\]/''/g')

	# add ssh key to jenkins user
	jenkins_sshkey=$(curl --header "PRIVATE-TOKEN: $authtoken" -H "Content-Type: application/json" -X POST -d '{"title": "Jenkins ssh key", "key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCdJY0EY+PGY+A2BwXf3sIf6PasW8oJdPH/4poq3wnlZLmA7byDns9W4j7Bw4VdaKNUjQvLDwk7LQTEAIiLNDwxAmLTWoHpqCRwEXIXIODgG0cb3P/NM+OrBf5dxifDv4Nc+tIj1xd1Qp2Jk8nvAmEdJSwNZ9h5BfHRCIhM56mUkgUCuLYk5hxy1iQ+hlL45jj9c01I38HMRfKa9Tzyv8SMDDMEEIpoWSRoZWGi9cztxS3xL47nNsZRI/m7MGJxuSrifxRtY0BqB2vcuOZ/pp7qwswiItXLsm7pGHoZKuWnnc3J7kw7kjCJ/fW9BwHVFLqwUUU58zbftJ7BZpSRxf9V jenkins@28ef9c2b3714"}' "http://${GITLAB_ENV_GITLAB_HOST}:${GITLAB_ENV_GITLAB_PORT}/api/v3/users/$jenkins_id/keys")

fi