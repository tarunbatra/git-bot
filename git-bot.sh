#!/usr/bin/env bash

# title        : git-bot.sh
# description  : Automates committing and pushing of code
# author       : tbking <tarun.batra00@gmail.com>
# usage        : bash mkscript.sh
# licence      : MIT

# Continue the process if success
proceedIfSuccess() {
  if [ 0 -eq $? ]; then
    echo "SUCCESS: $1"
  else
    echo "FAILURE: $1"
    exit 1
  fi;
}

# Log the status
logStatus() {
  if [ 0 -eq $? ]; then
    echo "SUCCESS: $1"
  else
    echo "FAILURE: $1"
  fi;
}

# Returns current date
getDate() {
  date +%d/%m/%Y
}

# Returns current time
getTime() {
  date +"%T"
}

# Asserts the existance of Git
assertGit() {
  echo "checking git..."
  git --version
  proceedIfSuccess "checking git"
}

## cd to project repo
changeToProjectRepo() {
  cd $LOCAL_REPO
  if [ -z "$LOCAL_REPO" ]; then
    cd $1
  else
    cd $LOCAL_REPO
  fi
}

# Get current git branch name
getCurrentGitBranch() {
  echo `git branch | sed -n -e 's/^\* \(.*\)/\1/p'`
}

# Check for uncommitted changes in the repo
checkForUncommitedChanges() {
  echo "checking for uncommited changes..." >&2

  # Checks the output of git diff to determine if there's any uncommitted change
  if (git diff --exit-code &>/dev/null && git diff --cached --exit-code &> /dev/null); then
    echo "no uncommited changes found" >&2
    echo 0
  else
    echo "uncommited changes found" >&2
    echo 1
  fi
}

# Check for local commits in the repo
checkForLocalCommits() {
  echo "checking for local commits..." >&2

  # Checks if git status shows that the current branch is 'ahead' of remote one
  RESULT=`git status -sb`
  if grep -q "ahead" <<<$RESULT; then
    echo "local commits found" >&2
    echo 1
  else
    echo "no local commits found" >&2
    echo 0
  fi
}

# Generate a new branch name for today
generateNewBranch() {
  echo "automatic-branch-`getDate`"
}

# Generate a new commit message for now
generateCommitMsg() {
  echo "Automatic interim commit - `getDate` `getTime`"
}

# Switches to provided branch name
switchToBranch() {
  echo "switching to branch: $1..."

  # If branch doesn't exist, create one
  git checkout "$1" &>/dev/null || git checkout -b "$1" &>/dev/null
  logStatus "switching to branch: $1"
}

# Commits code
commitCode() {
  echo "committing code..."
  git commit -a -m "$1" --no-gpg-sign
  logStatus "committing code"
}

# Pushes code
pushCode() {
  echo "pushing code..."
  git push origin $GIT_NEW_BRANCH -f
  logStatus "pushing code"
}

# Announce the running of the script
echo "=-=-=-=-=  git-bot `getDate` `getTime` =-=-=-=-="

# Make sure git exists on the system
assertGit
# Take the first argument as path to
changeToProjectRepo $1
# Get the current git branch before script runs
GIT_BRANCH=`getCurrentGitBranch`
# Stores 1 for uncommitted changes and 0 for vice versa
UNCOMMITTED_CHANGES=`checkForUncommitedChanges`

if [ 1 -eq "$UNCOMMITTED_CHANGES" ]; then
  # Generate new branch name
  GIT_NEW_BRANCH=`generateNewBranch`
  # Switch to new branch
  switchToBranch "$GIT_NEW_BRANCH"
  # Generate commit message
  GIT_COMMIT_MSG=`generateCommitMsg`
  # Commit the uncommitted code
  commitCode "$GIT_COMMIT_MSG"
  # Push the new branch
  pushCode
  # Switch back to previous branch
  switchToBranch "$GIT_BRANCH"
  # Exit the script successfully
  exit 0
fi

# Stores 1 for uncommitted changes and 0 for vice versa
LOCAL_COMMITS=`checkForLocalCommits $GIT_BRANCH`

if [ 1 -eq "$LOCAL_COMMITS" ]; then
  # Generate new branch name
  GIT_NEW_BRANCH=`generateNewBranch`
  # Switch to new branch
  switchToBranch "$GIT_NEW_BRANCH"
  # Push the new branch
  pushCode
  # Switch back to previous branch
  switchToBranch "$GIT_BRANCH"
  # Exit the script successfully
  exit 0
fi

echo "nothing to do here. good dev!"
