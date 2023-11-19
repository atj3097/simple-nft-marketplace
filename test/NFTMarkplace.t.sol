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
        assertTrue(price == 20);
        assertTrue(nftContract == address(nft));
        assertTrue(tokenId == 1);
        assertTrue(expiresAt > block.timestamp);
    }

    function testPurchaseNFT() public payable {
        address fakeAddress = address(0x5);
        address fakeSeller = address(0x6);

        vm.prank(fakeSeller);
        uint256 tokenTest = nft.mintNFT(fakeSeller, "image url");

        vm.prank(fakeSeller);
        IERC721(address(nft)).approve(address(marketplace), tokenTest);

        vm.prank(fakeSeller);
        marketplace.sell(2, address(nft), tokenTest, price, block.timestamp + 150);

        (, address seller, bool isSoldBefore, , , , uint256 expiresAt) = marketplace.orders(2);
        assertTrue(seller == fakeSeller);
        assertTrue(isSoldBefore == false);
        assertTrue(expiresAt > block.timestamp);

        vm.deal(fakeAddress, 100);
        vm.prank(fakeAddress);
        vm.warp(block.timestamp + 100);
        marketplace.purchase{value: 20}(2);

        (, , bool isSoldAfter, , , , ) = marketplace.orders(2); // Use consistent order ID
        assertTrue(isSoldAfter == true);
    }

    function testCancelOrder() public {
        address fakeSeller = address(0x6);

        vm.prank(fakeSeller);
        uint256 tokenTest = nft.mintNFT(fakeSeller, "image url");

        vm.prank(fakeSeller);
        IERC721(address(nft)).approve(address(marketplace), tokenTest);

        uint256 orderId = 1;
        uint256 price = 10 ether;
        uint256 expiration = block.timestamp + 1 days;
        vm.prank(fakeSeller);
        marketplace.sell(orderId, address(nft), tokenTest, price, expiration);

        (uint256 id, address seller, bool isSold, , , , uint256 expiresAt) = marketplace.orders(orderId);
        assertTrue(id == orderId);
        assertTrue(seller == fakeSeller);
        assertTrue(isSold == false);
        assertTrue(expiresAt == expiration);

        vm.prank(fakeSeller);
        marketplace.cancel(orderId);

        (id, seller, isSold, , , , expiresAt) = marketplace.orders(orderId);
        assertTrue(seller == address(0));
    }





}