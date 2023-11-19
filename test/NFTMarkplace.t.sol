// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/NFTMarketplace.sol";

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "forge-std/console.sol";


contract MyNFT is ERC721URIStorage {

    uint256 public tokenId = 0;

    constructor() ERC721("MyNFT", "MNFT") {}

    function mintNFT(address recipient, string memory tokenURI) public returns (uint256) {
        tokenId++;
        uint256 newItemId = tokenId;
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);
        return newItemId;
    }
}

contract NFTMarketplaceTest is Test {

    NFTMarketplace marketplace;
    MyNFT nft;
    uint256 price = 20;
    uint256 tokenId;

    function setUp() public {

        marketplace = new NFTMarketplace();
        nft = new MyNFT();

        tokenId = nft.mintNFT(address(this), "image url");
    }

    function testSellNFT() public {
        marketplace.sell(1, address(nft), 1, price, block.timestamp + 150);

        assertTrue(marketplace.orders(1).seller == address(this));
        assertTrue(marketplace.orders(1).isSold == false);
        assertTrue(marketplace.orders(1).price == 1);
        assertTrue(marketplace.orders(1).nftContract == address(this));
        assertTrue(marketplace.orders(1).tokenId == 1);
        assertTrue(marketplace.orders(1).expiresAt > block.timestamp);
    }


}