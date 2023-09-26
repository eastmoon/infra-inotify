#!/bin/bash

# Declare variable
T=${1}
IWATCHER_LOG_DIR=/tmp/.iwatcher
IWATCHER_TINODE=
IWATCHER_LOG=

# Declare function

# Execute script
## Retrieve inode and check target exist or not
IWATCHER_TINODE=$(stat -c "%i" ${T})
if [ -z ${IWATCHER_TINODE} ];
then
    echo "${T} is not exist."
    exit 1
fi
IWATCHER_LOG=${IWATCHER_LOG_DIR}/${IWATCHER_TINODE}
IWATCHER_LOG_TMP=${IWATCHER_LOG_DIR}/${IWATCHER_TINODE}.t

## Create log directory
[ ! -d ${IWATCHER_LOG_DIR} ] && mkdir ${IWATCHER_LOG_DIR}
#[ ! -e ${IWATCHER_LOG} ] && touch ${IWATCHER_LOG}
echo "" > ${IWATCHER_LOG_TMP}

echo "Watcher ${1} (${IWATCHER_TINODE})"
##
for row in $(find / -inum ${IWATCHER_TINODE} -exec ls -i {} \; | awk '{print $1}');
do
    #echo "${row}"
    row_p=$(find / -inum ${row})
    if [ ! -e ${IWATCHER_LOG} ] || [ $(grep "${row}" ${IWATCHER_LOG} | wc -l) -eq 0 ];
    then
        echo $(stat -c "%i %X %Y" ${row_p}) ${row_p} >> ${IWATCHER_LOG_TMP}
        echo "CREATE ${row_p}"
    else
        row_nmt=$(stat -c "%i %X %Y" ${row_p})
        row_nmodify=$(echo ${row_nmt} | awk '{print $3}')
        row_omt=$(grep "${row}" ${IWATCHER_LOG})
        row_omodify=$(echo ${row_omt} | awk '{print $3}')
        if [ ! ${row_nmodify} -eq ${row_omodify} ];
        then
            echo "UPDATE ${row_p}"
        fi
        echo ${row_nmt} ${row_p} >> ${IWATCHER_LOG_TMP}
    fi
done
##
if [ -e ${IWATCHER_LOG} ];
then
    for row_del in $(cat ${IWATCHER_LOG} | awk '{print $1"@"$4}');
    do
        row=${row_del%@*}
        row_p=${row_del#*@}
        if [ $(grep "${row}" ${IWATCHER_LOG_TMP} | wc -l) -eq 0 ];
        then
            #echo "${row}"
            echo "DELETE ${row_p}"
        fi
    done
fi
##
mv ${IWATCHER_LOG_TMP} ${IWATCHER_LOG}

#while [ 1 ]
#do
#    usleep 10
#done
