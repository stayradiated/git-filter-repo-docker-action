#!/bin/bash
set -e

# Set up ssh known hosts and agent
ssh-keyscan -t rsa github.com >> /etc/ssh/ssh_known_hosts
eval `ssh-agent -s`
ssh-add - <<< "${SSH_PRIVATE_KEY}"

# split single parameter of this script into multiple params for the command
eval "set -- ${1}"
git-filter-repo "${@}"

use_force=""
if [[ "${LAST_COMMIT_MESSAGE}" == *"[force]"* ]]
then
  use_force="--force"
fi

git push "${use_force}" "git@github.com:${TARGET_ORG}/${TARGET_REPO}.git" HEAD:"${TARGET_BRANCH}"
