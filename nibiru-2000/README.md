# nibiru-2000

- Go version: [v1.16+](https://golang.org/dl/)
- Nibirud version: [v0.3](https://github.com/cosmos-gaminghub/nibiru/releases/tag/v0.3)

## GenTx Collection ( Until September 1st, 2021 11:00 GMT)
1. Initialize the nibiru directories and create the local file with the correct chain-id

```
nibirud init <moniker> --chain-id=nibiru-2000
```

2. Create a local key pair in the keybase
```
nibirud keys add <your key name>
```

3. Add tour account to your local genesis file with a given amount and key you just created.
```
nibirud add-genesis-account $(nibirud keys show <your key name> -a) 100000000000game
```

4. Create the gentx
```
nibirud gentx <your key name> 100000000000game --commission-rate=0.1 --commission-max-rate=1 --commission-max-change-rate=0.1 --pubkey $(nibirud tendermint show-validator) --chain-id=nibiru-2000

```

5. Create Pull Request to this repository ([gentxs](./gentxs)).


## Start

1. get genesis.json
```sh
curl -o $HOME/.nibiru/config/genesis.json https://raw.githubusercontent.com/cosmos-gaminghub/testnets/master/latest/genesis.json
```

2. check genesis.json is correct

```sh
shasum -a 256 .nibiru/config/genesis.json
12b40d0c660e65f5a78e6b5bd90298a4d3cdeffeb5fdcb069ee789d254c2fdad  .nibiru/config/genesis.json
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

```
vim $HOME/.nibiru/config/config.toml
```

```
seeds = "42de54ab0ea03b96b28ca43818d9d27cbeb231bc@167.179.117.190:26656"
```

5. start!
```
nibirud start
```


6. check sign status
```
curl  -s localhost:26657/dump_consensus_state | jq '.result.round_state.votes[0]'
```

You can find your validator pubkey in `priv_validator_state.json`. If you've already signed, you can check in the sign status.
