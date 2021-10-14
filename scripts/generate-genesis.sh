#!/bin/bash

NETWORK=neuron-1
DAEMON=nibirud
HOME_DIR=~/.nibiru
CONFIG=~/.nibiru/config
TOKEN_DENOM=ugame
FAUCET_ACCOUNTS=(
  "game1as53rfgmtg92aga7tuxmv3kj4qr5j347ahk0t0"
  "game1sa4zt93ymsvfqkpwn27950uaurv2jp4dz86e3d"
)

rm $CONFIG/genesis.json

$DAEMON init $NETWORK --chain-id $NETWORK

rm -rf $CONFIG/gentx && mkdir $CONFIG/gentx

sed -i "s/\"stake\"/\"$TOKEN_DENOM\"/g" $HOME_DIR/config/genesis.json

for i in $NETWORK/gentxs/*.json; do
  echo $i
  $DAEMON add-genesis-account $(jq -r '.body.messages[0].delegator_address' $i) 100000000000$TOKEN_DENOM
  cp $i $CONFIG/gentx/
done

# for team validators
#for i in $NETWORK/gentxs/cgh/*.json; do
#  echo $i
#  $DAEMON add-genesis-account $(jq -r '.body.messages[0].delegator_address' $i) 500000000000$TOKEN_DENOM
#  cp $i $CONFIG/gentx/
#done

for addr in "${FAUCET_ACCOUNTS[@]}"; do
    echo "Adding faucet addr: $addr"
    $DAEMON add-genesis-account $addr 90000000000000$TOKEN_DENOM
done

$DAEMON collect-gentxs

$DAEMON validate-genesis

cp $CONFIG/genesis.json $NETWORK

timeout 10s nibirud start || ( [[ $? -eq 124 ]] && \
echo "WARNING: Timeout reached, but that's OK" )
