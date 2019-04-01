#!/bin/bash

WHERE=$1
SLEEP_FIRST=$2
SLEEP_SECOND=$3

INPUT=INPUT.log
SUCCESS_LOG=success.log
ERROR_LOG=error.log
ERROR_LOG_VERBOSE=error_verbose.log

rm -f ${INPUT}
rm -f ${SUCCESS_LOG}
rm -f ${ERROR_LOG}
rm -f ${ERROR_LOG_VERBOSE}

function analyze {
    LOG=gitbase.log
    READY="server started and listening on localhost:3306"

    COUNT=`find $1 -name "*.siva" | wc -l`
    echo "PROCESSING '$1' : ${COUNT} siva files"

    gitbase server --directories $1 --port=3306 --index=/tmp/gitbase 1> ${LOG} 2>> ${LOG} &

    elapsed=0
    until [ -n "`grep \"${READY}\" < ${LOG}`" ] || [ "${elapsed}" -gt "$2" ]; do
        elapsed=$((elapsed + 1));
        sleep .1;
    done

    killall gitbase;

    grep "${READY}" < ${LOG}

    if [ "$?" = 1 ]
    then
        echo $1 >> ${ERROR_LOG}
        echo "$1 contained ${COUNT} repositories" >> ${ERROR_LOG_VERBOSE}
    else
        echo $1 >> ${SUCCESS_LOG}
    fi
}

for dir in ${WHERE}/*; do
    analyze ${dir} ${SLEEP_FIRST};
done

mv ${SUCCESS_LOG} first_${SUCCESS_LOG}
mv ${ERROR_LOG} ${INPUT}
mv ${ERROR_LOG_VERBOSE} first_${ERROR_LOG_VERBOSE}

while read line; do
    for siva in ${line}/*; do
        analyze ${siva} ${SLEEP_SECOND};
    done
done <${INPUT}
