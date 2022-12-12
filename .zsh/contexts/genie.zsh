# for genie (run systemctl as root)
# wsl$B$+$I$&$+(B
if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
    echo "in wsl"
    #genie(systemd$B$r(Bwsl$B$G;HMQ$G$-$k$h$&$K$9$k(B)$B$r5/F0$9$k$+$I$&$+(B
    if [ "`ps -eo pid,cmd | grep systemd | grep -v grep | sort -n -k 1 | awk 'NR==1 { print $1 }'`" != "1" ]; then
      echo "genie is running..."
      genie -s
    fi
fi


