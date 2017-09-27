#!/bin/bash

DockerRegistyHOST="snf-765691.vm.okeanos.grnet.gr"
OMTDSHAREDescriptorsFolderRoot="/home/ilsp/Desktop/OMTDTemp/"
OMTDSHAREDescriptorsFolder="omtds-dkpro-core-1.9.0-SNAPSHOT"
GalaxyID="omtdDKPro"

ComponentID="dkpro-core"
ComponentVersion="1.9.0-SNAPSHOT"

./omtd-component-createDockerImg.sh $DockerRegistyHOST $OMTDSHAREDescriptorsFolderRoot $OMTDSHAREDescriptorsFolder $GalaxyID $ComponentID $ComponentVersion