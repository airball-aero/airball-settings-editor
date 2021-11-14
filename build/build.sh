#!/bin/bash

export FLUTTER_PROJ=airball_settings_editor

rm -rf www/*
mkdir -p www
mkdir -p www/app

pushd ../${FLUTTER_PROJ}
flutter build web
popd

cp -r ../${FLUTTER_PROJ}/build/web/* www/app
cp ../server/*.py www
cp airball-settings.json www

perl -p -i -e 's/href=\"\/\"/href=\"\/app\/\"/g' www/app/index.html
