// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract OasisReverseAuction is ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _auctionIds;

    enum AuctionStatus { Active, Concluded, Cancelled }

    struct Auction {
        uint256 id;
        address payable buyer;
        string description;
        uint256 maxPrice;
        uint256 lowestBid;
        address payable lowestBidder;
        uint256 endTime;
        AuctionStatus status;
    }

    struct Bid {
        address bidder;
        uint256 amount;
    }

    mapping(uint256 => Auction) public auctions;
    mapping(uint256 => Bid[]) public auctionBids;

    event AuctionCreated(uint256 indexed auctionId, address indexed buyer, string description, uint256 maxPrice, uint256 endTime);
    event BidPlaced(uint256 indexed auctionId, address indexed bidder, uint256 amount);
    event AuctionConcluded(uint256 indexed auctionId, address indexed winner, uint256 winningBid);
    event AuctionCancelled(uint256 indexed auctionId);

    function createAuction(string memory _description, uint256 _maxPrice, uint256 _duration) external payable {
        require(msg.value >= _maxPrice, "Insufficient funds for max price");
        
        _auctionIds.increment();
        uint256 newAuctionId = _auctionIds.current();
        
        Auction storage newAuction = auctions[newAuctionId];
        newAuction.id = newAuctionId;
        newAuction.buyer = payable(msg.sender);
        newAuction.description = _description;
        newAuction.maxPrice = _maxPrice;
        newAuction.lowestBid = _maxPrice;
        newAuction.endTime = block.timestamp + _duration;
        newAuction.status = AuctionStatus.Active;

        emit AuctionCreated(newAuctionId, msg.sender, _description, _maxPrice, newAuction.endTime);
    }

    function placeBid(uint256 _auctionId, uint256 _bidAmount) external {
        Auction storage auction = auctions[_auctionId];
        require(auction.status == AuctionStatus.Active, "Auction is not active");
        require(block.timestamp < auction.endTime, "Auction has ended");
        require(_bidAmount < auction.lowestBid, "Bid must be lower than current lowest bid");
        require(_bidAmount <= auction.maxPrice, "Bid cannot exceed max price");

        auction.lowestBid = _bidAmount;
        auction.lowestBidder = payable(msg.sender);

        auctionBids[_auctionId].push(Bid(msg.sender, _bidAmount));

        emit BidPlaced(_auctionId, msg.sender, _bidAmount);
    }

    function concludeAuction(uint256 _auctionId) external nonReentrant {
        Auction storage auction = auctions[_auctionId];
        require(msg.sender == auction.buyer, "Only buyer can conclude auction");
        require(auction.status == AuctionStatus.Active, "Auction is not active");
        require(block.timestamp >= auction.endTime, "Auction has not ended yet");

        auction.status = AuctionStatus.Concluded;

        if (auction.lowestBidder != address(0)) {
            uint256 paymentAmount = auction.lowestBid;
            auction.lowestBidder.transfer(paymentAmount);
            payable(msg.sender).transfer(auction.maxPrice - paymentAmount);
        } else {
            payable(msg.sender).transfer(auction.maxPrice);
        }

        emit AuctionConcluded(_auctionId, auction.lowestBidder, auction.lowestBid);
    }

    function cancelAuction(uint256 _auctionId) external {
        Auction storage auction = auctions[_auctionId];
        require(msg.sender == auction.buyer, "Only buyer can cancel auction");
        require(auction.status == AuctionStatus.Active, "Auction is not active");

        auction.status = AuctionStatus.Cancelled;
        payable(msg.sender).transfer(auction.maxPrice);

        emit AuctionCancelled(_auctionId);
    }

    function getAuction(uint256 _auctionId) external view returns (Auction memory) {
        return auctions[_auctionId];
    }

    function getAuctionBids(uint256 _auctionId) external view returns (Bid[] memory) {
        return auctionBids[_auctionId];
    }
}