// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.13;

import {StringContract} from "../StringContract.sol";

import "forge-std/Test.sol";
import "forge-std/console2.sol";

contract StringContractTest is Test {
    using stdStorage for StdStorage;

    StringContract public stringContract;
    address public alice;
    address public bob;

    function setUp() public {
        stringContract = new StringContract("Test Contract 1");
        alice = vm.addr(1);
        bob = vm.addr(2);
    }

    function testAdminAllowOnboarder() public {
        stringContract.adminAllowOnboarder(alice);
    }

    function testCannotOnboardIfNotDeployer() public {
        vm.prank(alice);
        vm.expectRevert("!deployer");
        stringContract.adminAllowOnboarder(alice);
    }

    function testAdminDisableOnboarder() public {
        stringContract.adminAllowOnboarder(alice);
        stringContract.adminDisableOnboarder(alice);
    }

    function testCannotOffboardIfNotDeployer() public {
        stringContract.adminAllowOnboarder(alice);
        vm.prank(alice);
        vm.expectRevert("!deployer");
        stringContract.adminDisableOnboarder(alice);
    }

    function testOnboardUser() public {
        stringContract.adminAllowOnboarder(alice);
        vm.prank(alice);
        stringContract.onboardUser(bob, 4);
    }

    function testCannotOnboardUserIfNotOnboarder() public {
        stringContract.adminAllowOnboarder(alice);
        vm.prank(bob);
        vm.expectRevert("!rights");
        stringContract.onboardUser(bob, 4);
    }

    function testIsUserOnboarded(uint256 risk) public {
        vm.assume(risk > 0);
        stringContract.adminAllowOnboarder(alice);
        vm.startPrank(alice);
        stringContract.onboardUser(bob, risk);
        uint256 onboarded = stringContract.isUserOnboarded(bob);
        assertEq(onboarded, risk);
    }
}