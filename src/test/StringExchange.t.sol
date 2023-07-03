// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.13;

import {StringToken} from "../StringToken.sol";
import {StringExchange} from "../StringExchange.sol";


import "forge-std/Test.sol";
import "forge-std/console2.sol";
import "ds-test/test.sol";
import "forge-std/Vm.sol";

contract StringExchangeTest is Test {
    using stdStorage for StdStorage;

    StringToken public paymentToken;
    StringToken public exchangeToken;
    StringExchange public exchange;
    address public alice;
    address public bob;

    function setUp() public {
        paymentToken = new StringToken("USDc Token", "USDc", 1000000000 ether);
        exchangeToken = new StringToken("Gem Token", "GEMZ", 1000000000 ether);
        exchange = new StringExchange(paymentToken, exchangeToken);
        exchangeToken.transfer(address(exchange), 1000000000 ether);
        exchange.setExchangeRate(0.5 ether);
        alice = vm.addr(1);
        bob = vm.addr(2);
    }

    function testExchangeInitialBalance() public {
        assertEq(exchangeToken.balanceOf(address(exchange)), 1000000000 ether);
        assertEq(paymentToken.balanceOf(address(exchange)), 0 ether);
    }

    function testExchangeToken() public {
        // Confirm that we can exchange 2 USD for 1 Gem
        paymentToken.mint(alice, 2 ether);
        vm.startPrank(alice);
        paymentToken.approve(address(exchange), 2 ether);
        exchange.exchange(2 ether);
        vm.stopPrank();
        assertEq(exchangeToken.balanceOf(alice), 1 ether);
    }

    function testExchangeTokenAddsBalance() public {
        // Confirm that we can exchange 2 USD for 1 Gem
        paymentToken.mint(alice, 2 ether);
        vm.startPrank(alice);
        paymentToken.approve(address(exchange), 2 ether);
        exchange.exchange(2 ether);
        vm.stopPrank();
        assertEq(exchangeToken.balanceOf(alice), 1 ether);
        assertEq(paymentToken.balanceOf(address(exchange)), 2 ether);
    }

    function testOwnerWithdraw() public {
        // Confirm that the owner can withdraw
        paymentToken.mint(alice, 2 ether);
        vm.startPrank(alice);
        paymentToken.approve(address(exchange), 2 ether);
        exchange.exchange(2 ether);
        vm.stopPrank();
        assertEq(exchangeToken.balanceOf(alice), 1 ether);
        exchange.withdrawPaymentTokens(msg.sender, 2 ether);
        assertEq(paymentToken.balanceOf(msg.sender), 2 ether);
    }

    function testWithdrawNotOwner() public {
        vm.expectRevert("Ownable: caller is not the owner");
        vm.startPrank(alice);
        exchange.withdrawPaymentTokens(alice, 2 ether);
        vm.stopPrank();
    }

}