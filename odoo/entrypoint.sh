#!/bin/bash

set -e

#Openshift fix
if [ `id -u` -ge 10000 ]; then
#install nss_wrapper gettext
# export USER_ID=$(id -u)
# export GROUP_ID=$(id -g)
# envsubst < ${HOME}/passwd.template > /tmp/passwd
# export LD_PRELOAD=libnss_wrapper.so
# export NSS_WRAPPER_PASSWD=/tmp/passwd
# export NSS_WRAPPER_GROUP=/etc/group
    if ! whoami &> /dev/null; then
        if [ -w /etc/passwd ]; then
            sed "/^${USER_NAME:-odoo}:/d" /etc/passwd > /tmp/.passwd
            echo "${USER_NAME:-odoo}:x:$(id -u):0:${USER_NAME:-odoo} user:${HOME}:/sbin/nologin" >> /tmp/.passwd
            cat /tmp/.passwd > /etc/passwd
            rm /tmp/.passwd
        fi
    fi
fi

# set the postgres database host, port, user and password according to the environment
# and pass them as arguments to the odoo process if not present in the config file
: ${HOST:=${PGHOST:=${DB_PORT_5432_TCP_ADDR:=${DB_SERVICE_HOST:='db'}}}}
: ${PORT:=${PGPORT:=${DB_PORT_5432_TCP_PORT:=${DB_SERVICE_HOST:=5432}}}}
: ${USER:=${PGUSER:=${DB_ENV_POSTGRES_USER:=${POSTGRESQL_USER:=${POSTGRES_USER:='odoo'}}}}}
: ${PASSWORD:=${PGPASSWORD:=${DB_ENV_POSTGRES_PASSWORD:=${POSTGRESSQL_PASSWORD:=${POSTGRES_PASSWORD:='odoo'}}}}}

DB_ARGS=()
function check_config() {
    param="$1"
    value="$2"
    if ! grep -q -E "^\s*\b${param}\b\s*=" "$ODOO_RC" ; then
        DB_ARGS+=("--${param}")
        DB_ARGS+=("${value}")
   fi;
}
check_config "db_host" "$HOST"
check_config "db_port" "$PORT"
check_config "db_user" "$USER"
check_config "db_password" "$PASSWORD"

export PGHOST=$HOST
export PGPORT=$PORT
export PGUSER=$USER
export PGPASSWORD=$PASSWORD
#PGDATABASE

addons=$(ls -1d /mnt/extra-addons/* /opt/addons/* | tr '\n' ',' | sed s/,$//)

EXTRA_ARGS=()
env -0 | while IFS='=' read -r -d '' n v; do
    if [ "${n:0:8}" == "ODOO_" ]
    then
        n=${n:8}
        n=${n,,}
        n=${n/_/-}
        EXTRA_ARGS+=("--$n")
        EXTRA_ARGS+=("$v")
        if [ "$n" == "addons-path" ]
        then
            addons=""
        fi
    fi
done

if [ "$addons" != "" ]
then
    EXTRA_ARGS+=("--addons-path")
    EXTRA_ARGS+=("/opt/odoo/auto/addons,$addons")
fi
case "$1" in
    -- | odoo)
        shift
        if [[ "$1" == "scaffold" ]] ; then
            exec /opt/odoo/common/entrypoint "$@"
        else
            exec /opt/odoo/common/entrypoint "$@" "${EXTRA_ARGS[@]}"
        fi
        ;;
    -*)
        exec /opt/odoo/common/entrypoint "$@" "${EXTRA_ARGS[@]}"
        ;;
    *)
        exec "$@"
esac

exit 1
#odoo --db_host 172.30.48.59 --db_user oeproduccion --db_password Tre7Z5vZyL38Hwm --dev all
