#!/usr/bin/env bash

pydj () {
    local CURRENT_DIR=$(pwd)
    if [ "$#" == 0 ]; then
        echo 'At least one argument is required'
        exit 1;
    fi
    if [ -f $CURRENT_DIR/manage.py ]; then
        # Need to find main app and autmagically use it.
        # local MAIN_APP=
        python manage.py $1 --settings=sayidowith_server.settings.$2
    fi
}
