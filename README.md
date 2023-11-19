## Simple NFT Marketplace

Sellers can sell() their NFT while specifying a price and expiration. Instead of depositing the NFT into the contract, they give the contract approval to withdraw it from them. If a buyer comes along and pays the specified price before the expiration, then the NFT is transferred from the seller to the buyer and the buyer’s ether is transferred to the seller.

The seller can cancel() the sale at any time.

Corner cases:

What if the seller lists the same NFT twice? This can theoretically happen since they don't transfer the NFT to the marketplace

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
