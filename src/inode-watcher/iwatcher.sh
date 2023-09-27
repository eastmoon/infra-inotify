#!/bin/bash

# Declare variable
IWATCHER_TATGET=${1}
IWATCHER_ON_WATCH=${2}
IWATCHER_LOG_DIR=/tmp/.iwatcher
IWATCHER_D=()

# Declare function
function watchf() {
    ##
    t=${1}
    ti=
    ## Check target is exist or not
    if [ -e ${t} ];
    then
        ## Initial variable
        tinfo=$(stat -c "%i %X %Y %F" ${t})
        ti=$(echo ${tinfo} | awk '{print $1}')
        #echo "Watcher ${t} (${ti})"
        t_log=${IWATCHER_LOG_DIR}/${ti}${t//\//-}
        t_log_tmp=${IWATCHER_LOG_DIR}/${ti}${t//\//-}.t
        ## Initial log file
        [ ! -e ${t_log} ] && touch ${t_log}
        echo "" > ${t_log_tmp}
        ##
        if [ $(cat ${t_log} | wc -l) -eq 0 ];
        then
            echo "CREATE ${t}"
            echo $(echo ${tinfo} | awk '{print $1" "$2" "$3}') ${t} > ${t_log_tmp}
        else
            ti_nmt=$(echo ${tinfo} | awk '{print $1" "$2" "$3}')
            ti_nmodify=$(echo ${ti_nmt} | awk '{print $3}')
            ti_omt=$(grep "${ti}" ${t_log})
            ti_omodify=$(echo ${ti_omt} | awk '{print $3}')
            if [ ! ${ti_nmodify} -eq ${ti_omodify} ];
            then
                echo "UPDATE ${t}"
            fi
            echo ${ti_nmt} ${t} > ${t_log_tmp}
        fi
        ##
        mv ${t_log_tmp} ${t_log}
        ##
        [ $(echo ${tinfo} | awk '{print $4}') == "directory" ] && IWATCHER_D=(${IWATCHER_D[@]} ${ti})
    else
        if [ $(find ${IWATCHER_LOG_DIR} -type f -iname "*${t//\//-}" | wc -l) -gt 0 ];
        then
            echo "DELETE ${t}"
            find ${IWATCHER_LOG_DIR} -type f -iname "*${t//\//-}" -exec rm {} \;
        fi
    fi
}
function watchd() {
    ##
    ti=${1}
    t=$(find / -inum ${ti})
    ##
    t_log=${IWATCHER_LOG_DIR}/${ti}${t//\//-}.d
    t_log_tmp=${IWATCHER_LOG_DIR}/${ti}${t//\//-}.d.t
    ## Initial log file
    [ ! -e ${t_log} ] && touch ${t_log}
    echo "" > ${t_log_tmp}
    ##
    for r in $(find ${t} -inum ${ti} -exec ls {} \; | awk '{print $1}');
    do
        #echo "${row}"
        r=${t}/${r}
        rinfo=$(stat -c "%i %X %Y %F" ${r})
        ri=$(echo ${rinfo} | awk '{print $1}')
        if [ $(grep "${ri}" ${t_log} | wc -l) -eq 0 ];
        then
            echo "CREATE ${r}"
            echo $(echo ${rinfo} | awk '{print $1" "$2" "$3}') ${r} >> ${t_log_tmp}
        else
            ri_nmt=$(echo ${rinfo} | awk '{print $1" "$2" "$3}')
            ri_nmodify=$(echo ${ri_nmt} | awk '{print $3}')
            ri_omt=$(grep "${ri}" ${t_log})
            ri_omodify=$(echo ${ri_omt} | awk '{print $3}')
            if [ ! ${ri_nmodify} -eq ${ri_omodify} ];
            then
                echo "UPDATE ${r}"
            fi
            echo ${ri_nmt} ${r} >> ${t_log_tmp}
        fi
        ##
        [ $(echo ${rinfo} | awk '{print $4}') == "directory" ] && IWATCHER_D=(${IWATCHER_D[@]} ${ri})
    done
    ##
    for linfo in $(cat ${t_log} | awk '{print $1"@"$4}');
    do
        r=${linfo#*@}
        ri=${linfo%@*}
        if [ $(grep "${ri}" ${t_log_tmp} | wc -l) -eq 0 ];
        then
            #echo "${row}"
            echo "DELETE ${r}"
        fi
    done
    ##
    mv ${t_log_tmp} ${t_log}
}
# Execute script
## Create log directory
[ ! -d ${IWATCHER_LOG_DIR} ] && mkdir ${IWATCHER_LOG_DIR}
## Initial target information
##
[ -z ${IWATCHER_ON_WATCH} ] && IWATCHER_ON_WATCH=1
while [ ${IWATCHER_ON_WATCH} -eq 1 ]
do
    watchf ${IWATCHER_TATGET}
    di=0
    while [ ${#IWATCHER_D[@]} -gt ${di} ];
    do
        #echo ${IWATCHER_D[${di}]}
        watchd ${IWATCHER_D[${di}]}
        di=`expr ${di} + 1`
    done
    ##
    usleep 10
    ##
    #IWATCHER_ON_WATCH=0
done
