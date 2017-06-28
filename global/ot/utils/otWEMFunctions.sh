#!/bin/bash

create_as_cfg() {
    CDS_CFG=$1
    AS_PATH=$2
    VIEWER_HOST=$3
    VIEWER_PORT=$4

    mkdir -p ${AS_PATH}/cfgedit

    cat > ${AS_PATH}/cfgedit/script01.txt <<EOL
    cd ${CDS_CFG}/resources/Generic/VgnExtTemp/Generic
    get -r DATA
    EOL

    cat > ${AS_PATH}/cfgedit/script02.txt <<EOL
    cd ${CDS_CFG}/resources/Generic/VgnExtTemp/Generic
    set -f ${AS_PATH}/cfgedit/vgn-ext-templating.txt DATA
    commit
    EOL

    $CFGSYNC -i ${CDS_CFG}/as -d ${AS_PATH}

    $CFGEDIT -F ${AS_PATH}/conf/as.cfg -s ${AS_PATH}/cfgedit/script01.txt > ${AS_PATH}/cfgedit/vgn-ext-templating.txt

    sed -i.bak "s/viewer.port=.*/viewer.port=${VIEWER_PORT}/g" ${AS_PATH}/cfgedit/vgn-ext-templating.txt
    sed -i.bak "s/viewer.host=.*/viewer.host=${VIEWER_HOST}/g" ${AS_PATH}/cfgedit/vgn-ext-templating.txt

    $CFGEDIT -F ${AS_PATH}/conf/as.cfg -s ${AS_PATH}/cfgedit/script02.txt
}