#!/bin/bash

npm cache clean --force
yarn cache clean --force
rm -rf node_modules && rm -rf static

START=$(date +%s)
npm install && npm run build
END=$(date +%s)
DURATION1=$((END - START))

npm cache clean --force
yarn cache clean --force
rm -rf node_modules && rm -rf static
 
START=$(date +%s)  # Start time
yarn install && yarn run build
END=$(date +%s)    # End time
DURATION2=$((END - START))


echo
echo "NPM setup completed in $DURATION1 seconds."
echo
echo "Yarn setup completed in $DURATION2 seconds."
echo
