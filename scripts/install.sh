#!/usr/bin/env bash

curl -L https://foundry.paradigm.xyz | bash
foundryUp
brew install python
pip3 install solc-select
solc-select install 0.8.13
solc-select use 0.8.13
pip3 install slither-analyzer