#!/bin/bash -e

report_error() {
    read -r -d '|' MESSAGE <<EOF
Unfortunately, suyu seems to have crashed.
We kindly ask you to submit a bug report to <a href="https://gitlab.com/suyu-emu/linux-package-sources/flatpak/-/issues">https://gitlab.com/suyu-emu/linux-package-sources/flatpak/-/issues</a>.

When submitting a bug report, please attach your <b>system information</b> and the <b>yuzu log file</b>.
You seem to be using ${XDG_SESSION_DESKTOP} ${DESKTOP_SESSION} (${XDG_SESSION_TYPE}):
To obtain suyu log files, please see <a href="https://gitlab.com/suyu-emu/suyu/-/wikis/FAQ#how-do-i-upload-my-log-file">this guide</a>.
To obtain your system information, please install <tt>inxi</tt> and run <tt>inxi -v3</tt>. |
EOF
    zenity --warning --no-wrap --title "That's awkward ..." --text "$MESSAGE"
}

# Discord RPC
for i in {0..9}; do
    test -S "$XDG_RUNTIME_DIR"/"discord-ipc-$i" || ln -sf {app/com.discordapp.Discord,"$XDG_RUNTIME_DIR"}/"discord-ipc-$i";
done


if ! prlimit --nofile=8192 suyu "$@"; then
    report_error
fi
