#!/bin/bash

# SonarQube uses an embedded Elasticsearch
sysctl -w vm.max_map_count=524288
sysctl -w fs.file-max=131072
ulimit -n 131072
ulimit -u 8192

#mkdir -p ./sonarqube/data
#mkdir -p ./sonarqube/extensions
#mkdir -p ./sonarqube/logs
#mkdir -p ./postgresql/conf
#mkdir -p ./postgresql/data