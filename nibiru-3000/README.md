# nibiru-3000 Testnet

nibiru-3000 is the final testnet before mainnet launch. The main purpose of this testnet is to simulate upgrade process with the orchestration of validators. Besides we will test pre-released GAME GS Pad which allows users to interact with our blockchain through governance and staking.

- Go version: [v1.17+](https://golang.org/dl/)
- Nibirud version: [v0.9](https://github.com/cosmos-gaminghub/nibiru/releases/tag/v0.9)


## Schedule
**Genesis Validators Application Period**

Until January 19, 2022 11:00 GMT

- ~~[**Submit Gentx**](#gentx-collection)~~

**~~Genesis Launch~~**

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
<details>
<summary>detail</summary>

1. Get genesis.json
```sh
curl -o $HOME/.nibiru/config/genesis.json https://raw.githubusercontent.com/cosmos-gaminghub/testnets/master/nibiru-3000/genesis.json
```

2. Check genesis.json is correct

```sh
shasum -a 256 ~/.nibiru/config/genesis.json
0ef249be8ba5706d5702eb55834035bbc06744be70bb64d8d57aacea70d36445  /root/.nibiru/config/genesis.json
```

3. Check your validator state is initial

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

4. Add seed node info

```sh
sed -i -e "s%^seeds *=.*%seeds = \"4d6c590024b3a24985e910b172fc3b7d3493648a@45.32.39.253:26656\"%; " $HOME/.nibiru/config/config.toml
```

5. Create a service file
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

6. Run the service file
```sh
sudo systemctl daemon-reload
sudo systemctl enable nibirud
sudo systemctl restart nibirud
```

7. View a log of the node
```sh
sudo journalctl -fn 100 -u nibirud
```

If you run before the genesis time, you can see the message `Genesis time is in the future. Sleeping until then...`.

8. Check sign status
```
curl  -s localhost:26657/dump_consensus_state | jq '.result.round_state.votes[0]'
```

That command shows all the info about validator sign status.

You can find your validator pubkey in `priv_validator_state.json`. If you've already signed, you can find your pubkey in the sign status.


**Attention**

The team has prepared **NO** validator node so that there is a potential launch delay due to lack of voting power. We will wait +2 hours from planned launch time but if voting power is not sufficiently gathered, we will publish new genesis.json with team validators and launch next day.

</details>

## Node Upgrade Event
In this testnet, we will update nibirud version from [v0.9](https://github.com/cosmos-gaminghub/nibiru/releases/tag/v0.9) to [sm-upgrade](https://github.com/cosmos-gaminghub/nibiru/releases/tag/sm-upgrade).
We will experience `softwareUpgrade` through governance voting, and all nodes(including validators) are required to switch their binary at the designated block height. Manual update and automatic update are both fine. If you haven't try automatic update with `Cosmovisor`, you can try in this testnet.

Check how to use Cosmovisor in [our docs](https://docs.gamenet.one/config/cosmovisor.html).


Check proposal info in [the nibiru-3000 explorer](http://nibiru-3000.game-explorer.io/).

```
proposals:
- content:
    '@type': /cosmos.upgrade.v1beta1.SoftwareUpgradeProposal
    description: In nibiru-3000 testnet, we will update nibirud version from v0.9
      to sm-upgrade. We will experience softwareUpgrade through governance voting,
      and all nodes(including validators) are required to switch their binary at 64000.
      Manual update and automatic update are both fine. After the upgrade is successful,
      you can use signal command.
    plan:
      height: "64000"
      info: '{"binaries":{"linux/amd64":"https://github.com/cosmos-gaminghub/nibiru/releases/download/sm-upgrade/nibirud-sm-upgrade?checksum=sha256:78d44fe51c1c04a7b0ec7b77cd197a324290659548d80d0d8526094512e8e70b"}}'
      name: signal-module-upgrade
      time: "0001-01-01T00:00:00Z"
      upgraded_client_state: null
    title: sm-upgrade
  deposit_end_time: "2022-01-27T03:04:52.511678383Z"
  final_tally_result:
    abstain: "0"
    "no": "0"
    no_with_veto: "0"
    "yes": "0"
  proposal_id: "1"
  status: PROPOSAL_STATUS_VOTING_PERIOD
  submit_time: "2022-01-25T03:04:52.511678383Z"
  total_deposit:
  - amount: "10000000"
    denom: ugame
  voting_end_time: "2022-01-26T03:06:18.766424741Z"
  voting_start_time: "2022-01-25T03:06:18.766424741Z"
```

### Action required

1. vote this proposal

You can vote simply from nibirud
```
nibirud tx gov vote 1 yes --from=<your wallet name> --chain-id=nibiru-3000

```

Other way is using [GAME GS Pad](https://gs-pad.gamenet.one/).


2. prepare for the update

If you are using Cosmovisor, you have to build `sm-module` binary before reaching upgrade height.


If you are not using Cosmovisor, you will see the message `ERR UPGRADE "sm-upgrade" NEEDED at height: 64000`, then stop nibirud process manually, update bianry and start again.
