// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../src/blockchain_survival_of_the_fittest/Creature.sol";
import "../src/blockchain_survival_of_the_fittest/Setup.sol";
import "../lib/forge-std/src/Script.sol";
import "../lib/forge-std/src/console.sol";



contract SurvivalOfTheFittestSolution is Script {
  Creature public level = Creature(payable(0xCE206469Cbdf8a2c499A4FE566D9e899cCD63A6F));
  Setup public level_setup = Setup(payable(0x555f4200ba7D49D435A41157F300E70346B8050A));

  function run() external { 
    vm.startBroadcast(vm.envUint("PRIVATE_KEY_SURVIVAL_OF_THE_FITTEST"));
    console.log("Level Solved?", level_setup.isSolved());
    console.log("Life Points: ", level.lifePoints());

    level.strongAttack(20);
    level.loot();
    
    console.log("Life Points: ", level.lifePoints());
    console.log("Level Solved?", level_setup.isSolved());

    vm.stopBroadcast();

  }
} 
