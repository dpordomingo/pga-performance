#!/bin/bash

#
# Run DB
#
OUTPUT=/projects/src/github.com/dpordomingo/pga-performance/pga/repos
srcd init ${OUTPUT}/; srcd sql show\ tables

#
# Query DB
#
OUTPUT=/projects/src/github.com/dpordomingo/pga-performance/pga/repos
find ${OUTPUT} -name *.siva | wc -l;
mysql --port=3306 --user=root --host=127.0.0.1 \
    --execute "SELECT count(*) from repositories"

#
# Borges stack with docker-compose
#
OUTPUT=/projects/src/github.com/dpordomingo/pga-performance/pga/repos
OUTPUT_LOG=/projects/src/github.com/dpordomingo/pga-performance/repos.out.log
REPOS_TXT_PATH=/projects/src/github.com/dpordomingo/pga-performance/repos.txt;
SIVA_ROOT_PATH=${OUTPUT};
WORKERS=12;
BUCKET_SIZE=2;
export SIVA_ROOT_PATH;
export REPOS_TXT_PATH;
export WORKERS;
export BUCKET_SIZE;
docker-compose down && \
docker rmi -f srcd/borges:dev && \
docker-compose up 2>&1 | tee ${OUTPUT_LOG}


#
# Disc ussage
#
export OUTPUT=/projects/src/github.com/dpordomingo/pga-performance/pga/repos
export LOGS_PATH=/projects/src/github.com/dpordomingo/pga-performance
export LIST=${LOGS_PATH}/repos.txt
export GOAL=${LOGS_PATH}/repos.txt
export STDO=${LOGS_PATH}/repos.out.log
function count { echo "  `find ${OUTPUT} -name *.siva | wc -l`/`wc -l ${GOAL}`"; };
function proce { echo "  `grep "job finished successfully" ${STDO} | wc -l`/`wc -l ${LIST}`"; };
function error { echo "  auth: `grep "authentication required" ${STDO} | wc -l` / err: `grep "job finished with error" ${STDO} | wc -l`"; };
function usage { echo "  `du ${OUTPUT} --max-depth=0 --si`"; };
function frees { echo "`df /projects --si --output=avail,pcent | grep G`"; };
export -f count proce error usage frees;
watch --interval=2 -x bash -c 'echo SIVAS:; count; echo PROCESS:; proce; echo ERRORS:; error; echo USED:; usage; echo FREE:; frees';

# 14h
#
# no space in disc
#   https://github.com/dotabuff/d2vpk
#   https://github.com/kubernetes/deployment-manager
#   https://github.com/llvm-mirror/llvm
#   https://github.com/bloomberg/chromium.bb
