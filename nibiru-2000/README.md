# nibiru-2000

- Go version: [v1.16+](https://golang.org/dl/)
- Nibirud version: [v0.3](https://github.com/cosmos-gaminghub/nibiru/releases/tag/v0.3)

## GenTx Collection ( Until August 28, 2021 11:00 GMT)
1. Initialize the nibiru directories and create the local file with the correct chain-id

```
nibirud init <moniker> --chain-id=nibiru-2000
```

2. Create a local key pair in the keybase
```
nibirud keys add <your key name>
```

3. Add tour account to your local genesis file with a given amount and key you just created.
```
nibirud add-genesis-account $(nibirud keys show eg -a) 100000000000game
```

4. Create the gentx
```
nibirud gentx <your key name> 100000000000game --commission-rate=0.1 --commission-max-rate=1 --commission-max-change-rate=0.1 --pubkey $(nibirud tendermint show-validator) --chain-id=nibiru-2000

```

5. Create Pull Request to this repository ([gentxs](./gentxs)).
