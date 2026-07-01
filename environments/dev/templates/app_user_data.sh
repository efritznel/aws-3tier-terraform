#!/bin/bash
set -euxo pipefail

amazon-linux-extras install -y python3.8 || yum install -y python3

cd /opt
nohup python3 -m http.server 8080 --bind 0.0.0.0 > /var/log/app.log 2>&1 &
