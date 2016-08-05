#!/bin/bash

# --------- License Info ---------
# Copyright (c) 2013 Emind Systems Ltd. - http://www.emind.co
# This file is part of Emind Systems DevOps Toolset.
# Emind Systems DevOps Toolset is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
# Emind Systems DevOps Toolset is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with Emind Systems DevOps Toolset. If not, see http://www.gnu.org/licenses.

function usage {
	echo "Usage: $0 [-k <WS-AccessKeyId> -s <AWS-SecretKey> -r <AWS-Region> -w <waring> -c <critical>] <LB_NAME>"
}

while getopts "k:s:r:w:c:" arg; do
        case $arg in
        k)
        export AWS_ACCESS_KEY_ID=$OPTARG
        ;;

        s)
        export AWS_SECRET_ACCESS_KEY=$OPTARG
        ;;
        r)
	CMDOPT="$OPT --region $OPTARG"
        ;;
	w)
	WARNING=$OPTARG
	;;
	c)
	CRITICAL=$OPTARG
	;;
        \?)
        usage
        exit 99
        ;;
      esac
    done
shift $((OPTIND-1))
LB_NAME=$1

if [[ -z ${LB_NAME} ]]; then
        echo "Please specify the ELB name"
        usage
        exit 99
fi


CMD="/usr/bin/aws $CMDOPT elb describe-instance-health"
OPT="$OPT --load-balancer-name ${LB_NAME}"

JSON=$(${CMD} ${OPT})


if [[ $? -eq 0 ]]; then

	IN_SERVICE_COUNT=$(echo ${JSON} | jq -c '.InstanceStates[].State' | grep InService |wc -l)
	TOTAL_COUNT=$(echo ${JSON} | jq -c '.InstanceStates[].State' | wc -l)

	CRITICAL=${CRITICAL:=0}
	WARNING=${WARNING:=$TOTAL_COUNT}

	if [[ ${IN_SERVICE_COUNT} -le ${CRITICAL} ]]; then
			NAGIOS_STATE=CRITICAL
			EXIT_CODE=2
	elif [[ ${IN_SERVICE_COUNT} -lt ${WARNING} ]]; then
			NAGIOS_STATE=WARNING
			EXIT_CODE=1
	elif [[ ${IN_SERVICE_COUNT} -ge ${WARNING} ]]; then
			NAGIOS_STATE=OK
			EXIT_CODE=0
	fi
	echo "${NAGIOS_STATE}: ELB:${LB_NAME} Total:${TOTAL_COUNT} Healthy:${IN_SERVICE_COUNT} Critical:${CRITICAL} Warning:${WARNING} | Total=${TOTAL_COUNT} Healthy=${IN_SERVICE_COUNT} Critical=${CRITICAL} Warning=${WARNING}"
else
	echo "Failed to retrieve ELB Instances health from AWS"
	EXIT_CODE=99
fi

exit ${EXIT_CODE}
