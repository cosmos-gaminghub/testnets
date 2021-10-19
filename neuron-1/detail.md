## Mission Detail

### Mission 1 Sign Genesis Block
0. upgrade node version

**IMPORTANT**

All participants are required to upgrade their node to `neuron-1.1` before genesis launch.


```sh
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

### Mission 2 Share Seed Node
**Deadline: Oct 28th 11:00 GMT**
- set up seed node with RPC endpoint open
- write seed info in [hackmd](https://hackmd.io/y_JUOikHTvudW90oGySdWw)

**CheckPoint**
- Does the seed has valid RPC endpoint (port:26657)

### Mission 3/4/5
**Deadline: November 3, 2021 11:00 GMT**

**CheckPoint**
- Does the registered address send designated txs

### Mission 6
TBA

### Mission 7
**CheckPoint**
- Does the validator emit no `slash` event in BeginBlockEvent before the end of Smap Tx Ranker Battle

### Mission 8
TBA

### Liveness Ranker Battle
**CheckPoint**
- The challenge is to see how few the validator emit `liveness` (missed blocks) event in BeginBlockEvent

ref: https://github.com/cosmos/cosmos-sdk/blob/master/x/slashing/spec/06_events.md

### Spam Tx Ranker Battle
**CheckPoint**
- The challenge is to see how many txs can be sent from the registered address during Spam Tx Rank Battle Period.
