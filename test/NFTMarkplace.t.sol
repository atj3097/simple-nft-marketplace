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
        IERC721(address(nft)).approve(address(marketplace), 1);
        marketplace.sell(1, address(nft), 1, price, block.timestamp + 150);

        (, address seller, bool isSold, uint256 price, address nftContract, uint256 tokenId, uint256 expiresAt) = marketplace.orders(1);

        assertTrue(seller == address(this));
        assertTrue(isSold == false);
        assertTrue(price == 1);
        assertTrue(nftContract == address(this));
        assertTrue(tokenId == 1);
        assertTrue(expiresAt > block.timestamp);
    }


}