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

rm -rf bootstrap/.cache
rm -rf bootstrap/node1
rm -rf bootstrap/node2
rm -rf bootstrap/notary
mkdir -p bootstrap/node1 bootstrap/node2 bootstrap/notary

docker-compose up -d db1

echo "Install node.conf files"
cp shared/alice_node.conf bootstrap/node1_node.conf
cp shared/bob_node.conf bootstrap/node2_node.conf
cp shared/notary_node.conf bootstrap/notary_node.conf

echo "downloading postgresql drivers..."
mkdir -p shared/drivers
curl https://jdbc.postgresql.org/download/postgresql-42.2.20.jar -o shared/drivers/postgresql-42.2.20.jar -s

cp -r shared/drivers bootstrap/node1/drivers

echo "building bootstrapper docker image..."
docker build -t bootstrapper dockerfiles/bootstrapper
echo "generating network bootstrapping..."
docker run --rm \
  -v $(pwd)/bootstrap:/app/bootstrap \
  -v $(pwd)/shared/drivers:/app/drivers \
  --network=corda-net bootstrapper

echo "compiling sample cordapp..."
docker build -t cordapp-compile dockerfiles/cordapp-compile
docker run --rm -v $(pwd)/shared/cordapps:/app/build cordapp-compile

echo "copy shared network info"
cp -rf bootstrap/node1/additional-node-infos/ shared/infos/
cp -f bootstrap/node1/network-parameters shared/network-parameters

echo "making app archive..."
cd ../../apps && tar -cvzf splunk_app_for_corda.tgz Splunk_App_for_Corda
mv splunk_app_for_corda.tgz ../examples/docker/splunk/
cd ../examples/docker

echo "starting corda..."
docker-compose up --build -d

echo -n 'Waiting for splunk to start'
until docker logs splunk | grep -m 1 'Ansible playbook complete'
do
  echo -n "."
  sleep 5
done

docker exec -it splunk /bin/bash -c "sudo ./bin/splunk http-event-collector update -name splunk_hec_token -index em_metrics -uri https://localhost:8089 -auth admin:changeme"

echo ""
echo ""
echo "ready!"
