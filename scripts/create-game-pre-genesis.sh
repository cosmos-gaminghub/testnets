#!/bin/bash -eu
set -eu

NETWORK=game-pre
DAEMON=nibirud
HOME_DIR=~/.nibiru
CONFIG=~/.nibiru/config
TOKEN_DENOM=ugame
GENESIS=$HOME_DIR/config/genesis.json

rm -rf $HOME_DIR

$DAEMON init $NETWORK --chain-id $NETWORK

rm -rf $CONFIG/gentx && mkdir $CONFIG/gentx

gzip -d $NETWORK/pre-genesis.json.gz
cp $NETWORK/pre-genesis.json $GENESIS

for i in $NETWORK/gentxs/*.json; do
  echo $i
  cp $i $CONFIG/gentx/
done

$DAEMON collect-gentxs

$DAEMON validate-genesis

cp $GENESIS $NETWORK

timeout 20s $DAEMON start || ( [[ $? -eq 124 ]] && \
echo "WARNING: Timeout reached, but that's OK" )
