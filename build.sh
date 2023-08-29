#!/bin/bash

docker build --build-arg NVM_DIR=/usr/local/nvm --build-arg NODE_VERSION=10.24.1 -t lam1623/node:10.24.1 .
