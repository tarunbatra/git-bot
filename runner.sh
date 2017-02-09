#!/usr/bin/env bash

# title        : runner.sh
# description  : Runs the script 'git-bot.sh'
# author       : tbking <tarun.batra00@gmail.com>
# usage        : bash runner.sh
# licence      : MIT

# Set the git-bot directory as base
BASE_DIR=$(dirname "$0")

# Get the project path
PROJECT_PATH=/path/to/project

# Run the git-bot script for the project and save the logs in ~/git-bot.log
bash $BASE_DIR/git-bot.sh $PROJECT_PATH >> ~/git-bot.log
