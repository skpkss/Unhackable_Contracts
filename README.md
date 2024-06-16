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

