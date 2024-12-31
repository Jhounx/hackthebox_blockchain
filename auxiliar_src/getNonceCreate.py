from web3 import Web3
import rlp
from eth_utils import to_bytes

def calculate_create_address(sender, nonce):
    # Codifica o sender e nonce usando RLP
    sender_bytes = to_bytes(hexstr=sender[2:])  # Remove "0x" e converte para bytes
    rlp_encoded = rlp.encode([sender_bytes, nonce])
    # Calcula o hash
    address = Web3.to_checksum_address(Web3.keccak(rlp_encoded)[12:])
    return address


def recursiveCalculation(): 
  for i in range(10_000_000):
    add = calculate_create_address(sender, i)
    print(add, end="\r")
    if (add == "0xFC31cde4aCbF2b1d2996a2C7f695E850918e4007"):
      print(f"Nonde: {i} Creates: 0xFC31cde4aCbF2b1d2996a2C7f695E850918e4007")
    elif (add == "0x598136Fd1B89AeaA9D6825086B6E4cF9ad2BD4cF"):
      print(f"Nonde: {i} Creates: 0x598136Fd1B89AeaA9D6825086B6E4cF9ad2BD4cF")
    elif (add == "0xFc2D16b59Ec482FaF3A8B1ee6E7E4E8D45Ec8bf1"):
      print(f"Nonde: {i} Creates: 0xFc2D16b59Ec482FaF3A8B1ee6E7E4E8D45Ec8bf1")

  
# Exemplo de uso
sender = "0xaDb67e10Fa330db49e98201B4c5F19356CfA3f59"  # Endereço do criador
recursiveCalculation()
