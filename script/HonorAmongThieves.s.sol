// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../src/blockchain_honor_among_thieves/Rivals.sol";
import "../src/blockchain_honor_among_thieves/Setup.sol";
import "../lib/forge-std/src/Script.sol";
import "../lib/forge-std/src/console.sol";

contract HonorAmongThievesSolution is Script {
  Rivals public level = Rivals(payable(0xFe81db42aBB0dafFAEec7D311996BB2beA69c529));
  Setup public level_setup = Setup(payable(0x555f4200ba7D49D435A41157F300E70346B8050A));

  function run() external { 
    vm.startBroadcast(vm.envUint("PRIVATE_KEY_HONOR_AMONG_THIEVES"));
    

    vm.stopBroadcast();

  }
} 

/*
$ cast logs --rpc-url http://94.237.50.242:48179/rpc "event Voice(uint256 indexed severity)" --from-block earliest --to-block latest

- address: 0x9122148cbb66fAD7A1e047A11a9baBb6303F8a68
  blockHash: 0x77b87de4589807cf76061de6be944fa44f7ebc853fbd29f1e43e8fca434658aa
  blockNumber: 96
  data: 0x
  logIndex: 0
  removed: false
  topics: [
        0x8be9391af7bcf072cee3c17fdbdfa444b42ad0d498941bcd0eb684da1ebe0d62
        0x0000000000000000000000000000000000000000000000000000000000000005
  ]
  transactionHash: 0xcb65f8095f172dabbb807040cb159874f388da7ee7ee034a5ac3b5aebe3b0b6c
  transactionIndex: 0

╰─$ cast tx 0xcb65f8095f172dabbb807040cb159874f388da7ee7ee034a5ac3b5aebe3b0b6c --rpc-url http://94.237.50.242:48179/rpc     

blockHash            0x77b87de4589807cf76061de6be944fa44f7ebc853fbd29f1e43e8fca434658aa
blockNumber          96
from                 0x9353f85a5D8f2e667d98D2f5FbDF24A2401BE73b
transactionIndex     0
effectiveGasPrice    0

accessList           []
chainId              31337
gasLimit             49445
hash                 0xcb65f8095f172dabbb807040cb159874f388da7ee7ee034a5ac3b5aebe3b0b6c
input                0x52eab0fae7796b4fa25a89c1ddc62815509a194e9ed3edffec0f12db323178684420fedc
maxFeePerGas         0
maxPriorityFeePerGas 0
nonce                95
r                    0xc1c9d4446c59ad922cea7fe1dc5b971971d72f3fe68e3a10bfbd63a412e779d8
s                    0x5853a9f741730fb3fa85f193a257009542bda6c142cc61080e3638c882881f15
to                   0x9122148cbb66fAD7A1e047A11a9baBb6303F8a68
type                 2
value                0
yParity              1


KEY = 0xe7796b4fa25a89c1ddc62815509a194e9ed3edffec0f12db323178684420fedc

╰─$ cast send --rpc-url http://94.237.50.242:48179/rpc --private-key 0xb9ffc3212e62e390f351f1826dc9bc3affb517e279bbb9ffa2627444e6ba956e 0x9122148cbb66fAD7A1e047A11a9baBb6303F8a68 0x52eab0fae7796b4fa25a89c1ddc62815509a194e9ed3edffec0f12db323178684420fedc 

blockHash               0x6bbc29bb439679927492399dcd48c7bfd896718be20ef153c0419a00b8e5314d
blockNumber             152
contractAddress         
cumulativeGasUsed       32345
effectiveGasPrice       1
from                    0x07d60ADE60635Cf72808cfA29073F4410F44bA04
gasUsed                 32345
logs                    [{"address":"0x9122148cbb66fad7a1e047a11a9babb6303f8a68","topics":["0x8be9391af7bcf072cee3c17fdbdfa444b42ad0d498941bcd0eb684da1ebe0d62","0x0000000000000000000000000000000000000000000000000000000000000005"],"data":"0x","blockHash":"0x6bbc29bb439679927492399dcd48c7bfd896718be20ef153c0419a00b8e5314d","blockNumber":"0x98","blockTimestamp":"0x676f57f2","transactionHash":"0x254ea01b641f2659133cdd61ab6a9fc5ecad787fe02720f926c13639fd19d7f4","transactionIndex":"0x0","logIndex":"0x0","removed":false}]
logsBloom               0x00000000000000100000000000000000000000000000000000000000400000001000001000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000001000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000001000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
root                    
status                  1 (success)
transactionHash         0x254ea01b641f2659133cdd61ab6a9fc5ecad787fe02720f926c13639fd19d7f4
transactionIndex        0
type                    2
blobGasPrice            1
blobGasUsed             
authorizationList       
to                      0x9122148cbb66fAD7A1e047A11a9baBb6303F8a68
root             "0xc098dfb11a688dce27abe8ed872de2fac1810146e896b7e0a3f678914836ea05"
*/