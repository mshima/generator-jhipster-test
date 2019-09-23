#!/bin/bash

set -e
source $(dirname $0)/00-init-env.sh

#-------------------------------------------------------------------------------
# Project Customizations
#-------------------------------------------------------------------------------

if $BLUEPRINT_BUILD; then
    echo "*** jhipster: blueprint installation"

else
    echo "*** jhipster: not a blueprint installation"
    exit 0
fi

cd "$JHI_FOLDER_APP"
if [[ -f "dummy.txt" ]]; then
    echo "*** dummy.txt found"
    echo $(cat dummy.txt)

else
    echo "*** dummy.txt not found"
    exit 1
fi
