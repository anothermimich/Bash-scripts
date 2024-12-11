# Bash Linux Scripts

## Rclone Google Drive Backup

As Google insist on not releasing a Drive client for linux, we have to search for alternative ways to use Google Drive. [Rclone](https://rclone.org/) has a `mount` command that is usefull for light use, this scripts complement it by keeping folders that are under heavy use locally for fast access. See the crontab examples bellow for the `mount` command.

Before attempting to use read the documentation of [rclone](https://rclone.org/). I strongly suggest that you also try the scripts with a test folder or use `--dry-run`.

### Implementation

Create the local folders and an `RCLONE_TEST` file inside of it

    mkdir folder-name
    cd folder-name/
    touch RCLONE_TEST

Edit the [rclone_variables.sh](/rclone-gdrive/rclone_variables.sh) to refers to your envisioned folder or folder.

    REMOTE_DIR=('remote-name:/folder-name'  'remote-name:/folder-name')
    LOCAL_DIR=('folder-name' 'folder-name')

Move the scripts to the wanted folder, I'm using `/home/lu/Codes/Bash-scripts/rclone-gdrive`

Make the scripts executable

    chmod +x /home/lu/Codes/Bash-scripts/rclone-gdrive/rclone_*.sh

Run the [rclone_sync_first_run.sh](/rclone-gdrive/rclone_sync_first_run.sh) on the terminal

    ./home/lu/Codes/Bash-scripts/rclone-gdrive/rclone_sync_first_run.sh

If the result is

- Sync done: You can proceed with the implementation.
- Sync failed: Ops, you need to troubleshoot.
- Sintax dir error: Check the [rclone_variables.sh](/rclone-gdrive/rclone_variables.sh) for errors. The `REMOTE_DIR` and `LOCAL_DIR` must match in order and ammount of entries.

After the tests edit `crontab`

    crontab -e

Lines to be added

    */15 * * * * /home/lu/Codes/Bash-scripts/rclone-gdrive/rclone_timer.sh
    @reboot sleep 30 && /home/lu/Codes/Bash-scripts/rclone-gdrive/rclone_inotify.sh

If you want to mount a drive as well add the line bellow with updated locations

    @reboot sleep 20 && rclone mount g_drive:/ /home/user/Drive/ --vfs-cache-mode full --vfs-cache-max-age=9999h --dir-cache-time=9999h --vfs-cache-max-size 5G

If you are having problems check the log file at `$HOME/.config/rclone/rclone.log`

### Chunk-size

A 64M chunk-size is used for performance purposes. Google recommends as large a chunk size as possible. Rclone will use the following amount of RAM at run-time (8MB chunks by default; not high enough)...

RAM = (chunk-size \* num-transfers)

So our command will use larger chunk sizes (more RAM)...

RAM = 0.5 GB = (64MB \* 8 transfers)

For more details... https://github.com/ncw/rclone/issues/397
This explanation was written by [Markus Craig](https://gist.github.com/markuscraig/4addaf7fcfbc281808c3d708d1d35b6f)

#### Credits

Made by Lu Immich a.k.a https://github.com/anothermimich

Based on [markuscraig/sync_gdrive.py](https://gist.github.com/markuscraig/4addaf7fcfbc281808c3d708d1d35b6f) and on [Faris Khasawneh scripts](https://medium.com/@5a9awneh/setup-google-drive-on-linux-using-rclone-7400182cbf63)
