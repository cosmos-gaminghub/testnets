# nibiru-3000 Testnet

nibiru-3000 is the final testnet before mainnet launch. The main purpose of this testnet is to simulate upgrade process with the orchestration of validators. Besides we will test pre-released GAME GS Pad which allows users to interact with our blockchain through governance and staking.

- Go version: [v1.17+](https://golang.org/dl/)
- Nibirud version: [v0.9](https://github.com/cosmos-gaminghub/nibiru/releases/tag/v0.9)


## Schedule
**Genesis Validators Application Period**

Until January 19, 2022 11:00 GMT

- ~~[**Submit Gentx**](#gentx-collection)~~

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

<details>
<summary>detail</summary>

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

</details>


## Genesis Launch

1. get genesis.json
```sh
curl -o $HOME/.nibiru/config/genesis.json https://raw.githubusercontent.com/cosmos-gaminghub/testnets/master/nibiru-3000/genesis.json
```

2. check genesis.json is correct

```sh
shasum -a 256 ~/.nibiru/config/genesis.json
0ef249be8ba5706d5702eb55834035bbc06744be70bb64d8d57aacea70d36445  /root/.nibiru/config/genesis.json
```

3. check your validator state is initial

correct ex:
```sh
cat .nibiru/data/priv_validator_state.json
{
  "height": "0",
  "round": 0,
  "step": 0
}
```

If you have already started, then should reset the state with the command `nibirud unsafe-reset-all`. The command delete all blockchain data but keep genesis.json and node configs.

4. add seed node info

```sh
vim $HOME/.nibiru/config/config.toml
```

```sh
4d6c590024b3a24985e910b172fc3b7d3493648a@45.32.39.253:26656
```

5. start
```
nibirud start
```

If you run before the genesis time, you can see the message `Genesis time is in the future. Sleeping until then...`.

6. check sign status
```
curl  -s localhost:26657/dump_consensus_state | jq '.result.round_state.votes[0]'
```

That command shows all the info about validator sign status.

You can find your validator pubkey in `priv_validator_state.json`. If you've already signed, you can find your pubkey in the sign status.


**Attention**

The team has prepared **NO** validator node so that there is a potential launch delay due to lack of voting power. We will wait +2 hours from planned launch time but if voting power is not sufficiently gathered, we will publish new genesis.json with team validators and launch next day.

## Node Upgrade Event
In this testnet, we will update nibirud version from v0.9 to [sm-upgrade](https://github.com/cosmos-gaminghub/nibiru/releases/tag/sm-upgrade).
We will experience `softwareUpgrade` through governance voting, and all nodes(including validators) are required to switch their binary at the designated block height. Manual update and automatic update are both fine. If you haven't try automatic update with `Cosmovisor`, you can try in this testnet.

Check how to use Cosmovisor in [our docs](https://docs.gamenet.one/config/cosmovisor.html).
