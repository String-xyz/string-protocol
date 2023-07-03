// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "openzeppelin/token/ERC20/IERC20.sol";
import "openzeppelin/access/Ownable.sol";

contract StringExchange is Ownable {
    IERC20 public paymentToken;
    IERC20 public exchangeToken;
    uint256 public exchangeRate;

    constructor(IERC20 _paymentToken, IERC20 _exchangeToken) {
        paymentToken = _paymentToken;
        exchangeToken = _exchangeToken;
    }

    function setExchangeRate(uint256 _exchangeRate) public onlyOwner {
        exchangeRate = _exchangeRate;
    }

    function exchange(uint256 paymentTokenAmount) public {
        require(paymentToken.transferFrom(msg.sender, address(this), paymentTokenAmount), "Payment token transfer failed.");
        
        uint256 exchangeTokenAmount = paymentTokenAmount * exchangeRate / 1 ether;
        require(exchangeToken.balanceOf(address(this)) >= exchangeTokenAmount, "Not enough exchange tokens in contract.");
        
        exchangeToken.transfer(msg.sender, exchangeTokenAmount);
    }

    function withdrawPaymentTokens(address recipient, uint256 amount) public onlyOwner {
        require(paymentToken.balanceOf(address(this)) >= amount, "Not enough payment tokens in contract.");
        paymentToken.transfer(recipient, amount);
    }
}
