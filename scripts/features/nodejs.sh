#!/usr/bin/env bash

# Install nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

# Install nodejs 14
nvm install 14

# Install yarn
npm install -g yarn
