sed -i -e 's/"max_validators": 100/"max_validators": 300/' genesis.json
sed -i -e 's/"send_enabled": true/"send_enabled": false/' genesis.json
sed -i -e 's/"receive_enabled": true/"receive_enabled": false/' genesis.json
sed -i -e 's/"signed_blocks_window": "100"/"signed_blocks_window": "10000"/' genesis.json
sed -i -e 's/"min_signed_per_window": "0.500000000000000000"/"min_signed_per_window": "0.050000000000000000"/' genesis.json
sed -i -e 's/"unbonding_time": "1814400s"/"unbonding_time": "86400s"/' genesis.json
sed -i -e 's/"voting_period": "172800s"/"voting_period": "86400s"/' genesis.json
