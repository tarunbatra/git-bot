# git-bot
Automates committing and pushing of code

# Installation
```sh
git clone git@github.com:tarunbatra/git-bot
```

# Usage
* Crude way

  - Run
  `bash git-bot.sh /path/to/project`


* Automatic way

  - Add your project path in `runner.sh`

  - Run `bash runner.sh`

# cron
If you cloned this repo in your Projects directory, adding the following line to your crontab will run the git bot every weekday at 12 PM.

```sh
00 12 * * 1-5 bash ~/Projects/git-bot/runner.sh
```

# License
MIT
