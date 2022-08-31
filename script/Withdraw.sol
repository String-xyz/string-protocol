// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "src/StringNFT.sol";
import "forge-std/Script.sol";
import "forge-std/Vm.sol";

// To run this:
// % source .env
// % forge script Withdraw --rpc-url $FUJI_RPC_URL --private-key $PRIVATE_KEY --broadcast -vvv
// % forge script Withdraw --rpc-url $MUMBAI_RPC_URL --private-key $PRIVATE_KEY --broadcast -vvv
// % forge script Withdraw --rpc-url $GOERLI_RPC_URL --private-key $PRIVATE_KEY --broadcast -vvv

contract Withdraw is Script {
    function run() external {
        address contractAddr; // Address of StringNFT
        // Detect network
        if (block.chainid == 43113) { // Fuji
            contractAddr = 0x41e11fF9F71f51800F67cb913eA6Bc59d3F126Aa;
        } else if (block.chainid == 80001) { // Mumbai
            contractAddr = 0x41E60F5118785755b6337c94F301017c42BaAA9C;
        } else if (block.chainid == 5) { // Goerli
            contractAddr = 0x7535f48fC7A44531e9Ef0593815140E6bdF9EF65;
        }

        address payable owner = payable(msg.sender); // Our address, recipient of withdrawn funds
        StringNFT c = StringNFT(contractAddr); // Get handle to live contract

        vm.startBroadcast();
        c.withdrawPayments(owner);
        vm.stopBroadcast();
    }
}
