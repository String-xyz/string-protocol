// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "src/StringExchange.sol";
import "src/StringToken.sol";
import "forge-std/Script.sol";

// This script will deploy and verify a StringExchange smart contract as well as Payment and Exchange tokens for it

// To run this:
// % source .env
// % forge script DeployExchange --rpc-url $FUJI_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $SNOWTRACE_KEY -vvv

// If auto-verification fails (on Mumbai for example):
// % forge verify-contract --chain-id 80001 --num-of-optimizations 1000 --constructor-args $(cast abi-encode "constructor(string,string,string)" "String_Demo_NFT" "STRDEMO" "ipfs://bafybeibtmy26mac47n5pp6srds76h74riqs76erw24p5yvdhmwu7pxlcx4/") --compiler-version v0.8.13+commit.abaa5c0e 0x41E60F5118785755b6337c94F301017c42BaAA9C src/StringNFT.sol:StringNFT $POLYGONSCAN_KEY

contract DeployExchange is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy a new NFT contract
        // Deploy Tokens
        StringToken usdc = new StringToken("USDc Token", "USDc", 1000000000 ether);
        StringToken gem = new StringToken("Gem Token", "GEMZ", 1000000000 ether);
        StringExchange exchange = new StringExchange(usdc, gem);
        gem.transfer(address(exchange), 1000000000 ether);
        exchange.setExchangeRate(0.5 ether);
        
        console2.log("USDC Deployed to: ", address(usdc));
        console2.log("GEM Deployed to: ", address(gem));
        console2.log("EXCHANGE Deployed to: ", address(exchange));

        // Transfer ownership to dev hotwallet
        usdc.transferOwnership(0x44A4b9E2A69d86BA382a511f845CbF2E31286770);
        gem.transferOwnership(0x44A4b9E2A69d86BA382a511f845CbF2E31286770);
        exchange.transferOwnership(0x44A4b9E2A69d86BA382a511f845CbF2E31286770);

        // Do anything else

        vm.stopBroadcast();
    }
}
