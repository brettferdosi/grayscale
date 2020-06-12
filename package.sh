#!/usr/bin/env sh

# first argument is path to the .app file
# second argument is path of the directory the .pkg will go in

productbuild --component "$1" "/Applications" "$2/GrayscaleInstaller.pkg"

