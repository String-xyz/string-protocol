// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "src/StringNFT.sol";
import "forge-std/Script.sol";

// This script will deploy and verify a StringNFT smart contract and mint the first one to the deployer!

// To run this:
// % source .env
// % forge script Deploy --rpc-url $FUJI_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $SNOWTRACE_KEY -vvv
// % forge script Deploy --rpc-url $MUMBAI_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $POLYGONSCAN_KEY -vvv
// % forge script Deploy --rpc-url $GOERLI_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_KEY -vvv
// % forge script Deploy --rpc-url $NITRO_GOERLI_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ARBITRUM_NOVA_KEY -vvv

// If auto-verification fails (on Mumbai for example):
// % forge verify-contract --chain-id 80001 --num-of-optimizations 1000 --constructor-args $(cast abi-encode "constructor(string,string,string)" "String_Demo_NFT" "STRDEMO" "ipfs://bafybeibtmy26mac47n5pp6srds76h74riqs76erw24p5yvdhmwu7pxlcx4/") --compiler-version v0.8.13+commit.abaa5c0e 0x41E60F5118785755b6337c94F301017c42BaAA9C src/StringNFT.sol:StringNFT $POLYGONSCAN_KEY
// Or if it fails on Goerli for some reason:
// % forge verify-contract --chain-id 5 --num-of-optimizations 1000 --constructor-args $(cast abi-encode "constructor(string,string,string)" "String_Demo_NFT" "STRDEMO" "ipfs://bafybeibtmy26mac47n5pp6srds76h74riqs76erw24p5yvdhmwu7pxlcx4/") --compiler-version v0.8.13+commit.abaa5c0e 0x7535f48fC7A44531e9Ef0593815140E6bdF9EF65 src/StringNFT.sol:StringNFT $ETHERSCAN_KEY
// Or if it fails on Arbitrum Goerli because of a bugfix which was just merged to foundry yesterday and you don't have the installer for that:
// % forge verify-contract --chain-id 421613 --num-of-optimizations 1000 --constructor-args $(cast abi-encode "constructor(string,string,string)" "Ex Populus Demo NFT" "ExPopDemo" "ipfs://bafybeieqi56p6vlxofj6wkoort2m5r72ajhtikpzo53wnyze5isvn34fze/") --compiler-version v0.8.13+commit.abaa5c0e 0xFFa8cc8530982A64Ef0E3e97554A4581b4Cd6314 src/StringNFT.sol:StringNFT $ETHERSCAN_KEY

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy a new NFT contract
        StringNFT nft = new StringNFT("String Demo NFT", "STRDEMO", "ipfs://bafybeieqi56p6vlxofj6wkoort2m5r72ajhtikpzo53wnyze5isvn34fze/");
        
        // StringNFT nft = new StringNFT("Ex Populus Demo NFT", "ExPopDemo", "ipfs://bafybeieqi56p6vlxofj6wkoort2m5r72ajhtikpzo53wnyze5isvn34fze/");
        
        console2.log("NFT Deployed to: ", address(nft));

        // Transfer ownership to production hotwallet
        // nft.transferOwnership(0xDceA542e96DE24e9f89BF9635ebBe4a0CaCE30aa);

        // Transfer ownership to dev hotwallet
        nft.transferOwnership(0xb4D168E584dA81B6712412472F163bcf0Af5171C);

        // Do anything else

        vm.stopBroadcast();
    }
}
