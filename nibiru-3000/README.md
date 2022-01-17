# nibiru-3000 Testnet

nibiru-3000 is the final testnet before mainnet launch. The main purpose of this testnet is to simulate upgrade process with the orchestration of validators. Besides we will test pre-released GAME GS Pad which allows users to interact with our blockchain through governance and staking.

- Go version: [v1.17+](https://golang.org/dl/)
- Nibirud version: [v0.9](https://github.com/cosmos-gaminghub/nibiru/releases/tag/v0.9)


## Schedule
**Genesis Validators Application Period**

Until January 19, 2022 11:00 GMT

- [**Submit Gentx**](#gentx-collection)

**Genesis Launch**

January 21, 2022 11:00 GMT

**Node Upgrade Event**

January 26, 2022 11:00 GMT

## genesis params (changed from default)

```
"max_validators": 300
"send_enabled": false
"receive_enabled": false
"signed_blocks_window": "10000"
"min_signed_per_window": "0.050000000000000000"
"unbonding_time": "86400s"
"voting_period": "86400s"
```

- You have to keep up at least 5% in the last 10000block for avoid downtime slashing.
- You have to wait 1day to unbond your token.
- Voting period is 1day.


## GenTx Collection
0. Install nibiru
```
git clone https://github.com/cosmos-gaminghub/nibiru.git
cd nibiru && git checkout -b v0.9 tags/v0.9
make install
```

Make sure to checkout to `v0.9` tag.

1. Initialize the nibiru directories and create the local file with the correct chain-id

```
nibirud init <moniker> --chain-id=nibiru-3000
```

2. Create a local key pair in the keybase
```
nibirud keys add <your key name>
```

3. Add the account to your local genesis file with a given amount and key you just created.
```
nibirud add-genesis-account $(nibirud keys show <your key name> -a) 100000000000ugame
```

4. Create the gentx
```
nibirud gentx <your key name> 100000000000ugame --commission-rate=0.1 --commission-max-rate=1 --commission-max-change-rate=0.1 --pubkey $(nibirud tendermint show-validator) --chain-id=nibiru-3000
```

5. Create Pull Request to this repository ([nibiru-3000/gentxs](./gentxs)) with the file `<your validator moniker>.json`.


## Node Upgrade Event
In this testnet, we will update nibirud version from v0.9 to [sm-upgrade](https://github.com/cosmos-gaminghub/nibiru/releases/tag/sm-upgrade).
We will experience `softwareUpgrade` through governance voting, and all nodes(including validators) are required to switch their binary at the designated block height. Manual update and automatic update are both fine. If you haven't try automatic update with `Cosmovisor`, you can try in this testnet.

Check how to use Cosmovisor in [our docs](https://docs.gamenet.one/config/cosmovisor.html).
