#!/usr/bin/env bash
: '
    Author: Max Resnick
    Copyright: Max Resnick 2015
   '

usage() {
    printf "
    Django management wrapper. Must be run within root of
    the Django application.Directory structure as follows:
        |--manage.py
        +--some_main_app
        +  |--settings
        |     |--env1
        |     |--env2
    -e environment e.g. env1
    -a argument for manage.py
    -o option for argument
    -h print this message
    "
}

find_main_app() {
    local readonly main_app_settings_path=$(find . -maxdepth 2 -type d -name settings)
    main_app=$(dirname $main_app_settings_path)
    echo "${main_app#./}"
}

activate() {
    if [ -f ./manage.py ]; then
        local readonly MAIN_APP=$(find_main_app)
    if [ "${#MAIN_APP}" == 0 ]; then
        echo 'Main Django App with setting not found, exiting.';
    else
        echo "python manage.py $AOPT $OOPT --settings=$MAIN_APP.settings.$EOPT"
        python manage.py $AOPT $OOPT --settings=$MAIN_APP.settings.$EOPT
    fi
    else
        echo 'pydj must be invoked with in the root directory of Django';
    fi
}
main() {
    while getopts e:a:oh name
    do
        case $name in
            e)readonly EOPT=$OPTARG;;
            a)readonly AOPT=$OPTARG;;
            o)readonly OOPT=$OPTARG;;
            h)usage && kill -INT $$;;
            *)echo "Invalid argument" && _usage && kill -INT $$;;
        esac
    done
    if [[ ! -z $EOPT ]] && [[ ! -z $AOPT ]]; then
        activate;
    else
        echo "environment && manage.py options required.";
    fi
}
main "$@";
