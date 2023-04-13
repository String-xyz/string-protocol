// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "solmate/tokens/ERC721.sol";

import "openzeppelin/utils/Strings.sol";
import "openzeppelin/access/Ownable.sol";

error MintPriceNotPaid();
error MaxSupply();
error NonExistentTokenURI();
error WithdrawTransfer();

contract StringNFT is ERC721, Ownable {

    using Strings for uint256;
    string public baseURI;
    uint256 public currentTokenId;
    uint256 public constant TOTAL_SUPPLY = 100_000;
    uint256 public constant MINT_PRICE = 0.08 ether;
    mapping(address => uint256[]) private _ownedIds;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _baseURI
    ) ERC721(_name, _symbol) {
        baseURI = _baseURI;
    }

    function mintTo(address recipient) public payable returns (uint256) {
        if (msg.value != MINT_PRICE) {
            revert MintPriceNotPaid();
        }
        uint256 newTokenId = ++currentTokenId;
        if (newTokenId > TOTAL_SUPPLY) {
            revert MaxSupply();
        }
        _safeMint(recipient, newTokenId);
        uint256[] storage collection = _ownedIds[recipient];
        collection.push(newTokenId);
        return newTokenId;
    }

    function mintTo(address[] memory recipients) public payable returns (uint256[] memory) {
        if (msg.value != MINT_PRICE * recipients.length) {
            revert MintPriceNotPaid();
        }
        uint256[] memory tokenIds = new uint256[](recipients.length);
        for (uint256 i = 0; i < recipients.length; i++) {
            uint256 newTokenId = ++currentTokenId;
            if (newTokenId > TOTAL_SUPPLY) {
                revert MaxSupply();
            }
            _safeMint(recipients[i], newTokenId);
            uint256[] storage collection = _ownedIds[recipients[i]];
            collection.push(newTokenId);
            tokenIds[i] = newTokenId;
        }
        return tokenIds;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        if (ownerOf(tokenId) == address(0)) {
            revert NonExistentTokenURI();
        }
        uint256 mod = (tokenId % 10) + 1;
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, "Demo_Character_", mod.toString(), ".png"))
                : "";
    }

    function withdrawPayments(address payable payee) external onlyOwner {
        uint256 balance = address(this).balance;
        (bool transferTx, ) = payee.call{value: balance}("");
        if (!transferTx) {
            revert WithdrawTransfer();
        }
    }

    function getOwnedIDs(address owner) external view returns (uint256[] memory) {
        return _ownedIds[owner];
    }
}
