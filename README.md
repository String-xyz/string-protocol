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
Update all libraries
```bash
scripts/updateLibs.sh
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