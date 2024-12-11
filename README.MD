# Usefull scripts for daily use on Linux

## Rclone Google Drive Backup

As Google insist on not releasing a Drive client for linux, we have to search for alternative ways to use Google Drive. [Rclone](https://rclone.org/) has a `mount` command that is usefull for light use, this scripts complement it by keeping folders that are under heavy use locally for fast access. See the crontab examples bellow for the `mount` command.

Before attempting to use read the documentation of [rclone](https://rclone.org/).

Make sure to use `--resync` on the first run. I strongly suggest that you also try the scripts with a test folder or use `--dry-run`.

## Crontab
