#!/bin/bash

# --------- License Info ---------
# Copyright 2013 Emind Systems Ltd - htttp://www.emind.co
# This file is part of Emind Systems DevOps Tool set.
# Emind Systems DevOps Tool set is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
# Emind Systems DevOps Tool set is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with Emind Systems DevOps Tool set. If not, see http://www.gnu.org/licenses/.

AWSAccessKeyId=$1
AWSSecretKey=$2
AWSRegion=$3
LB_NAME=$4
CMD=/opt/aws/bin/elb-describe-instance-health
OPT="--region ${AWSRegion} -I ${AWSAccessKeyId} -S ${AWSSecretKey} --lb ${LB_NAME}"
TMP=/tmp/$$

OUTPUT=$(${CMD} ${OPT} > ${TMP})
if [ $? -eq 0 ]; then

        STATE_LIST=$(cat ${TMP} | awk '{print $3}')
        IN_SERVICE_COUNT=$(echo ${STATE_LIST} | grep InService |wc -w)
        TOTAL_COUNT=$(echo ${STATE_LIST} | wc -w)

        if [ ${TOTAL_COUNT} -eq ${IN_SERVICE_COUNT} ]; then
                NAGIOS_STATE=OK
                EXIT_CODE=0
        elif [ ${IN_SERVICE_COUNT} -eq 0 ]; then
                NAGIOS_STATE=CRITICAL
                EXIT_CODE=2
        elif [ ${IN_SERVICE_COUNT} -lt ${TOTAL_COUNT} ]; then
                NAGIOS_STATE=WARNING
                EXIT_CODE=1
        fi
        echo "ELB-Instances-Health:${NAGIOS_STATE}: ELB:${LB_NAME} Total:${TOTAL_COUNT} Healthy:${IN_SERVICE_COUNT}"        
else
        echo "Usage: $0 AWSAccessKeyId AWSSecretKey AWSRegion LB_NAME"
        echo "Failed to retrieve ELB Instances health from AWS"
        EXIT_CODE=99		
fi

rm ${TMP}
exit ${EXIT_CODE}
