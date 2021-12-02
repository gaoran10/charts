#!/usr/bin/env bash
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

image_version="$1"

if [ -z "$image_version" ]; then
  echo "Error: image_version is not set";
  exit 1;
fi

echo "change to use image version: $image_version"

rm -rf charts/pulsar-custom
cp -r charts/pulsar-2.8.0.8 charts/pulsar-custom
sed -i "s/2.8.0.8/$image_version/g" charts/pulsar-custom/values.yaml
