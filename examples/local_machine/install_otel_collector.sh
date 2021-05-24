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

curl -LJO https://github.com/open-telemetry/opentelemetry-collector-contrib/releases/download/v0.21.0/otelcontribcol_linux_amd64

chmod a+x otelcontribcol_linux_amd64

mv otelcontribcol_linux_amd64 /usr/bin/otelcontribcol

CORDA_HOST=$1
SPLUNK_HOST=$2
SPLUNK_HEC_TOKEN=$3

sed -i "s/CORDA_HOST/${CORDA_HOST}/g" otel-collector-config.yml
sed -i "s/SPLUNK_HOST/${SPLUNK_HOST}/g" otel-collector-config.yml
sed -i "s/SPLUNK_HEC_TOKEN/${SPLUNK_HEC_TOKEN}/g" otel-collector-config.yml

cp otel-collector-config.yml /etc/otel-collector-config.yml
