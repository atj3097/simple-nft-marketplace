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
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NFTMarketplace {

    struct Order {
        uint256 id;
        address seller;
        bool isSold;
        uint256 price;
        address nftContract;
        uint256 tokenId;
        uint256 expiresAt;
    }

    mapping(uint256 => Order) public orders;

    function sell(uint256 id, address nftContract, uint256 tokenId, uint256 price, uint256 expiration) external {
        require(price > 0, "Price must be at least 1 wei");
        require(orders[id].isSold == false, "This order has already been sold");
        require(orders[id].seller == address(0), "This order has already been created");
        require(IERC721(nftContract).ownerOf(tokenId) == msg.sender, "You are not the owner of this NFT");
        require(expiration > block.timestamp, "Expiration must be in the future");
        orders[id] = Order(id, msg.sender, false, price, nftContract, tokenId, expiration);
        IERC721(nftContract).approve(address(this), tokenId);
    }

    function purchase(uint256 id) external payable {
        require(orders[id].isSold == false, "This order has already been sold");
        require(orders[id].seller != address(0), "This order does not exist");
        require(orders[id].expiresAt > block.timestamp, "This order has expired");
        require(msg.value == orders[id].price, "You must pay the exact price");
        orders[id].isSold = true;
        IERC721(orders[id].nftContract).transferFrom(orders[id].seller, msg.sender, orders[id].tokenId);
        payable(orders[id].seller).transfer(msg.value);
    }

    function cancel(uint256 id) external {
        require(orders[id].seller == msg.sender, "You are not the seller of this order");
        require(orders[id].isSold == false, "This order has already been sold");
        delete orders[id];
    }




}


