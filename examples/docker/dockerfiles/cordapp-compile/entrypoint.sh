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

curl -LJO https://github.com/corda/samples-kotlin/tarball/cafc5354ce51959fe92986992b8ebf758eafff7f

tar -xzf corda-samples-kotlin-*.tar.gz

rm corda-samples-kotlin-*.tar.gz

mv corda-samples-kotlin-* cordapps

cd cordapps/Features/customlogging-yocordapp && ./gradlew build

cp -f /app/cordapps/Features/customlogging-yocordapp/build/libs/*.jar /app/build/
cp -f /app/cordapps/Features/customlogging-yocordapp/contracts/build/libs/*.jar /app/build/
cp -f /app/cordapps/Features/customlogging-yocordapp/workflows/build/libs/*.jar /app/build/
