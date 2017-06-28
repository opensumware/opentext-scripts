#!/bin/bash

create_as_cfg() {
if [ -n "$1" ]; then
        _CDS_CFG=$1
fi

if [ -n "$2" ]; then
        _AS_PATH=$2
fi

if [ -n "$3" ]; then
        _VIEWER_HOST=$3
fi

if [ -n "$4" ]; then
        _VIEWER_PORT=$4
fi

if [ -n "$5" ]; then
        _DPS_WORK_DIR=$5
fi

if [ -n "$6" ]; then
        _DPS_CACHE_DIR=$6
fi

if [ -n "$7" ]; then
        _DPS_LOG_PATH=$7
fi

if [ -z ${WEM_ADMIN_PASSWD} ]; then
        read -s -p "Enter ${WEM_ADMIN_USER}'s password: " WEM_ADMIN_PASSWD
        export WEM_ADMIN_PASSWD
        echo -e
fi

_CFGEDIT="${WEM_DIR}/bin/cfgedit"
_CFGSYNC="${WEM_DIR}/bin/cfgsync -h ${WEM_SERVER}:${WEM_PORT} -u ${WEM_ADMIN_USER} -p ${WEM_ADMIN_PASSWD}"

cd ${WEM_DIR}/bin

mkdir -p ${_AS_PATH}/cfgedit

cat > ${_AS_PATH}/cfgedit/script01.txt <<EOL
cd ${_CDS_CFG}/resources/Generic/VgnExtTemp/Generic
get -r DATA
EOL

cat > ${_AS_PATH}/cfgedit/script02.txt <<EOL
cd ${_CDS_CFG}/resources/Generic/VgnExtTemp/Generic
set -f ${_AS_PATH}/cfgedit/vgn-ext-templating.txt DATA
EOL

if [ ${_CDS_CFG} == ${CDS_CFG_Mgmt} ]; then
cat >> ${_AS_PATH}/cfgedit/script02.txt <<EOL
cd ${_CDS_CFG}/as/Preview/AAtend
set PREVIEW_HOST ${_VIEWER_HOST}
EOL
fi

cat >> ${_AS_PATH}/cfgedit/script02.txt <<EOL
commit
EOL

${_CFGSYNC} -i ${_CDS_CFG}/as -d ${_AS_PATH}

${_CFGEDIT} -F ${_AS_PATH}/conf/as.cfg -s ${_AS_PATH}/cfgedit/script01.txt > ${_AS_PATH}/cfgedit/vgn-ext-templating.txt
if [ -n "${_VIEWER_PORT}" ]; then
        sed -i.bak "s#viewer\.port=.*#viewer\.port=${_VIEWER_PORT}#g" ${_AS_PATH}/cfgedit/vgn-ext-templating.txt
fi

if [ -n "${_VIEWER_HOST}" ]; then
        sed -i.bak "s#viewer\.host=.*#viewer\.host=${_VIEWER_HOST}#g" ${_AS_PATH}/cfgedit/vgn-ext-templating.txt
fi

if [ -n "${_DPS_WORK_DIR}" ]; then
        sed -i.bak "s#templating\.workingDir=.*#templating\.workingDir=${_DPS_WORK_DIR}#g" ${_AS_PATH}/cfgedit/vgn-ext-templating.txt
fi

if [ -n "${_DPS_CACHE_DIR}" ]; then
        sed -i.bak "s#object\.cache\.cacheDir=.*#object\.cache\.cacheDir=${_DPS_CACHE_DIR}#g" ${_AS_PATH}/cfgedit/vgn-ext-templating.txt
fi

if [ -n "${_DPS_LOG_PATH}" ]; then
        sed -i.bak "s#log.debugLogFilename=.*#log.debugLogFilename=${_DPS_LOG_PATH}#g" ${_AS_PATH}/cfgedit/vgn-ext-templating.txt
fi

${_CFGEDIT} -F ${_AS_PATH}/conf/as.cfg -s ${_AS_PATH}/cfgedit/script02.txt

unset _CDS_CFG
unset _AS_PATH
unset _VIEWER_HOST
unset _VIEWER_PORT
unset _DPS_WORK_DIR
unset _DPS_CACHE_DIR
unset _DPS_LOG_PATH

}