#!/bin/bash
# Source: https://www.amsys.co.uk/2013/04/using-command-line-to-benchmark-disks/
echo "---------------------"
echo "Write Test Running. Please Wait..."
write=$(dd if=/dev/zero bs=2048k of=tstfile count=1024 2>&1 | grep sec | awk '{print $1 / 1024 / 1024 / $5, "MB/sec" }')
purge
echo ""
echo "Read Test Running. Please Wait..."
read=$(dd if=tstfile bs=2048k of=/dev/null count=1024 2>&1 | grep sec | awk '{print $1 / 1024 / 1024 / $5, "MB/sec" }')
echo ""
echo "Read Speed is: $read"
echo "Write Speed is: $write"
echo "---------------------"
echo "Cleaning up. Please Wait..."
purge
rm tstfile
echo ""
exit 0
