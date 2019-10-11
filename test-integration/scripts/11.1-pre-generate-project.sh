#!/bin/bash

set -e
source $(dirname $0)/00-init-env.sh

#-------------------------------------------------------------------------------
# Install Blueprint
#-------------------------------------------------------------------------------

if !$BLUEPRINT_BUILD; then
    echo "*** jhipster: not a blueprint installation"
    exit 0
fi

mkdir -p "$JHI_FOLDER_APP"
cd "$JHI_HOME"

if $BLUEPRINT_LINK && $BLUEPRINT_GLOBAL; then
    echo "*** Link blueprint globally"
    npm link

elif $BLUEPRINT_LINK; then
    echo "*** Link blueprint locally"
    npm link

    cd "$JHI_FOLDER_APP"
    npm link "$BLUEPRINT_NAME"

elif $BLUEPRINT_GLOBAL; then
    echo "*** Installing blueprint globally"
    npm install -g "$JHI_HOME"

else
    echo "*** Installing blueprint locally at $JHI_FOLDER_APP"
    cd "$JHI_FOLDER_APP"

    # Create package.json otherwise npm will error and break
    # https://github.com/visionmedia/debug/issues/261
    npm init -f

    if [[ "$JHI_GEN_BRANCH" == "release" && "$JHI_GEN_VERSION" != "" ]]; then
        npm install "generator-jhipster@$JHI_GEN_VERSION"

    elif [[ "$JHI_GEN_BRANCH" == "release" ]]; then
        npm install generator-jhipster

    else
        npm install "$HOME"/generator-jhipster
    fi

    # Install blueprint
    npm install "$JHI_HOME"
fi

cd "$JHI_HOME"
npm info generator-jhipster version
JHI_INSTALLED_VERSION=$(npm info generator-jhipster version)
echo JHI_INSTALLED_VERSION="$JHI_INSTALLED_VERSION"

if [[ $JHI_INSTALLED_VERSION == '' ]]; then
    # Replace jhipster version with installed version
    echo 'Fixing jhipster version'
    echo `cat package.json | grep '"generator-jhipster"'`
    sed -e 's#"generator-jhipster": ".*",#"generator-jhipster": "$JHI_INSTALLED_VERSION",#1;' package.json > package.json.sed
    mv -f package.json.sed package.json
    echo 'Fixed jhipster version'
    echo `cat package.json | grep '"generator-jhipster"'`
fi

#-------------------------------------------------------------------------------
# Check folder where the app is generated
#-------------------------------------------------------------------------------
ls -al "$JHI_FOLDER_APP"
