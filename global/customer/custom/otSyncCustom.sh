#! /bin/bash

SCRIPT_PATH="/appl/ot/Scripts"
. ${SCRIPT_PATH}/global/customer/env/otCommonEnv.sh
. ${SCRIPT_PATH}/global/customer/env/otSampleMgmtEnv.sh
. ${SCRIPT_PATH}/global/customer/env/otSampleLiveEnv.sh
. ${SCRIPT_PATH}/localhost/env/otLocalCommonEnv.sh
. ${SCRIPT_PATH}/global/ot/utils/otWEMFunctions.sh

create_as_cfg_sample_mgmt() {
        APP_SERVER=$1
        VIEWER_PORT=$2

        echo ${APP_SERVER}
        create_as_cfg ${CDS_CFG_Mgmt} ${CDS_Mgmt}/as/${APP_SERVER} ${VIEWER_HOST} ${VIEWER_PORT} ${DPS_WORK_DIR_Sample_Mgmt} ${DPS_CACHE_DIR_Sample_Mgmt} ${DPS_LOG_PATH_Sample_Mgmt}
}

create_as_cfg_sample_live() {
        APP_SERVER=$1
        VIEWER_PORT=$2

        echo ${APP_SERVER}
        create_as_cfg ${CDS_CFG_Sample} ${CDS_Sample}/as/${APP_SERVER} ${VIEWER_HOST} ${VIEWER_PORT}
}
