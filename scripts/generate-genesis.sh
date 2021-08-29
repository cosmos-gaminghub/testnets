#!/bin/bash

NETWORK=nibiru-2000
DAEMON=nibirud
HOME_DIR=~/.nibiru
CONFIG=~/.nibiru/config
TOKEN_DENOM=game
#FAUCET_ACCOUNTS=("" "")

rm -rf $HOME_DIR

$DAEMON init $NETWORK --chain-id $NETWORK

rm -rf $CONFIG/gentx && mkdir $CONFIG/gentx

sed -i "s/\"stake\"/\"$TOKEN_DENOM\"/g" $HOME_DIR/config/genesis.json

for i in $NETWORK/gentxs/*.json; do
  echo $i
  $DAEMON add-genesis-account $(jq -r '.body.messages[0].delegator_address' $i) 100000000000$TOKEN_DENOM
  cp $i $CONFIG/gentx/
done

#for addr in "${FAUCET_ACCOUNTS[@]}"; do
    #echo "Adding faucet addr: $addr"
    #$DAEMON add-genesis-account $addr 100000000000$TOKEN_DENOM
#done

$DAEMON collect-gentxs

$DAEMON validate-genesis

cp $CONFIG/genesis.json $NETWORK
