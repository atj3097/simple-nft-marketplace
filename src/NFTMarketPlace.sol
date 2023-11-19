// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
/*
Sellers can sell() their NFT while specifying a price and expiration. Instead of
depositing the NFT into the contract, they give the contract approval to withdraw
it from them. If a buyer comes along and pays the specified price before the
expiration, then the NFT is transferred from the seller to the buyer and the
buyer’s ether is transferred to the seller.

The seller can cancel() the sale at any time.

Corner cases:

What if the seller lists the same NFT twice? This can theoretically happen since
they don't transfer the NFT to the marketplace.
*/


contract NFTMarketplace {

    struct Order {
        uint256 id;
        address seller;
        bool isSold;
        uint256 price;
        address nftContract;
        uint256 tokenId;
    }

    mapping(uint256 => Order) public orders;

    function sell(uint256 id, address nftContract, uint256 tokenId, uint256 price) external {
        require(price > 0, "Price must be at least 1 wei");
        require(orders[id].isSold == false, "This order has already been sold");
        require(orders[id].seller == address(0), "This order has already been created");
        orders[id] = Order(id, msg.sender, false, price, nftContract, tokenId);
    }




}


