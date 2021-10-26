## Mission Detail


### Mission 1 Sign Genesis Block

<details>
<summary>detail</summary>

0. upgrade node version

**IMPORTANT**

All participants are required to upgrade their node to `neuron-1.1` before genesis launch.

ref: https://github.com/cosmos-gaminghub/nibiru/releases/tag/neuron-1.1

```sh
cd nibiru
git fetch --all --tags
git checkout -b neuron-1.1 tags/neuron-1.1
make install
```

Check version with the command:
```sh
nibirud version
neuron-1.1
```

1. get genesis.json
```sh
curl -o $HOME/.nibiru/config/genesis.json https://raw.githubusercontent.com/cosmos-gaminghub/testnets/master/neuron-1/genesis.json
```

2. check genesis.json is correct

```sh
shasum -a 256 .nibiru/config/genesis.json
cdd706fe8060bba8c2aa8443c0314cb8f4d719bcb691a325bb989a06c682ccb1  .nibiru/config/genesis.json
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
seeds = "ac175b66221b555751b3a5fb2e6a8844ba01228d@167.179.104.210:26656"
```

You can also use Neuron Incentive Testnet Community Seed Node in [hackmd](https://hackmd.io/y_JUOikHTvudW90oGySdWw)

4.1 Edit the app.toml file to prevent spamming. It rejects incoming transactions with less than the minimum gas prices.
```
sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.0001ugame"/g' ~/.nibiru/config/app.toml
```

5. start
```
nibirud start
```


6. check sign status
```
curl  -s localhost:26657/dump_consensus_state | jq '.result.round_state.votes[0]'
```

That command shows all the info about validator sign status.

You can find your validator pubkey in `priv_validator_state.json`. If you've already signed, you can find your pubkey in the sign status.

**CheckPoint**
- Does the validator commit genesis block (http://167.179.104.210:26657/commit?height=1) after the successful launch

**Attention**

The team has prepared four validator nodes in advance to prevent the launch delay due to lack of voting power. These validators will be online and signed at Oct 20th 11:30 GMT. Therefore, please note that you must be online between Oct 20th 11:00 and 11:30 GMT in order to clear Mission 1.

</details>


### Mission 2 Share P2P(26656) & RPC(26657) Node
**Deadline: Oct 28th 11:00 GMT**
- set up the node with P2P & RPC endpoint open
- write P2P and RPC info in [hackmd](https://hackmd.io/y_JUOikHTvudW90oGySdWw)
- hackmd will be read-only mode after deadline

**CheckPoint**
- Does the node has valid RPC endpoint (port:26657)

### Mission 3/4/5
**Deadline: November 3, 2021 11:00 GMT**

**CheckPoint**
- Does the registered address send designated txs(`/cosmos.staking.v1beta1.MsgDelegate`,`/cosmos.gov.v1beta1.MsgVote`,`/ibc.applications.transfer.v1.MsgTransfer`) more than the required number of times

**Mission 5 Hint** : Participants are required to build relayer to successfully send IBC transfer txs (or free ride someone's relayer channel).

### ~~Mission 6~~
Because of [the node restart crash issue](https://github.com/cosmos-gaminghub/testnets/issues/371), we decided to skip this task and all participants will be considered to have completed this task.

### Mission 7
**CheckPoint**
- Does the validator emit no `slash` event in BeginBlockEvent before the end of Spam Tx Ranker Battle

### Mission 8

**Period: October 31, 2021 11:00 GMT - November 3, 2021 11:00 GMT**

Sign twice in the same hieght block and get jailed intentionally.

- Does the validator succeed to be slashed because of double sign (not because of missing_signature)

### Liveness Ranker Battle

**Period: October 20, 2021 11:00 GMT - November 3, 2021 11:00 GMT**

**CheckPoint**
- The challenge is to see how few the validator emit `liveness` (missed blocks) event in BeginBlockEvent.
- If a validator will double sign and be slashed before November 3, 2021 11:00 GMT, the validator will be considered missing blocks from slashed time to the end of the testnet.

ref: https://github.com/cosmos/cosmos-sdk/blob/master/x/slashing/spec/06_events.md

### Spam Tx Ranker Battle

**Period: October 28, 2021 11:00 GMT - October 31, 2021 11:00 GMT (3 days)**

**CheckPoint**
- The challenge is to see how many txs can be sent from **the registered address** during Spam Tx Rank Battle Period.
- Transactions from operator address will not be counted (Ex. `/cosmos.slashing.v1beta1.MsgUnjail`, `/cosmos.staking.v1beta1.MsgEditValidator`).

**Attention**

The share of team's node voting power will be distributed through redelegating process before the Spam Tx Ranker Battle. At the time of redelegating, all active validators will be uniformly delegated from team to equalize the block propose opportunity.
