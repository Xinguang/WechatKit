#!/bin/bash

# ----- Build master
if [ -d WechatKit ]; then
  git -C WechatKit pull origin master
else
  git clone --depth 1 --branch master https://github.com/starboychina/WechatKit.git WechatKit
fi

cd WechatKit

jazzy --config ../.jazzy.yaml --output ../ --module-version "master"
