#!/bin/bash
:'
    Author: Max Resnick
    Usage: Used in the case of Drush not being portable.

    '
help () {
    printf "Quick Archive, similar to Drush Archive with no Drush Dependency.
    Quick Archive requires 3 Arguments, there's no checks in place.
    It just fails if you don't get them right. \n
    The intention is to be able restore the archive if things go south,
    and not make a portable archive. To be portable you'll need to trim the
    Tarball on export.

    ARGS must be in specified order, aren't optional, with no prefix.
    --ARGS[0] is the directory you wish to backup aka Drupal Root:
       Example /var/www/vhosts/maximus.com/www
       WARNING: This needs to be an absolute path, not relative.
    --ARGS[1] is the name of the Tarball, ARGS[1] is appended with Today's Date.
        HINT: The name should include the absolute path && name of Tarball.
    --ARGS[2] is the name of the database.
        Warning: We assume that user invoking Script has MYSQL Access Rights.";
}
quick_archive () {
    readonly local TODAY=`date +%m-%d-%y-%H-%M`
    tar -cf temp.tar ${ARGS[0]}
    # This is has portable issue, via Maximus authentication is handled by PAM
    mysqldump -u $MYSQL_USER ${ARGS[2]} -p > ${ARGS[2]}_$TODAY.sql
    tar -uf temp.tar ${ARGS[2]}_$TODAY.sql
    gzip temp.tar
    mv temp.tar.gz ${ARGS[1]}_$TODAY.tar.gz
    ls -la ${ARGS[1]}_$TODAY.tar.gz
    if [ $backupcomplete -ne 0 ]; then
       printf "Backup might have failed. Check ARG[2]."
    fi

}

main () {
    readonly ARGS=("$@")
    readonly MYSQL_USER=dev
    # We check if someone needs help and quit.
    if [ "${ARGS[0]}" == "-h" ] || [ "${ARGS[0]}" == "--help" ]; then
        help
        exit;
    elif [ ${#ARGS[@]} -eq 3 ]; then
        local backupcomplete=$(quick_archive)
        echo $backupcomplete
    else
        printf "Incorrect Number of ARGS recieved, see --help"
        exit 126
    fi
    rm ${ARGS[2]}_$TODAY.sql;
}
main "$@"

