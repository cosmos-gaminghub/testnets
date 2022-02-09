# Game Pre Testnet

Game Pre Testnet is the final testnet before mainnet launch for genesis validators. The main purpose of this testnet is to simulate mainnet launch process with the orchestration of validators. Validators are required to check their address is correct and submit gentx in a right way.

**This testnet is mainly for Neuron Testnet Winners. Check your reward** [**here**](https://github.com/cosmos-gaminghub/mainnet/tree/main/accounts)

- Go version: [v1.17+](https://golang.org/dl/)
- Nibirud version: [v1.0-rc1](https://github.com/cosmos-gaminghub/nibiru/releases/tag/v1.0-rc1)


## Schedule
**Genesis Validators Application Period**

Until February 12, 2022 11:00 GMT

- [**Submit Gentx**](#gentx-collection)

**Genesis Launch**

February 14, 2022 11:00 GMT

## genesis params (changed from default)

Check [here](https://github.com/cosmos-gaminghub/mainnet/blob/main/parameter.md) about genesis params for mainnet.


## GenTx Collection


0. Install nibiru
```
git clone https://github.com/cosmos-gaminghub/nibiru.git
cd nibiru && git checkout -b v1.0-rc1 tags/v1.0-rc1
make install
```


Make sure to checkout to `v1.0-rc1` tag.

1. Initialize the nibiru directories and create the local file with the correct chain-id

```
nibirud init <moniker> --chain-id=game-pre
```

2. Use the same key you registered in the neuron testnet

```
nibirud keys add <your key name> --recover
```

If you have lost your private key and want to change the reward address, please contact us on discord with the info below

- validator name
- old address
- new address


3. Add the account to your local genesis file with a given amount. Check the amount of GAME in your address [here](https://github.com/cosmos-gaminghub/mainnet/blob/main/accounts/incentivized_testnet_rewards.json).

```
nibirud add-genesis-account $(nibirud keys show <your key name> -a) <your initial bonding amount>ugame
```

4. Create the gentx
Commission rate should NOT be less than 5% for the network decentralization.
You can not bond more than you have.

```
nibirud gentx <your key name> <your initial bond amount>ugame --commission-rate=0.1 --commission-max-rate=1 --commission-max-change-rate=0.1 --pubkey $(nibirud tendermint show-validator) --chain-id=game-pre
```

5. Create Pull Request to this repository ([game-pre/gentxs](./gentxs)) with the file `<your validator moniker>.json`.

