#!/usr/bin/env bash
# source in .bashrc
create_mysql_db () {
    while getopts ":d:m:u:" settings;
    do
        case $settings in
          d)readonly DATABASEBASENAME=$OPTARG;;
          m)readonly MYSQLUSER=$OPTARG;;
          u)readonly DATABASEUSER=$OPTARG;;
          \?)echo "Invalid arg" && exit 1;;
        esac
    done
    mysql -u $MYSQLUSER -p -e "CREATE DATABASE $DATABASEBASENAME; GRANT ALL PRIVILEGES ON $DATABASEBASENAME.* to '$DATABASEUSER'@'localhost';";
}
create_mysql_db "$@";
