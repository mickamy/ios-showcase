#!/bin/bash

if test ! $(which xcodegen); then
  echo "Install xcodegen from https://github.com/yonaskolb/XcodeGen"
else
  echo "Build .xcodeproj file with xcodegen..."
  xcodegen
fi
