#!/usr/bin/bash -xt

pydj () {
    _find_main_app() {
        local readonly _main_app_settings_path=$(find . -maxdepth 2 -type d -name settings)
        _main_app=$(dirname $_main_app_settings_path)
        echo "${_main_app#./}"
    }
    # TODO GETOPTS
    if [ "$#" == 0 ]; then
        echo 'At least one argument is required'
        exit 1;
    fi
    if [ -f ./manage.py ]; then
        local readonly MAIN_APP=$(_find_main_app)
        if [ "${#MAIN_APP}" == 0 ]; then
            echo 'Main Django App with setting not found, exiting.';
        else
            python manage.py $1 --settings=$MAIN_APP.settings.$2
        fi
    else
        echo 'pydj must be invoked with in the root directory of Django';
    fi
}
