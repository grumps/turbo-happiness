#!/usr/bin/env bash
: '
    Author: Max Resnick
    Usage: Used to copy code from one directory to another, and test permissions.

   '
usage () {
    printf "
    Wrapper for RSYNC and Find Permissions Errors.
    It's best to run as root since we're moving code to the Webserver root.
    We ignore all files with .txt extension and all files below the directory 'files'
    Usage (NOTE NON GNU COMPLIANT LONG TAIL):
    -t -- Run as a test, aka dry run with verbose mode
    -D -- Deletes files in Destination that aren't in Source
    \tNOTE: Be careful, make sure that source directory has complete copy of the code recursively.
    -s -- REQUIRED Source directory:
        ie. /home/some/user/drupal/sites/
    -d -- REQUIRED Destination directory:
        ie. /var/www/vhosts/someclient.com/drupal/sites
    "
    exit 1;

}

test_copy () {
    echo "Test Copy Code"
    rsync -avnr --exclude='.svn' --exclude='files*' --exclude='*.txt' $DELETEOPT $SOPT $DOPT
    return $?;
}

live_copy () {
    echo "Copying Code Base."
    rsync -ar --exclude='.svn' --exclude='files*' --exclude='*.txt' $DELETEOPT $SOPT $DOPT
    return $?;
}

permissions_test () {
    # Hack -- are we on a RPM or DEB system?
    groups apache > /dev/null 2>&1 
    local webgrouptest=$?
    if [[ $webgrouptest -ne 0 ]]; then
         local webgrouptest=www-data
    elif [[ $webgrouptest  -eq 0 ]]; then
        local webgroup=apache
    fi
    find $DOPT \! -group  $webgroup -ls
    find $DOPT -type d \! -perm /g+r -ls
    printf "
    ###########################################
    The above files have incorrect permissions.
    Expected ownership by:
    \t $webgroup%s";
}

main () {
    while getopts hts:d:D name
    do
        case $name in
          t)readonly TOPT=1;;
          s)readonly SOPT=$OPTARG;;
          d)readonly DOPT=$OPTARG;;
          D)readonly DELETEOPT="--delete";;
          h)usage;;
          *)echo "Invalid arg" && usage && exit 1;;
        esac
    done
    # Test Option
    if [[ ! -z $TOPT ]] && [[ ! -z $SOPT ]] && [[ ! -z $DOPT ]]; then
        local test_run=$(test_copy)
        printf "$test_run%s\n"
        exit 1;
    # Live Copy Run
    elif [[ ! -z $SOPT ]] && [[ ! -z $DOPT ]]; then
        local live_run= $(live_copy)
        printf "$live_run%s\n"
        local permissions=$(permissions_test);
        printf "$permissions%s\n";
    # TODO I wanna delete code method.
    else
        echo "Source and/or Destination Arguments Missing";
        exit 1;
    fi
}
main "$@";
