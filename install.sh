#!/usr/bin/env bash

GITHUB_REPO=jewetnitg/ioq3-mac-installer
AUTOEXEC_URL=https://raw.githubusercontent.com/${GITHUB_REPO}/master/resources/autoexec.cfg
SOURCE_REPO=https://github.com/ioquake/ioq3
SOURCE_DIR=$HOME/ioq3
INSTALL_DIR=/Applications/ioquake3
BASEQ3_URL=https://raw.githubusercontent.com/nrempel/q3-server/master/baseq3
BASEQ3_DIR=${INSTALL_DIR}/baseq3
LOG_FILE=ioq3_install.log

CPMA_MOD_FILES_FILE=cpma-1.51-nomaps.zip
CPMA_MOD_FILES_URL=https://cdn.playmorepromode.com/files/cpma/cpma-1.51-nomaps.zip
CPMA_MAP_PACK_FILE=cpma-1.51-nomaps.zip
CPMA_MAP_PACK_URL=https://cdn.playmorepromode.com/files/cpma-mappack-full.zip

set -e # exit on error

# clean up
rm -rf ${SOURCE_DIR} ${LOG_FILE}

echo "Cloning ioq3 sources..."
git clone ${SOURCE_REPO} ${SOURCE_DIR} &> ${LOG_FILE}

echo "Building ioq3..."
${SOURCE_DIR}/make-macosx.sh x86_64 &> ${LOG_FILE}

echo "Copying build to ${INSTALL_DIR}..."
cp -R ${SOURCE_DIR}/build/release-darwin-x86_64/ ${INSTALL_DIR} &> ${LOG_FILE}

COUNT=0
while [ ${COUNT} -lt 9 ]; do
    echo "Downloading pak$COUNT.pk3..."
    curl ${BASEQ3_URL}/pak${COUNT}.pk3 > ${BASEQ3_DIR}/pak${COUNT}.pk3
    let COUNT+=1
done


echo "Installing CPMA..."

curl ${CPMA_MOD_FILES_URL} -o ${CPMA_MOD_FILES_FILE}
unzip ${CPMA_MOD_FILES_FILE} -d ${INSTALL_DIR}

echo "Installing CPMA maps..."
curl ${CPMA_MAP_PACK_URL} -o ${CPMA_MAP_PACK_FILE}
unzip ${CPMA_MAP_PACK_FILE} -d ${BASEQ3_DIR}

echo "Adding autoexec.cfg"
curl ${AUTOEXEC_URL} > ${BASEQ3_DIR}/autoexec.cfg

echo "Removing temporary files..."
rm -rf ${SOURCE_DIR} ${CPMA_MOD_FILES_FILE} ${CPMA_MAP_PACK_FILE}

echo "Quake III has been installed successfully to ${INSTALL_DIR}!"

