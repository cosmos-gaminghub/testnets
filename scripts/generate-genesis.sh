#!/bin/bash

NETWORK=nibiru-2000
DAEMON=nibirud
HOME_DIR=~/.nibiru
CONFIG=~/.nibiru/config
TOKEN_DENOM=game
FAUCET_ACCOUNTS=(
  "nibiru1as53rfgmtg92aga7tuxmv3kj4qr5j3475u8653"
  "nibiru1sa4zt93ymsvfqkpwn27950uaurv2jp4dtvtvwn"
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
for i in $NETWORK/gentxs/cgh/*.json; do
  echo $i
  $DAEMON add-genesis-account $(jq -r '.body.messages[0].delegator_address' $i) 500000000000$TOKEN_DENOM
  cp $i $CONFIG/gentx/
done

for addr in "${FAUCET_ACCOUNTS[@]}"; do
    echo "Adding faucet addr: $addr"
    $DAEMON add-genesis-account $addr 90000000000000$TOKEN_DENOM
done

$DAEMON collect-gentxs

$DAEMON validate-genesis

cp $CONFIG/genesis.json $NETWORK

timeout 10s nibirud start || ( [[ $? -eq 124 ]] && \
echo "WARNING: Timeout reached, but that's OK" )
