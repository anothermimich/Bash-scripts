# Usefull scripts for daily use on Linux

## Rclone Google Drive Backup

As Google insist on not releasing a Drive client for linux, we have to search for alternative ways to use Google Drive. [Rclone](https://rclone.org/) has a `mount` command that is usefull for light use, this scripts complement it by keeping folders that are under heavy use locally for fast access. See the crontab examples bellow for the `mount` command.

Before attempting to use read the documentation of [rclone](https://rclone.org/).

Make sure to use `--resync` on the first run. I strongly suggest that you also try the scripts with a test folder or use `--dry-run`.

Edit the [rclone_variables.sh](/rclone-gdrive/rclone_variables.sh) to refers to your envisioned folder or folder.

    REMOTE_DIR=('remote-name:/folder-name'  'remote-name:/folder-name')
    LOCAL_DIR=('folder-name' 'folder-name')

Make the scripts executable

    chmod +x ~/.local/bin/rclone_*.sh

### Crontab

Edit crontab

    crontab -e

Lines to be added

    */15 * * * * ~/.local/bin/rclone_timer.sh
    @reboot sleep 30 && ~/.local/bin/rclone_inotify.sh
    @reboot sleep 20 && rclone mount g_drive:/ /home/user/Drive/ --vfs-cache-mode full --vfs-cache-max-age=9999h --dir-cache-time=9999h --vfs-cache-max-size 5G
