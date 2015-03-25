#!/bin/env bash

ee() { echo "$@"; eval "$@"; }

ee "wget -q --no-check-certificate https://raw.githubusercontent.com/xxjapp/check_jar/master/check_jar.rb -O /tmp/c"
ee "install /tmp/c /usr/local/bin/check_jar"
