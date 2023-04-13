// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.13;

import {StringNFT} from "../StringNFT.sol";
import {ERC721TokenReceiver} from "solmate/tokens/ERC721.sol";


import "forge-std/Test.sol";
import "forge-std/console2.sol";
import "ds-test/test.sol";
import "forge-std/Vm.sol";

contract StringContractTest is Test {
    using stdStorage for StdStorage;

    StringNFT public stringNFT;
    address public alice;
    address public bob;

    function setUp() public {
        stringNFT = new StringNFT("String NFT Test", "STRNFT1", "baxaxaxaxaxa");
        alice = vm.addr(1);
        bob = vm.addr(2);
    }

    function testFailNoMintPricePaid() public {
        stringNFT.mintTo(alice);
    }

    function testMintPricePaid() public {
        stringNFT.mintTo{value: 0.08 ether}(alice);
    }

    function testFailMaxSupplyReached() public {
        // Get data location of currentTokenId
        uint256 slot = stdstore.target(address(stringNFT)).sig("currentTokenId()").find();
        // Cast slot to raw bytes32
        bytes32 loc = bytes32(slot);
        // Encode data we wish to write
        bytes32 mockedCurrentTokenId = bytes32(abi.encode(100000));
        // Write the data to the string NFT in the desired location
        vm.store(address(stringNFT), loc, mockedCurrentTokenId);
        // Try to exceed max value
        stringNFT.mintTo{value: 0.08 ether}(address(alice));
    }

    function testFailMintToZeroAddress() public {
        stringNFT.mintTo{value: 0.08 ether}(address(0));
    }

    function testNewMintOwnerRegistered() public {
        stringNFT.mintTo{value: 0.08 ether}(address(alice));

        // get storage slot of a variable in our contract
        uint256 slotOfNewOwner = stdstore.
        target(address(stringNFT)) // contract addr represents storage we wish to target
        .sig(stringNFT.ownerOf.selector) // ownerOf is the function we wish to call the signature of
        .with_key(1) // 1 is the ID passed into the mapping ownerOf
        .find(); // return the slot number (as opposed to read or write)

        // uint160 is a raw addr, use vm.load to read into it
        uint160 ownerOfTokenIdOne = uint160(uint256((
            vm.load(
                address(stringNFT), // address we wish to read from
                bytes32(abi.encode(slotOfNewOwner)))))); // byte-encoded storage 'slot' we wish to read
        assertEq(address(ownerOfTokenIdOne), address(alice));
    }

    function testBalanceIncremented() public { 
        stringNFT.mintTo{value: 0.08 ether}(address(alice));
        uint256 slotBalance = stdstore
            .target(address(stringNFT))
            .sig(stringNFT.balanceOf.selector)
            .with_key(address(alice))
            .find();
        
        uint256 balanceFirstMint = uint256(vm.load(address(stringNFT), bytes32(slotBalance)));
        assertEq(balanceFirstMint, 1);

        stringNFT.mintTo{value: 0.08 ether}(address(alice));
        uint256 balanceSecondMint = uint256(vm.load(address(stringNFT), bytes32(slotBalance)));
        assertEq(balanceSecondMint, 2);
    }

    function testSafeContractReceiver() public {
        Receiver receiver = new Receiver();
        stringNFT.mintTo{value: 0.08 ether}(address(receiver));
         uint256 slotBalance = stdstore
            .target(address(stringNFT))
            .sig(stringNFT.balanceOf.selector)
            .with_key(address(receiver))
            .find();

        // Get the balance of the receiver contract
        uint256 balance = uint256(vm.load(address(stringNFT), bytes32(slotBalance)));
        assertEq(balance, 1);
    }
    
    function testFailUnSafeContractReceiver() public {
        address notAReceiver;
        // etch sets the bytecode of notAReceiver to bytes("mock code")
        vm.etch(notAReceiver, bytes("mock code"));
        stringNFT.mintTo{value: 0.08 ether}(notAReceiver);
    }

    function testWithdrawalWorksAsOwner() public {
        // Mint an NFT, sending eth to the contract
        Receiver receiver = new Receiver();
        address payable payee = payable(address(0x1337));
        uint256 priorPayeeBalance = payee.balance;

        // Mint one
        stringNFT.mintTo{value: stringNFT.MINT_PRICE()}(address(receiver));

        // Check that the ETH balance of the contract is correct
        assertEq(address(stringNFT).balance, stringNFT.MINT_PRICE());
        uint256 nftBalance = address(stringNFT).balance;

        // Withdraw the balance and assert it was transferred
        stringNFT.withdrawPayments(payee);
        assertEq(payee.balance, priorPayeeBalance + nftBalance);
    }

    function testWithdrawalFailsAsNotOwner() public {
        // Mint an NFT, sending eth to the contract
        Receiver receiver = new Receiver();
        stringNFT.mintTo{value: stringNFT.MINT_PRICE()}(address(receiver));

        // Check that the ETH balance of the contract is correct
        assertEq(address(stringNFT).balance, stringNFT.MINT_PRICE());

        // Confirm that a non-owner cannot withdraw
        vm.expectRevert("Ownable: caller is not the owner");
        vm.startPrank(address(0xd3ad));
        stringNFT.withdrawPayments(payable(address(0xd3ad)));
        vm.stopPrank();
    }

    function testMintReturnsIndices() public {
        // Mint three NFTs
        Receiver receiver = new Receiver();
        stringNFT.mintTo{value: stringNFT.MINT_PRICE()}(address(receiver));
        stringNFT.mintTo{value: stringNFT.MINT_PRICE()}(address(0xd3ad));
        stringNFT.mintTo{value: stringNFT.MINT_PRICE()}(address(receiver));
    
        uint256[] memory owned = stringNFT.getOwnedIDs(address(receiver));
        assertEq(owned.length, 2);
        assertEq(owned[0], 1);
        assertEq(owned[1], 3);
    }

    function testMintReturnsMultipleIndices() public {
        // Mint three NFTs
        Receiver receiver = new Receiver();
        address[] memory addresses = new address[](3);
        addresses[0] = address(receiver);
        addresses[1] = address(0xd3ad);
        addresses[2] = address(receiver);
        uint256[] memory minted = stringNFT.mintTo{value: stringNFT.MINT_PRICE() * 3}(addresses);

        assertEq(minted[0], 1);
        assertEq(minted[1], 2);
        assertEq(minted[2], 3);
    }
}

contract Receiver is ERC721TokenReceiver {
    function onERC721Received(
        address operator,
        address from,
        uint256 id,
        bytes calldata data
    ) override external returns (bytes4){
        return this.onERC721Received.selector;
    }
}