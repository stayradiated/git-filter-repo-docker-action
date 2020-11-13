#!/bin/bash
set -e

# Set up ssh known hosts and agent
ssh-keyscan -t rsa github.com >> /etc/ssh/ssh_known_hosts
eval `ssh-agent -s`
ssh-add - <<< "${SSH_PRIVATE_KEY}"

last_commit_log=$(git log -1 --pretty=format:"%s")
use_force=""
if [[ "${last_commit_log}" == *"[force]"* ]]; then
  use_force="--force"
fi

# split single parameter of this script into multiple params for the command
eval "set -- ${1}"
git-filter-repo "${@}"

git push "git@github.com:${TARGET_ORG}/${TARGET_REPO}.git" HEAD:"${TARGET_BRANCH}" "${use_force}"
