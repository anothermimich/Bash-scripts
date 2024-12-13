# Linux Caveats

## Rclone Google Drive Backup

As Google insist on not releasing a Drive client for linux, we have to search for alternative ways to use Google Drive. [Rclone](https://rclone.org/) has a `mount` command that is usefull for light use, this scripts complement it by keeping folders that are under heavy use locally for fast access. See the crontab section bellow for the `mount` command.

Before attempting to use this script you need to configure and read the documentation of [rclone](https://rclone.org/). I strongly suggest that you also try the scripts with a test folder or use `--dry-run`.

### Implementation

Some of the flags used don't work in older version of rclone, so update it

    sudo -v ; curl https://rclone.org/install.sh | sudo bash

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

Run the [rclone_pull_run.sh](/rclone-gdrive/rclone_pull_run.sh) on the terminal

    ./home/lu/Codes/Bash-scripts/rclone-gdrive/rclone_pull_run.sh

If the result is

- Sync done: You can proceed with the implementation.
- Sync failed: Ops, you need to troubleshoot. Check the log file at `$HOME/.config/rclone/rclone.log`.
- Sintax dir error: Check the [rclone_variables.sh](/rclone-gdrive/rclone_variables.sh) for errors. The `REMOTE_DIR` and `LOCAL_DIR` must match in order and ammount of entries.

After this you can create and `alias` for the [rclone_pull_run.sh](/rclone-gdrive/rclone_pull_run.sh) and [rclone_push_run.sh](/rclone-gdrive/rclone_push_run.sh) or edit `crontab` to execute them with the wanted time interval.

#### Crontab implementation

    crontab -e

Lines to be added

    */90 * * * * cd /home/lu/Codes/Bash-scripts/rclone-gdrive/ && ./rclone_pull_run.sh

If you want to mount a drive as well add the line bellow with updated locations, note that `--vfs-cache-mode full` don't work well in `FAT/exFAT` file systems.

    @reboot sleep 60 && rclone mount g_drive:/ /home/user/Drive/ --vfs-cache-mode full --vfs-cache-max-age=72h --dir-cache-time=72h --vfs-cache-max-size 1G

#### Alias implementation

### Chunk-size<sup>1</sup>

A 64M chunk-size is used for performance purposes. Google recommends as large a chunk size as possible. Rclone will use the following amount of RAM at run-time (8MB chunks by default; not high enough)...

RAM = (chunk-size \* num-transfers)

So our command will use larger chunk sizes (more RAM)...

RAM = 0.5 GB = (64MB \* 8 transfers)

For more details... https://github.com/ncw/rclone/issues/397

> <sup>1</sup> This explanation was written by [Markus Craig](https://gist.github.com/markuscraig/4addaf7fcfbc281808c3d708d1d35b6f)

#### Credits

Based on [markuscraig/sync_gdrive.py](https://gist.github.com/markuscraig/4addaf7fcfbc281808c3d708d1d35b6f) and on [Faris Khasawneh scripts](https://medium.com/@5a9awneh/setup-google-drive-on-linux-using-rclone-7400182cbf63)

## Ç config

In some `ABNT2` keyboards the `Ç` don't work out of the box. So you need to edit `/etc/environment`

    sudo vim /etc/environment

At the end of the archive add

    GTK_IM_MODULE=cedilla

Restart the computer

    systemctl reboot
