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

// If auto-verification fails (on Mumbai for example):
// % forge verify-contract --chain-id 80001 --num-of-optimizations 1000 --constructor-args $(cast abi-encode "constructor(string,string,string)" "String_Demo_NFT" "STRDEMO" "ipfs://bafybeibtmy26mac47n5pp6srds76h74riqs76erw24p5yvdhmwu7pxlcx4/") --compiler-version v0.8.13+commit.abaa5c0e 0x41E60F5118785755b6337c94F301017c42BaAA9C src/StringNFT.sol:StringNFT $POLYGONSCAN_KEY
// Or if it fails on Goerli for some reason:
// % forge verify-contract --chain-id 5 --num-of-optimizations 1000 --constructor-args $(cast abi-encode "constructor(string,string,string)" "String_Demo_NFT" "STRDEMO" "ipfs://bafybeibtmy26mac47n5pp6srds76h74riqs76erw24p5yvdhmwu7pxlcx4/") --compiler-version v0.8.13+commit.abaa5c0e 0x7535f48fC7A44531e9Ef0593815140E6bdF9EF65 src/StringNFT.sol:StringNFT $ETHERSCAN_KEY

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy a new NFT contract
        StringNFT nft = new StringNFT("String_Demo_NFT", "STRDEMO", "ipfs://bafybeibtmy26mac47n5pp6srds76h74riqs76erw24p5yvdhmwu7pxlcx4/");
        console2.log("NFT Deployed to: ", address(nft));

        // Mint the first one to ourselves
        nft.mintTo{value: 0.08 ether}(msg.sender);

        // Do anything else

        vm.stopBroadcast();
    }
}
