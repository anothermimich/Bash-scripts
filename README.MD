# Usefull scripts for daily use on Linux

## Rclone Google Drive Backup

As Google insist on not releasing a Drive client for linux, we have to search for alternative ways to use Google Drive. [Rclone](https://rclone.org/) has a `mount` command that is usefull for light use, this scripts complement it by keeping folders that are under heavy use locally for fast access. See the crontab examples bellow for the `mount` command.

Before attempting to use read the documentation of [rclone](https://rclone.org/). I strongly suggest that you also try the scripts with a test folder or use `--dry-run`.

### Implementation

Edit the [rclone_variables.sh](/rclone-gdrive/rclone_variables.sh) to refers to your envisioned folder or folder.

    REMOTE_DIR=('remote-name:/folder-name'  'remote-name:/folder-name')
    LOCAL_DIR=('folder-name' 'folder-name')

Make the scripts executable

    chmod +x ~/.local/bin/rclone_*.sh

Run the [rclone_sync_first_run.sh](/rclone-gdrive/rclone_sync_first_run.sh) on the terminal

    ./rclone_sync_first_run.sh

If the result is

- Sync done: You can proceed with the implementation.
- Sync failed: Ops, you need to troubleshoot.
- Sintax dir error: Check the [rclone_variables.sh](/rclone-gdrive/rclone_variables.sh) for errors. The `REMOTE_DIR` and `LOCAL_DIR` must match in order and ammount of entries.

After the tests edit `crontab`

    crontab -e

Lines to be added

    */15 * * * * ~/.local/bin/rclone_timer.sh
    @reboot sleep 30 && ~/.local/bin/rclone_inotify.sh

If you want to mount a drive as well add the line bellow with updated locations

    @reboot sleep 20 && rclone mount g_drive:/ /home/user/Drive/ --vfs-cache-mode full --vfs-cache-max-age=9999h --dir-cache-time=9999h --vfs-cache-max-size 5G
