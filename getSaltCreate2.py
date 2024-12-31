from web3 import Web3
import concurrent.futures

def compute_address(deployer_address, salt, bytecode):
    # Corrigir passando o bytecode como hexstr
    return Web3.to_checksum_address(Web3.solidity_keccak(
        ['bytes1', 'address', 'bytes32', 'bytes32'],
        ['0xff', deployer_address, salt, Web3.keccak(hexstr=bytecode)]
    )[12:])


def find_salt_in_range(deployer_address, desired_address, bytecode, start, end):
    print(f"Thread processando intervalo: {start} até {end}")
    for i in range(start, end):
        salt = Web3.to_bytes(i)
        computed = compute_address(deployer_address, salt, bytecode)
        
        # Print do progresso a cada 100_000 iterações
        if i % 100_000 == 0:
            print(f"Testando salt {i}: {computed}")

        if computed == desired_address:
            print(f"Salt encontrado para o endereço desejado: {computed}")
            return salt
        elif computed == "0xFC31cde4aCbF2b1d2996a2C7f695E850918e4007":
            print(f"Salt encontrado para 0xFC31cde4aCbF2b1d2996a2C7f695E850918e4007: {computed}")
            return salt
        elif computed == "0xFc2D16b59Ec482FaF3A8B1ee6E7E4E8D45Ec8bf1":
            print(f"Salt encontrado para 0xFc2D16b59Ec482FaF3A8B1ee6E7E4E8D45Ec8bf1: {computed}")
            return salt
    return None


def find_salt_multithreaded(deployer_address, desired_address, bytecode, start, end, num_threads):
    step = (end - start) // num_threads
    ranges = [(start + i * step, start + (i + 1) * step) for i in range(num_threads)]
    # Certifique-se de que o último intervalo vai até o final
    ranges[-1] = (ranges[-1][0], end)

    with concurrent.futures.ThreadPoolExecutor(max_workers=num_threads) as executor:
        futures = [executor.submit(find_salt_in_range, deployer_address, desired_address, bytecode, r[0], r[1]) for r in ranges]
        for future in concurrent.futures.as_completed(futures):
            salt = future.result()
            if salt is not None:
                # Cancelar todas as threads restantes
                executor.shutdown(cancel_futures=True)
                return salt
    return None


# Configurações
deployer_address = "0xB89EcCb84C7CA4D2d28ecb49617982D4FF4c8CcE"  # Substitua pelo endereço real do Deployer
desired_address = "0x598136Fd1B89AeaA9D6825086B6E4cF9ad2BD4cF"
bytecode = "0x608060405234801561000f575f80fd5b506102158061001d5f395ff3fe608060405234801561000f575f80fd5b506004361061003f575f3560e01c8063948cb71914610043578063e083296014610060578063f38195081461008e575b5f80fd5b61004b6100d9565b60405190151581526020015b60405180910390f35b61004b61006e366004610134565b805160208183018101805160018252928201919093012091525460ff1681565b6100c161009c366004610134565b80516020818301810180515f825292820191909301209152546001600160a01b031681565b6040516001600160a01b039091168152602001610057565b5f6001806040516100fa90696f72634b696e67646f6d60b01b8152600a0190565b908152604051908190036020019020805491151560ff1990921691909117905550600190565b634e487b7160e01b5f52604160045260245ffd5b5f60208284031215610144575f80fd5b813567ffffffffffffffff8082111561015b575f80fd5b818401915084601f83011261016e575f80fd5b81358181111561018057610180610120565b604051601f8201601f19908116603f011681019083821181831017156101a8576101a8610120565b816040528281528760208487010111156101c0575f80fd5b826020860160208301375f92810160200192909252509594505050505056fea2646970667358221220a8d7d2670a02cf69335ea034d77bbf4208d7234a03343057563d5faa7caa352064736f6c63430008180033"  # Substitua pelo bytecode do contrato

start = 10_000_000  # Início do intervalo de salt
end = 20_000_000    # Fim do intervalo de salt
num_threads = 8     # Número de threads

print("Iniciando busca multithreaded...")
salt = find_salt_multithreaded(deployer_address, desired_address, bytecode, start, end, num_threads)
if salt:
    print(f"Salt encontrado: {salt.hex()}")
else:
    print("Salt não encontrado.")
