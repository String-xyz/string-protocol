// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.13;

import {StringToken} from "../StringToken.sol";


import "forge-std/Test.sol";
import "forge-std/console2.sol";
import "ds-test/test.sol";
import "forge-std/Vm.sol";

contract StringTokenTest is Test {
    using stdStorage for StdStorage;

    StringToken public stringToken;
    address public alice;
    address public bob;

    function setUp() public {
        stringToken = new StringToken("USDc Token", "USDc", 1000000000 ether);
        alice = vm.addr(1);
        bob = vm.addr(2);
    }

    function testFailMintNotOwner() public {
        // Confirm that a non-owner cannot mint
        vm.startPrank(alice);
        stringToken.mint(alice, 1 ether);
        vm.stopPrank();
    }

    function testMintOwner() public {
        stringToken.mint(address(0xd3ad), 1 ether);
    }

    function testFailBurnNotOwner() public {
        // Confirm that a non-owner cannot mint
        vm.startPrank(alice);
        stringToken.burn(bob, 1 ether);
        vm.stopPrank();
    }

    function testBurnOwner() public {
        stringToken.mint(msg.sender, 1 ether);
        stringToken.burn(msg.sender, 1 ether);
    }

}