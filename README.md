# Smart Contract Audits and Testing
  Welcome to my smart contract audit and testing repository. This project showcases my skills in carefully auditing smart contracts to ensure their security and optimize gas usage. The repository contains smart contracts that have been audited using [Slither](https://github.com/crytic/slither) and [Echidna](https://github.com/crytic/echidna). Tested using [Foundry](https://github.com/foundry-rs/foundry) .

 ## Terminal Installation Commands
 1.Foundry(for development and testing):
  ```
curl -L https://foundry.paradigm.xyz | bash
```
Open another terminal.Then run:
```
foundryup
```
For compilation, run:
```
forge build
```
Written tests including fuzz tests.Check them out in the tests folders. For testing them, run:
```
forge test
```
Running tests for particular Smart Contracts:
```
forge test --match-path test/CryptoWalletInsurance.t.sol
forge test --match-path test/CollateralProtectionInsurance.t.sol
```
2.Slither(used for static analysis):
 ```
 pip3 install slither-analyzer 
```
Using Slither for particular smart contracts:
```
cd src
slither CryptoWalletInsurance.sol
slither CollateralProtectionInsurance.sol
```
3.solc (Solidity Compiler):
 ```
pip3 install solc-select
solc-select install 0.8.26
solc-select use 0.8.26
```
4.Echidna(for more advanced fuzz testing)
```
brew install echidna
```
Using echidna for particular smart contracts:
```
cd src
echidna CollateralProtectionInsurance.sol --contract CollateralProtectionInsuranceEchidnaTest
echidna CryptoWalletInsurance.sol --contract CryptoWalletInsuranceEchidnaTest
```
We will se results like this after running fuzz tests:

![ech2](https://github.com/skpkss/Unhackable_Contracts/assets/107455544/7fff890a-244f-4b47-8f5b-526ec03a1419)
![ech3](https://github.com/skpkss/Unhackable_Contracts/assets/107455544/5df37520-ade1-482b-a0d8-d9a1a323cfd3)

