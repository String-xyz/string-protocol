<img align="right" width="150" height="150" top="100" src="https://avatars.githubusercontent.com/u/104804397?s=200&v=4">

# string-protocol
String Smart Contracts

### Initial setup

If running MacOS with Brew, clone this repository and run:
```bash
scripts/install.sh
```

# Scripts
Test smart contracts using Forge and Slither
```bash
scripts/test.sh
```

## Useful Commands
build project
```bash
forge build
```
test project
```bash
forge test
```
run slither (after slither is installed)
```bash
slither src/StringContract.sol --print human-summary
```
deploy a contract
```bash
forge create <deployedName> --rpc-url=<RPC_URL> --private-key=<PRIVATE_KEY> --constructor-args <args...> --verify

i.e.:

forge create StringNFT --rpc-url=$RPC_URL --private-key=$PRIVATE_KEY --constructor-args StringTestNFT STR721t https://stringtesturi.xyz/nft/ --verify
```
verify a contract deployed to fuji (instead of using a script for whatever reason)
```bash
forge verify-contract --chain-id <chainID> --num-of-optimizations <optimizations> -- constructor-args $(cast abi encode "constructor(<types...>)" <args...>) --compiler-version v0.<Major>.<minor>+commit.<8HexDigitsOfCommit> <contract addr> <contract file>:<contract name> <snowtrace api key>

i.e.:

forge verify-contract --chain-id 43113 --num-of-optimizations 1000 --constructor-args $(cast abi-encode "constructor(string,string,string)" "StringTestNFT" "STR721t" "https://stringtesturi.xyz/nft/") --compiler-version v0.8.13+commit.abaa5c0e 0x861af9ed4fee884e5c49e9ce444359fe3631418b src/StringNFT.sol:StringNFT $SNOWTRACE_API_KEY
```
Create temporary environment variables for passing into console commands
```bash
export ETHERSCAN_API_KEY=HAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHA
```
Update all libraries
```bash
forge update
```
Run a custom solidity script (i.e. Withdraw.sol)
```bash
forge script Withdraw --rpc-url $FUJI_RPC_URL --private-key $PRIVATE_KEY --broadcast -vvv
```

## Manual Setup
If you would prefer to set up project dependencies manually, they should be done in this order:

[Install Foundry](https://book.getfoundry.sh/getting-started/installation.html)

run foundryUp

[Install Python](https://www.python.org/downloads/)

use pip3 to install [solc-select](https://github.com/crytic/solc-select)

use solc-select to install solc 0.8.13

use solc-select to use solc 0.8.13

use pip3 to install [slither-analyzer](https://github.com/crytic/slither)

## Troubleshooting Manual Setup
Slither may think you are running a different version of solc than what solc-select has selected.  If this is the case, use solc-select to uninstall and reinstall 0.8.13.