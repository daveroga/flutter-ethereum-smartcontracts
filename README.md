# Flutter & Ethereum Smart Contracts
A sample of a Flutter app that interacts with Ethereum smart contracts through the web3dart package.

## Getting Started
This project assumes your Flutter installation is upgraded at least to version 2.0 in order to be able to run the solution in mobile platform (Android and iOS), web (Chrome) and desktop (Linux in our case).

To build and test the Ethereum smart contracts we make use of the tools Ganache and Truffle.



```
mkdir petadoption-contract
cd petadoption-contract
truffle unbox metacoin
```
---
**NOTE**

We use Metacoin as a base for our project in Truffle.

---
Once we have made the modifications with our PetAdoption contract we compile the smart contract solution with Truffle.

```
truffle compile
```
Then deploy the smart contract to Ganache by running Truffle migration. 
```
truffle migrate
```
After doing that, copy the contract address deployed that is shown in the terminal that will be used in next steps after creating the flutter project.
```
   Replacing 'PetAdoption'
   -----------------------
   > transaction hash:    0xa9df260e5db1ede92396062e5472639e766952e6d0a9852cefc1a9fe9b100d98
   > Blocks: 0            Seconds: 0
   > contract address:    0xd16fFF6F11Ee7956a98287Acacf1c54115641Dfa
   > block number:        4
   > block timestamp:     1615482513
   > account:             0xAf7D9F92D94EF8b3e3DaF7407d27F7277c50281d
   > balance:             99.9885349
   > gas used:            271269 (0x423a5)
   > gas price:           20 gwei
   > value sent:          0 ETH
   > total cost:          0.00542538 ETH

```
Create the flutter project by running next command.
```
flutter create --org com.example --project-name app_pet_adoption ./app-pet-adoption
```
Import dependencies in `pybspec.yaml` to connect and do transactions to smart contracts in Ethereum
```
web3dart: ^1.2.3
http: ^0.12.0
```
Create directory `assets` in the root of your Flutter project and add a file abi.json.
Then go to the Truffle project and go to the directory build/contracts and locate the PetAdoption.json file and copy the part `abi` from `[` to `]` included and paste it in the abi.json in the Flutter project.

Then include the asset abi.json in your pubspec.yaml in your Flutter project.
```
  assets:
  - assets/abi.json
```
This assets will be used by the package `web3dart` to load the contract.
