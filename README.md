# How to use this repo

Run each test separately and sum up the gas from the hardhat gas report plugin.

## Steps

Make sure you have a `.env` file with gas reporting turned on:

```
REPORT_GAS=1
```

Then run each test on its own, e.g.

```sh
yarn test test/Descriptor-sstore-deflate.test.ts
```

In the gas report when a function is called more than once, multiply the `Avg` gas used times `# calls`.
Example output where such multiplication is needed:

```sh
Descriptor MultiRLE
    ✓ deploy and populate

·------------------------------------------------------------|---------------------------|---------------|-----------------------------·
|                    Solc version: 0.8.12                    ·  Optimizer enabled: true  ·  Runs: 10000  ·  Block limit: 30000000 gas  │
·····························································|···························|···············|······························
|  Methods                                                                                                                             │
·································|···························|·············|·············|···············|···············|··············
|  Contract                      ·  Method                   ·  Min        ·  Max        ·  Avg          ·  # calls      ·  eur (avg)  │
·································|···························|·············|·············|···············|···············|··············
|  MultiRleNounsDescriptor       ·  addManyAccessories       ·     568686  ·    1112006  ·       748926  ·           14  ·          -  │
·································|···························|·············|·············|···············|···············|··············
|  MultiRleNounsDescriptor       ·  addManyBackgrounds       ·          -  ·          -  ·       103897  ·            1  ·          -  │
·································|···························|·············|·············|···············|···············|··············
|  MultiRleNounsDescriptor       ·  addManyBodies            ·          -  ·          -  ·      2118910  ·            1  ·          -  │
·································|···························|·············|·············|···············|···············|··············
|  MultiRleNounsDescriptor       ·  addManyGlasses           ·          -  ·          -  ·      2026309  ·            1  ·          -  │
·································|···························|·············|·············|···············|···············|··············
|  MultiRleNounsDescriptor       ·  addManyHeads             ·     657267  ·    2087296  ·      1601096  ·           24  ·          -  │
·································|···························|·············|·············|···············|···············|··············
|  MultiRleNounsDescriptor       ·  setArt                   ·          -  ·          -  ·        49268  ·            1  ·          -  │
·································|···························|·············|·············|···············|···············|··············
|  MultiRleNounsDescriptor       ·  setPalette               ·          -  ·          -  ·       246018  ·            1  ·          -  │
·································|···························|·············|·············|···············|···············|··············
|  Deployments                                               ·                                           ·  % of limit   ·             │
·····························································|·············|·············|···············|···············|··············
|  contracts/multi-rle/libs/NFTDescriptor.sol:NFTDescriptor  ·          -  ·          -  ·       694137  ·        2.3 %  ·          -  │
·····························································|·············|·············|···············|···············|··············
|  MultiRleNounsDescriptor                                   ·          -  ·          -  ·      2555102  ·        8.5 %  ·          -  │
·····························································|·············|·············|···············|···············|··············
|  NounsArt                                                  ·          -  ·          -  ·      1108543  ·        3.7 %  ·          -  │
·····························································|·············|·············|···············|···············|··············
|  SVGRenderer                                               ·          -  ·          -  ·      1727158  ·        5.8 %  ·          -  │
·------------------------------------------------------------|-------------|-------------|---------------|---------------|-------------·
```

# Results on 2022-06-07

| Test                       | Gas sum    |
| -------------------------- | ---------- |
| Descriptor baseline        | 67,285,651 |
| Descriptor MultiRLE        | 59,540,610 |
| Descriptor MultiRLE SSTORE | 14,368,017 |
