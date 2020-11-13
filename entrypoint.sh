#!/bin/bash
set -e

# Set up ssh known hosts and agent
ssh-keyscan -t rsa github.com >> /etc/ssh/ssh_known_hosts
eval `ssh-agent -s`
ssh-add - <<< "${SSH_PRIVATE_KEY}"

last_commit_log=$(git log -1 --pretty=format:"%s")

# split single parameter of this script into multiple params for the command
eval "set -- ${1}"
git-filter-repo "${@}"

git_host="git@github.com:${TARGET_ORG}/${TARGET_REPO}.git"
git_branch="HEAD:${TARGET_BRANCH}"

if [[ "${last_commit_log}" == *"[force]"* ]]
then
  git push --force "${git_host}" "${git_branch}"
else
  git push "${git_host}" "${git_branch}"
fi
