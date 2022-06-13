// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "src/StringNFT.sol";
import "forge-std/Script.sol";

// To run this:
// % source .env
// % forge script Withdraw --rpc-url $FUJI_RPC_URL --private-key $PRIVATE_KEY --broadcast -vvv

contract Withdraw is Script {
    function run() external {
        address contractAddr = 0x861aF9Ed4fEe884e5c49E9CE444359fe3631418B; // Address of StringNFT
        address payable owner = payable(msg.sender); // Our address
        StringNFT c = StringNFT(contractAddr); // Talk to 
        vm.startBroadcast();
        c.withdrawPayments(owner);
        vm.stopBroadcast();
    }
}
