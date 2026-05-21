#!/bin/bash

set -euo pipefail

hostnOS() {

        echo " sudo hostname and OS info  "
         sudo hostname
         sudo cat /etc/os-release
        echo " ----------------- "

}
uptime() {

       echo " uptime info "
       sudo uptime -s
       echo " ------------- "

}

topdiskusage() {

        echo " top disk usage info "
        sudo du -sh * | sort -rh | head -5
        echo " ----------------------------"
}

memoryusage() {

        echo " memory usage info "
        sudo free -h
        echo " ------------------ "
}

topcpuUsage() {

         echo " top CPU usage "
         sudo ps -eo pid,ppid,cmd,%cpu,%mem --sort=-%cpu | head -n 5

}

mainfun() {

    hostnOS
    uptime
    topdiskusage
    memoryusage
    topcpuUsage
}

mainfun
