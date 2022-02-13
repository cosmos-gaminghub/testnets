# Game Pre Testnet

Game Pre Testnet is the final testnet before mainnet launch for genesis validators. The main purpose of this testnet is to simulate mainnet launch process with the orchestration of validators. Validators are required to check their address is correct and submit gentx in a right way.

**This testnet is mainly for Neuron Testnet Winners. Check your reward** [**here**](https://github.com/cosmos-gaminghub/mainnet/tree/main/accounts)

- Go version: [v1.17+](https://golang.org/dl/)
- Nibirud version: [v1.0-rc1](https://github.com/cosmos-gaminghub/nibiru/releases/tag/v1.0-rc1)


## Schedule
**Genesis Validators Application Period**

Until February 12, 2022 11:00 GMT

- ~~[**Submit Gentx**](#gentx-collection)~~

**Genesis Launch**

February 14, 2022 11:00 GMT

## genesis params (changed from default)

Check [here](https://github.com/cosmos-gaminghub/mainnet/blob/main/parameter.md) about genesis params for mainnet.


## GenTx Collection

<details>
<summary>detail</summary>

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

</details>


## Genesis Launch

1. Get genesis.json.gz
```sh
curl -o $HOME/.nibiru/config/genesis.json.gz https://raw.githubusercontent.com/cosmos-gaminghub/testnets/master/game-pre/genesis.json.gz
```

2. Check genesis.json.gz is correct

```sh
shasum -a 256 ~/.nibiru/config/genesis.json.gz
57072db21451fcb6be0bf626ad96fb2ab0ac34b1173b1322318567bcef3d47e9  /root/.nibiru/config/genesis.json.gz
```

3.  unzip genesis.json.gz
```sh
gzip -d ~/.nibiru/config/genesis.json.gz

```

4. Check your validator state is initial

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

5. Add seed node info

```sh
sed -i -e "s%^seeds *=.*%seeds = \"1029d637f2ef514833394d2f7b12e93bb2537d1a@167.179.113.103:26656,7d2170f974a250ab1b9f2c269268cc5f2eb8eb37@198.13.50.199:26656\"%; " $HOME/.nibiru/config/config.toml
```

6. Create a service file
```sh
printf "[Unit]
Description=Game Node
After=network-online.target

[Service]
User=$USER
ExecStart=`which nibirud` start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/nibirud.service
```

7. Run the service file
```sh
sudo systemctl daemon-reload
sudo systemctl enable nibirud
sudo systemctl restart nibirud
```

8. View a log of the node
```sh
sudo journalctl -fn 100 -u nibirud
```

If you run before the genesis time, you can see the message `Genesis time is in the future. Sleeping until then...`.

9. Check sign status
```
curl  -s localhost:26657/dump_consensus_state | jq '.result.round_state.votes[0]'
```

That command shows all the info about validator sign status.

You can find your validator pubkey in `priv_validator_state.json`. If you've already signed, you can find your pubkey in the sign status.


**Attention**

The team has prepared **NO** validator node so that there is a potential launch delay due to lack of voting power. We will wait +2 hours from planned launch time but if voting power is not sufficiently gathered, we will publish new genesis.json with team validators and launch next day.
