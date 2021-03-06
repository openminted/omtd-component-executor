#!/bin/bash

# Script for 
# A. Generating Galaxy wrappers
# B. Pushing the respective images to the specified Docker Registry (if required) 
# C. Copying Galaxy wrappers to the respective Galaxy instances (specifically to tool directory).

clear

# -- Script parameters
DockerRegistyHOST=$1
OMTDSHAREDescriptorsFolderRoot=$2
OMTDSHAREDescriptorsFolder=$3
GalaxyID=$4
#ComponentID=$5
#ComponentVersion=$6
Dockerfile=$5
DockerID=$6
DockerVersion=$7
Push=$8
DockerImg="NOTPROVIDED"
DockerImgTag="NOTPROVIDED"
GalaxyExecutorLoc=$9	


echo "args:"$@
echo $DockerID
echo $DockerVersion
echo $Push
# -- 

# Before everything build project.
mvn clean install

# Clean wrappers dir
echo "Clean wrappers dir"
wrappersDir=$OMTDSHAREDescriptorsFolderRoot$OMTDSHAREDescriptorsFolder"_wrappers"
rm $wrappersDir/*

# If dockerfile is provided
# then build DockerImg, DockerImgTag values.
if [ $Dockerfile != "none" ]; then
	# Docker image name.
	DockerImg="omtd-component-executor-"${DockerID}":"${DockerVersion}
	# Docker image tag.
	DockerImgTag="${DockerRegistyHOST}/openminted/${DockerImg}"

	echo "-----"
	echo "Dockerfile:"$Dockerfile 
	echo "DockerImg:"$DockerImg
else
	# DockerImg is not required
	DockerImg=""
	# A DockerImgTag is provided.
	DockerImgTag=${10}
fi

echo "DockerImgTag:"$DockerImgTag
echo "-----"

# Generate 
# * Galaxy Wrappers 
# * TDMCoordinatesList file (only for Maven-based components)
# from omtd-share descriptors
# ~~~~~~~~~~~~~~~~~~~~~
#suffix=".wrapper."$ComponentID"."$ComponentVersion".xml"
suffix=".xml"
echo "Generate galaxy wrappers and TDMCoordinatesList" 
java -jar ./omtd-component-galaxy/target/omtd-component-galaxy-0.0.1-SNAPSHOT-exec.jar $OMTDSHAREDescriptorsFolderRoot $OMTDSHAREDescriptorsFolder $GalaxyID $DockerImgTag $suffix

# If needed copy coordinates file.
GeneratedCoordinatesList=$OMTDSHAREDescriptorsFolderRoot$GalaxyID"coordinates.list"
if [ -f $GeneratedCoordinatesList ]; then
	# Copy output coordinates to TDMCoordinatesList.txt
	cat $GeneratedCoordinatesList > TDMCoordinatesList.txt
fi

# If dockerfile is provided
if [ $Dockerfile != "none" ]; then
	# Build image.
	echo "-- -- Build image" 
	sudo docker build -f $Dockerfile -t $DockerImg .
fi

# If specified Tag and Push image.
# ~~~~~~~~~~~~~~~~~~~~~
echo "Push:"$Push
if [ $Push == "yes" ]; then
	# Tag the image for OMTD docker registry.
	echo "-- -- Tag image" 
	#sudo docker tag -f $DockerImg $DockerImgTag
	sudo docker tag $DockerImg $DockerImgTag

	# Push it to OMTD docker Registry.
	echo "-- -- Push image:"$DockerImgTag
	sudo docker push $DockerImgTag
fi

# Ask
echo -e "\n\n"
read -p "Copy wrappers to Executor (y/n)?" choice
case "$choice" in 
  y|Y ) 
  echo "yes"
  # Now that image is pushed and is available to docker registry 
  # copy wrappers to target machine/dir so that everything appears in Galaxy UI. 
  # ~~~~~~~~~~~~~~~~~~~~~
  echo "-- -- Copying wrappers"
  wrappersDest=root@$GalaxyExecutorLoc:/srv/galaxy/tools/$GalaxyID
  echo $wrappersDir
  echo $wrappersDest
  # Copying to Executor:
  scp -r $wrappersDir/* $wrappersDest
  # Copying to Editor: The tools dirs of Editor and Executor are synced via NFS so copying to Editor is deactivated.
  #scp -r $wrappersDir/* root@snf-1480.ok-kno.grnetcloud.net:/srv/galaxy/tools/$GalaxyID 
  ;;
  n|N ) 
  echo "wrappers ... not copied";;
  * ) 
  echo "invalid"
  ;;
esac

