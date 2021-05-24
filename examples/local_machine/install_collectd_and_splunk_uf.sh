#!/bin/bash

# Copyright 2021 Splunk Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

CORDA_LOGS=$1
SPLUNK_HOST=$2
SPLUNK_HEC_TOKEN=$3

export SPLUNK_URL=${SPLUNK_HOST}
export HEC_PORT=8088
export HEC_TOKEN=${SPLUNK_HEC_TOKEN}
export RECEIVER_PORT=9997
export INSTALL_LOCATION=/opt/
export SAI_ENABLE_DOCKER=
export DIMENSIONS="entity_type:nix_host"
export METRIC_TYPES=cpu,uptime,df,disk,interface,load,memory,processmon
export METRIC_OPTS=cpu.by_cpu
export LOG_SOURCES=/etc/collectd/collectd.log%collectd,\$SPLUNK_HOME/var/log/splunk/*.log*%uf,/var/log/syslog%syslog,/var/log/daemon.log%syslog,/var/log/auth.log%syslog,${CORDA_LOGS}/*.log*%corda
export AUTHENTICATED_INSTALL=Yes
export INSTALL_LOCATION=/opt/

tar -xzf unix-agent.tgz && cd unix-agent && bash install_uf.sh && bash install_agent.sh && cd .. && rm -rf unix-agent

sed -i "s+CORDA_LOGS+${CORDA_LOGS}+g" fwdr_inputs.conf

cp -f fwdr_inputs.conf /opt/splunkforwarder/etc/apps/splunk_app_infra_uf_config/local/inputs.conf
