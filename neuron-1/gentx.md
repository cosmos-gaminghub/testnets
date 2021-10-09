# Neuron Incentivized Testnet Gentx

- Go version: [v1.16+](https://golang.org/dl/)
- Nibirud version: [neuron-1](https://github.com/cosmos-gaminghub/nibiru/releases/tag/neuron-1)

## genesis params (changed from default)

```
"signed_blocks_window": "10000"
"min_signed_per_window": "0.050000000000000000"
"unbonding_time": "259200s"
"send_enabled": "false"
"receive_enabled": "false"
```
- You have to keep up at least 5% in the last 10000block for avoid downtime slashing.
- You have to wait 3days to unbond your token.


## GenTx Collection (Until October 17, 2021 11:00 GMT)
0. Install nibiru
```
git clone https://github.com/cosmos-gaminghub/nibiru.git
cd nibiru && git checkout -b neuron-1 tags/neuron-1
make install
```

Make sure to checkout to `neuron-1` tag.

1. Initialize the nibiru directories and create the local file with the correct chain-id

```
nibirud init <moniker> --chain-id=neuron-1
```

2. Create a local key pair in the keybase
```
nibirud keys add <your key name>
```

※Make sure to keep neumonic seed which will be used to receive rewards at the time of mainnet launch.

3. Add the account to your local genesis file with a given amount and key you just created.
```
nibirud add-genesis-account $(nibirud keys show <your key name> -a) 100000000000ugame
```

4. Create the gentx
```
nibirud gentx <your key name> 100000000000ugame --commission-rate=0.1 --commission-max-rate=1 --commission-max-change-rate=0.1 --pubkey $(nibirud tendermint show-validator) --chain-id=neuron-1
```

5. Create Pull Request to this repository ([neuron-1/gentxs](./gentxs)) with the file `<your validator moniker>.json`.

6. Submit [the application form](https://forms.gle/BHgLRhmyrHoWzLj17) to finish registration process completely.
