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
            contractAddr = 0x861aF9Ed4fEe884e5c49E9CE444359fe3631418B;
        } else if (block.chainid == 80001) { // Mumbai
            contractAddr = 0xFFa8cc8530982A64Ef0E3e97554A4581b4Cd6314;
        } else if (block.chainid == 5) { // Goerli
            contractAddr = 0xFFa8cc8530982A64Ef0E3e97554A4581b4Cd6314;
        }

        address payable owner = payable(msg.sender); // Our address, recipient of withdrawn funds
        StringNFT c = StringNFT(contractAddr); // Get handle to live contract

        vm.startBroadcast();
        c.withdrawPayments(owner);
        vm.stopBroadcast();
    }
}
