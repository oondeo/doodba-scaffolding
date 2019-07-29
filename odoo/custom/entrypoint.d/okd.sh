#!/bin/sh

if [ `id -u` -ge 10000 ]; then
    umask 0002
    if ! whoami &> /dev/null; then
        if [ -w /etc/passwd ]; then
            sed "/^${USER_NAME:-odoo}:/d" /etc/passwd > /tmp/.passwd
            echo "${USER_NAME:-odoo}:x:$(id -u):0:${USER_NAME:-odoo} user:${HOME}:/sbin/nologin" >> /tmp/.passwd
            cat /tmp/.passwd > /etc/passwd
            rm /tmp/.passwd
        fi
    fi
fi

