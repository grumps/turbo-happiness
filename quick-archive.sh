#!/bin/bash
#########################
# Config                #
# arg1 = Dir to archive #
# arg2 = name of backup #
# arg3 = MySQL DB       #
#########################

# Defaults to executing user for MySQL Admin user
MYSQL_USER=$USER

##########

#TODO Switch this to use getopts
args=("$@")
#TODO Check arguments are in place.
TODAY=`date +%m-%d-%y-%H-%M`
echo $TODAY
echo "*******************"
echo "Creating Temp Tarball" ${args[0]} "----> temp.tar"
tar -cvf temp.tar ${args[0]}
echo "==================="

echo "*******************"
echo "Starting MySQL Dump"
echo "==================="
# This will fail if MySQL is configured to use NIX user vs Purposeful MySQL User.
sudo -u $MYSQL_USER mysqldump -p ${args[2]} > ${args[2]}_$TODAY.sql
tar -uvf temp.tar ${args[2]}_$TODAY.sql
gzip temp.tar
mv temp.tar.gz ${args[1]}_$TODAY.tar.gz
ls -la ${args[1]}_$TODAY.tar.gz
backupcomplete=$?
if [ $backupcomplete -ne 0 ]; then
	echo "Backup might have failed. Please dbl check param 2.";
fi
rm ${args[2]}_$TODAY.sql
exit $?
