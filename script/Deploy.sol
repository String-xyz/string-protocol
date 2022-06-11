// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "src/StringNFT.sol";
import "forge-std/Script.sol";

// This script will deploy and verify a StringNFT smart contract and mint the first one to the deployer!

// To run this:
// % source .env
// % forge script Deploy --rpc-url $FUJI_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $SNOWTRACE_KEY -vvv

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy a new NFT contract
        StringNFT nft = new StringNFT("String_Test_NFT", "STRNFTt", "https://stringtesturi.xyz/nft/");
        console2.log("NFT Deployed to: ", address(nft));

        // Mint the first one to ourselves
        nft.mintTo{value: 0.08 ether}(msg.sender);

        // Do anything else

        vm.stopBroadcast();
    }
}
