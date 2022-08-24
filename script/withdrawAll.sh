#!/usr/bin/env bash

source .env
forge script Withdraw --rpc-url $FUJI_RPC_URL --private-key $PRIVATE_KEY --broadcast -vvv
forge script Withdraw --rpc-url $MUMBAI_RPC_URL --private-key $PRIVATE_KEY --broadcast -vvv
forge script Withdraw --rpc-url $GOERLI_RPC_URL --private-key $PRIVATE_KEY --broadcast -vvv